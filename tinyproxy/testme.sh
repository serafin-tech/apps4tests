#!/bin/bash

set -e

PROXY="http://localhost:8888"

echo "==> Testing tinyproxy at ${PROXY}"

HTTP_CODE=$(curl -x "${PROXY}" -o /dev/null -sw '%{http_code}' --max-time 10 http://example.com)

if [ "${HTTP_CODE}" -ge 200 ] && [ "${HTTP_CODE}" -lt 600 ]; then
  echo "PASS: tinyproxy responded with HTTP ${HTTP_CODE}"
else
  echo "FAIL: unexpected response code '${HTTP_CODE}'"
  exit 1
fi
