#!/bin/sh

echo "----- database initialization ----"
docker-compose pull
docker-compose run --rm stack is-db init
export COMPOSE_HTTP_TIMEOUT=140

echo "----- creat admin user ----"
sleep 2
TTS_ADMIN_EMAIL="mcour42iot@gmail.com"
docker-compose run --rm stack is-db create-admin-user \
  --id admin \
  --email ${TTS_ADMIN_EMAIL}

echo "----- create oauth client  used by cli ----"
sleep 3
docker-compose run --rm stack is-db create-oauth-client \
  --id cli \
  --name "Command Line Interface" \
  --owner admin \
  --no-secret \
  --redirect-uri "local-callback" \
  --redirect-uri "code"

echo "------ create oauth client used by console ----"
sleep 3
CONSOLE_SECRET="console"
IP_DOMAIN=$(hostname  -I | cut -f1 -d' ' )
SERVER_ADDRESS="${IP_DOMAIN}"
docker-compose run --rm stack is-db create-oauth-client \
  --id console \
  --name "Console" \
  --owner admin \
  --secret "${CONSOLE_SECRET}" \
  --redirect-uri "${SERVER_ADDRESS}/console/oauth/callback" \
  --redirect-uri "/console/oauth/callback" \
  --logout-redirect-uri "${SERVER_ADDRESS}/console" \
  --logout-redirect-uri "/console"
