#!/usr/bin/env bash
set -e

ADMIN_PASS="${ADMIN_PASS:-password}"
ADMIN_DN="cn=admin,dc=example,dc=local"
CONTAINER="${CONTAINER:-openldap}"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

run_ldapadd() {
    docker compose exec -T "${CONTAINER}" ldapadd \
        -H "ldapi:///" \
        -D "${ADMIN_DN}" \
        -w "${ADMIN_PASS}"
}

echo "Adding structure (OUs and proxy user)..."
run_ldapadd < "${SCRIPT_DIR}/ldif/01-structure.ldif"

echo "Adding sample entries (users and groups)..."
run_ldapadd < "${SCRIPT_DIR}/ldif/02-sample.ldif"

echo "Done."
