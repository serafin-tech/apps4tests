# apps4tests

Applications for various testing / POCs, run under Docker Compose or within a VirtualBox VM managed by Vagrant.

## Applications

| Directory                                     | Description                                    | Runtime          |
|-----------------------------------------------|------------------------------------------------|------------------|
| [bindplane](./bindplane/)                     | ObserviQ OpenTelemetry Collector agent         | Vagrant          |
| [ldap](./ldap/)                               | OpenLDAP for `example.local` with TLS          | Docker Compose   |
| [nginx-proxy-manager](./nginx-proxy-manager/) | Reverse proxy with web UI and Let's Encrypt    | Docker Compose   |
| [pydio-cells](./pydio-cells/)                 | File sharing platform with MariaDB and Mailhog | Vagrant + Docker |
