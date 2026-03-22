#!/usr/bin/env bash

### change me ###
CN=ldap.example.local
ALIASES=""
IP=127.0.0.1
#################

mkdir -p certs

FILE_NAME=certs/ldap

SANVAL="DNS:${CN},IP:${IP}"
for item in ${ALIASES}
do
  SANVAL="${SANVAL},DNS:${item}"
done

openssl req -new -x509 -days 3650 \
  -out "${FILE_NAME}.crt" \
  -newkey rsa:2048 -noenc -keyout "${FILE_NAME}.key" \
  -subj "/CN=${CN}" \
  -addext "subjectAltName=${SANVAL}"

openssl x509 -in "${FILE_NAME}.crt" -text
