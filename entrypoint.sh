#!/bin/sh
set -e -u

if [ -z "${PORT}" ]; then
  echo "Error: No PORT found" >&2
  exit 1
fi

echo "Generating .htpasswd"
htpasswd -Bbn $BASIC_AUTH_USER $BASIC_AUTH_PASSWORD > /etc/docker/registry/htpasswd

echo "Writing config.yml"
echo "
version: 0.1
log:
  level: info
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
auth:
  htpasswd:
    realm: basic-realm
    path: /etc/docker/registry/htpasswd
health:
  storagedriver:
    enabled: false
" > /etc/docker/registry/config.yml

# Start the app
registry serve /etc/docker/registry/config.yml