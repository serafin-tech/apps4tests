FROM debian:13-slim

RUN echo "slapd slapd/no_configuration boolean false" | debconf-set-selections && \
    echo "slapd slapd/domain string example.local" | debconf-set-selections && \
    echo "slapd shared/organization string example.local" | debconf-set-selections && \
    echo "slapd slapd/password1 password password" | debconf-set-selections && \
    echo "slapd slapd/password2 password password" | debconf-set-selections && \
    echo "slapd slapd/backend string MDB" | debconf-set-selections && \
    echo "slapd slapd/purge_database boolean false" | debconf-set-selections && \
    echo "slapd slapd/move_old_database boolean true" | debconf-set-selections && \
    echo "slapd slapd/allow_ldap_v2 boolean false" | debconf-set-selections && \
    apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -yq slapd ldap-utils && \
    apt-get clean && rm -rf /var/lib/apt/lists/* && \
    cp -a /var/lib/ldap /var/lib/ldap.orig && \
    cp -a /etc/ldap/slapd.d /etc/ldap/slapd.d.orig

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 389 636

ENTRYPOINT ["/entrypoint.sh"]
