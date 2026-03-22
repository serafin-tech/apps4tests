#!/bin/bash
set -e

# Initialize data directories on first run (when bind-mounted dirs are empty)
if [ -z "$(ls -A /var/lib/ldap 2>/dev/null)" ]; then
    echo "Initializing LDAP database..."
    cp -a /var/lib/ldap.orig/. /var/lib/ldap/
    chown -R openldap:openldap /var/lib/ldap
fi

if [ -z "$(ls -A /etc/ldap/slapd.d 2>/dev/null)" ]; then
    echo "Initializing LDAP configuration..."
    cp -a /etc/ldap/slapd.d.orig/. /etc/ldap/slapd.d/
    chown -R openldap:openldap /etc/ldap/slapd.d
fi

LDAP_URLS="ldap:/// ldapi:///"

# Ensure runtime directory exists (lost on tmpfs at container start)
mkdir -p /var/run/slapd
chown openldap:openldap /var/run/slapd

# Configure TLS if certificates are present
if [ -f /certs/ldap.crt ] && [ -f /certs/ldap.key ]; then
    echo "Configuring TLS..."

    cp /certs/ldap.crt /tmp/ldap.crt
    cp /certs/ldap.key /tmp/ldap.key
    chown openldap:openldap /tmp/ldap.crt /tmp/ldap.key
    chmod 640 /tmp/ldap.crt /tmp/ldap.key

    # Start slapd temporarily on ldapi:// only for configuration
    /usr/sbin/slapd -h "ldapi:///" -u openldap -g openldap

    # Wait for slapd to be ready
    for i in $(seq 1 10); do
        ldapwhoami -Y EXTERNAL -H ldapi:/// -Q 2>/dev/null && break
        sleep 1
    done

    ldapmodify -Y EXTERNAL -H ldapi:/// <<EOF
dn: cn=config
changetype: modify
replace: olcTLSCACertificateFile
olcTLSCACertificateFile: /tmp/ldap.crt
-
replace: olcTLSCertificateFile
olcTLSCertificateFile: /tmp/ldap.crt
-
replace: olcTLSCertificateKeyFile
olcTLSCertificateKeyFile: /tmp/ldap.key
EOF

    # Stop temporary slapd
    kill "$(cat /var/run/slapd/slapd.pid 2>/dev/null)" 2>/dev/null || pkill slapd 2>/dev/null || true
    sleep 1

    LDAP_URLS="ldap:/// ldaps:/// ldapi:///"
    echo "TLS configured."
fi

echo "Starting slapd..."
exec /usr/sbin/slapd -d 0 -h "${LDAP_URLS}" -u openldap -g openldap
