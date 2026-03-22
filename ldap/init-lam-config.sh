#!/usr/bin/env bash
# Seeds ./data/lam with the default LAM config files from the image.
# Must be run once before the first `docker compose up` (or after `rm -rf data/lam`).
set -e

IMAGE="ghcr.io/ldapaccountmanager/lam:stable"
TARGET="$(cd "$(dirname "$0")" && pwd)/data/lam"

mkdir -p "${TARGET}"

echo "Seeding LAM config from ${IMAGE}..."
CONT=$(docker create "${IMAGE}")
docker cp "${CONT}:/var/lib/ldap-account-manager/config/." "${TARGET}/"
docker rm "${CONT}" > /dev/null
sudo chown -R 33:33 "${TARGET}"
echo "Done. Config seeded to ${TARGET}"
