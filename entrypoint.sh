#!/bin/sh
set -e -u

if [ -z "${PORT}" ]; then
  echo "Error: No PORT found" >&2
  exit 1
fi

echo "Writing config.yml"

# Fill in template and write it to config.yml
echo "
version: 0.1
log:
  fields:
    service: registry
storage:
  cache:
    blobdescriptor: inmemory
  swift:
    username: ${OS_USERNAME}
    password: ${OS_PASSWORD}
    authurl: ${OS_AUTH_URL}
    tenantid: ${OS_PROJECT_ID}
    domainid: ${OS_PROJECT_DOMAIN_ID}
    container: ${OS_SWIFT_CONTAINER}
  redirect:
    disable: true

http:
  addr: :${PORT}
  headers:
    X-Content-Type-Options: [nosniff]

health:
  storagedriver:
    enabled: true
    interval: 10s
    threshold: 3
" > /etc/docker/registry/config.yml

# Start the app
registry serve /etc/docker/registry/config.yml