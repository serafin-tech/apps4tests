# apps4tests

Applications for various testing / POCs, run under Docker Compose or within a VirtualBox VM managed by Vagrant.

## Applications

| Directory                                     | Description                                    | Runtime          | Runbook                             |
|-----------------------------------------------|------------------------------------------------|------------------|-------------------------------------|
| [bindplane](./bindplane/)                     | ObserviQ OpenTelemetry Collector agent         | Vagrant          |                                     |
| [keycloak](./keycloak/)                       | Keycloak identity and access management        | Docker Compose   | [README.mdr](./keycloak/README.mdr) |
| [ldap](./ldap/)                               | OpenLDAP for `example.local` with TLS          | Docker Compose   | [README.mdr](./ldap/README.mdr)     |
| [nginx-proxy-manager](./nginx-proxy-manager/) | Reverse proxy with web UI and Let's Encrypt    | Docker Compose   |                                     |
| [pydio-cells](./pydio-cells/)                 | File sharing platform with MariaDB and Mailhog | Vagrant + Docker |                                     |

## Runbooks

App-specific instructions are provided as [runme.dev](https://runme.dev) runbooks (`.mdr` files), executable step-by-step from VSCode with the [Runme extension](https://marketplace.visualstudio.com/items?itemName=stateful.runme).
