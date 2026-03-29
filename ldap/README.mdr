# OpenLDAP + LAM Stack

A local OpenLDAP server with [LDAP Account Manager (LAM)](https://www.ldap-account-manager.org/) web UI.

| Service   | URL / Port          | Description                  |
|-----------|---------------------|------------------------------|
| OpenLDAP  | `ldap://localhost:389`, `ldaps://localhost:636` | LDAP directory server |
| LAM       | http://localhost:8080 | Web UI for managing LDAP     |

## Default credentials

| What               | Value                          |
|--------------------|--------------------------------|
| LDAP admin DN      | `cn=admin,dc=example,dc=local` |
| LDAP admin password | `password`                    |
| LAM master password | `password`                    |
| Sample user password | `password`                   |

---

## Prerequisites

- Docker with Compose plugin
- `openssl` (for TLS certificate generation)

---

## First-Time Setup

These steps are required once before the first `docker compose up`.

### Step 1 — Generate TLS certificate

Creates a self-signed certificate for `ldap.example.local` / `127.0.0.1`
in `certs/ldap.crt` and `certs/ldap.key`. Edit `gen-cert.sh` to change
the CN or IP before running if needed.

```sh {"cwd":"/home/serafin/work/apps4tests/ldap","name":"gen-cert"}
bash gen-cert.sh
```

### Step 2 — Seed LAM configuration

Copies the default LAM config files from the Docker image into `./data/lam/`.
Must be run once (or after deleting `data/lam/`).

```sh {"cwd":"/home/serafin/work/apps4tests/ldap","name":"init-lam-config"}
bash init-lam-config.sh
```

---

## Start the Stack

Builds the custom OpenLDAP image and starts both services in the background.

```sh {"cwd":"/home/serafin/work/apps4tests/ldap","name":"compose-up"}
docker compose up -d --build
```

### Check container status

```sh {"cwd":"/home/serafin/work/apps4tests/ldap","name":"compose-status"}
docker compose ps
```

### Follow logs

```sh {"cwd":"/home/serafin/work/apps4tests/ldap","name":"compose-logs","terminalRows":"17"}
docker compose logs -f
```

---

## Populate the Directory

Run once after the stack is up to load the OU structure, proxy user, and
sample users/groups. Safe to re-run — existing entries are skipped.

```sh {"cwd":"/home/serafin/work/apps4tests/ldap","name":"populate"}
bash populate.sh
```

This loads two LDIF files in order:

| File                  | Contents                                             |
|-----------------------|------------------------------------------------------|
| `ldif/01-structure.ldif` | `ou=people`, `ou=groups`, `cn=proxyuser`          |
| `ldif/02-sample.ldif`    | 3 sample users + 2 groups (see below)             |

### Sample users

| UID      | Full name   | Mail                    | Groups     |
|----------|-------------|-------------------------|------------|
| `jdoe`   | John Doe    | jdoe@example.local      | developers |
| `jsmith` | Jane Smith  | jsmith@example.local    | developers |
| `aadmin` | Alice Admin | aadmin@example.local    | admins     |

### Sample groups

| CN           | Members          |
|--------------|------------------|
| `developers` | jdoe, jsmith     |
| `admins`     | aadmin           |

---

## Verify the Directory

Search all entries anonymously:

```sh {"cwd":"/home/serafin/work/apps4tests/ldap","name":"ldap-search"}
docker compose exec openldap ldapsearch \
  -x -H ldapi:/// \
  -b "dc=example,dc=local" \
  "(objectclass=*)" dn
```

Test a user bind (authenticate as `jdoe`):

```sh {"cwd":"/home/serafin/work/apps4tests/ldap","name":"ldap-bind-test"}
docker compose exec openldap ldapsearch \
  -x -H ldap://localhost:389 \
  -D "uid=jdoe,ou=people,dc=example,dc=local" \
  -w password \
  -b "uid=jdoe,ou=people,dc=example,dc=local"
```

---

## Stop the Stack

```sh {"cwd":"/home/serafin/work/apps4tests/ldap","name":"compose-down"}
docker compose down
```

To also remove persisted data volumes:

```sh {"cwd":"/home/serafin/work/apps4tests/ldap","name":"compose-down-clean"}
docker compose down && rm -rf data/ldap data/slapd.d data/lam
```

---

## Architecture

```ini
┌───────────────────────────────────────────────┐
│  Docker Compose                               │
│                                               │
│  ┌─────────────┐       ┌──────────────────┐  │
│  │  openldap   │◄──────│      lam         │  │
│  │  :389 :636  │       │  :8080 (HTTP)    │  │
│  │  (custom    │       │  (ghcr.io/lam)   │  │
│  │   Debian    │       └──────────────────┘  │
│  │   image)    │                              │
│  └──────┬──────┘                              │
│         │                                     │
└─────────┼───────────────────────────────────--┘
          │  bind-mounts
          ├── ./data/ldap      (LDAP database)
          ├── ./data/slapd.d   (slapd config)
          ├── ./certs          (TLS cert + key)
          └── ./data/lam       (LAM config)
```

The `openldap` container is built from the local `Dockerfile` (Debian 13 slim +
`slapd`). On first start the entrypoint initialises the database and config
from baked-in originals, then configures TLS if certificates are present and
starts `slapd`.
