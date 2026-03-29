# Copilot Instructions

## Repository Purpose

A collection of isolated test/lab deployments for evaluating and developing with various applications. Each top-level directory is an independent app environment.

## Architecture

Each app directory follows one of two patterns (do not list applications for the patterns, just the patterns themselves):

**Vagrant + Docker**:
- `Vagrantfile` — spins up a Debian 13 VM, forwards port 8080, provisions via `provision_script.sh`
- `provision_script.sh` — installs system packages and Docker inside the VM
- `testme.sh` — smoke test script for the environment

**Docker Compose only**:
- `compose.yaml` — defines the service stack, run directly on the host
- `ldap/` also uses a custom `Dockerfile` + `entrypoint.sh`; run `./gen-cert.sh` first, `./init-lam-config.sh` once before first start, then `./populate.sh` after startup


## Commands

**Vagrant environments:**
```bash
vagrant up          # create and provision VM
vagrant ssh         # SSH into VM
vagrant status      # check VM state
vagrant halt        # stop VM
vagrant destroy     # remove VM
./runme.sh          # shortcut: status + up + ssh
./testme.sh         # run smoke tests
```

**Docker Compose environments:**
```bash
docker compose up -d        # start services in background
docker compose down         # stop and remove containers
docker compose logs -f      # follow logs
```

## Conventions

- **Compose files** are named `compose.yaml` (not `docker-compose.yml`)
- **Vagrant base box**: `serafin-tech/debian13` for all VMs
- **Timezone**: `Europe/Warsaw` set in all environments (`TZ` env var in compose, `timedatectl` in VMs)
- **SSH key**: `/home/serafin/.ssh/id_ed25519` used as `config.ssh.private_key_path` in all Vagrantfiles
- **Docker install in VMs**: always via `curl -fsSL https://get.docker.com`
- **Apt installs**: use `apt-get install -yq` with `DEBIAN_FRONTEND=noninteractive`
- **App port**: 8080 is the standard guest/host forwarded port for web UIs
- **Volume naming**: descriptive suffixes, e.g. `cellsdir`, `mariadbdird`
- **Runbooks**: each app directory must have a `README.mdr` runme.dev runbook (not a plain `README.md`) with executable steps for setup, start, and verification. Code blocks must include `{"name":"<step>","cwd":"<abs-path>"}` annotations so every step is runnable directly from VSCode with the [Runme extension](https://marketplace.visualstudio.com/items?itemName=stateful.runme).

## Adding a New App Environment

Follow the existing pattern:
1. Create a directory: `<appname>/`
2. Add a `Vagrantfile` based on existing ones (box, memory, CPU, port forwarding, provision script)
3. Add `provision_script.sh` (copy from `bindplane/` or `pydio-cells/` as a base)
4. Add a `compose.yaml` inside the app directory if Docker services are needed
5. Add `testme.sh` for smoke tests
6. Add a `README.mdr` runme.dev runbook covering prerequisites, first-time setup, start, verification, and teardown steps
