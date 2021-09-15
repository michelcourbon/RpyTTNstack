#!/bin/sh

# Get local IPs for  config files
    TTS_DOMAIN=$(hostname  -I | cut -f1 -d' ')
# Check domain
if [ $TTS_DOMAIN == "" ]; then
    echo -e "\033[91mERROR: TTS_DOMAIN not defined.\033[0m"
    sleep infinity
    exit 1
fi

echo "------------------------------"
echo "TTS_DOMAIN: ${TTS_DOMAIN}"
echo "------------------------------"

# my personal configuration
TTS_ADMIN_EMAIL="mcour42iot@gmail.com"
TTS_SMTP_HOST="smtp@gmail.com"
MAIL_PROVIDER="smtp"

# Get configuration
TTS_SERVER_NAME=${TTS_SERVER_NAME:-TTS iutse}
TTS_ADMIN_EMAIL=${TTS_ADMIN_EMAIL:-admin@thethings.example.com}
TTS_NOREPLY_EMAIL=${TTS_NOREPLY_EMAIL:-noreply@thethings.example.com}
TTS_ADMIN_PASSWORD=${TTS_ADMIN_PASSWORD:-changeme}
TTS_CONSOLE_SECRET=${TTS_CONSOLE_SECRET:-console}
TTS_DEVICE_CLAIMING_SECRET=${TTS_DEVICE_CLAIMING_SECRET:-device_claiming}
TTS_METRICS_PASSWORD=${TTS_METRICS_PASSWORD:-metrics}
TTS_PPROF_PASSWORD=${TTS_PPROF_PASSWORD:-pprof}

BLOCK_KEY=$(openssl rand -hex 32)
HASH_KEY=$(openssl rand -hex 64)

# Build config file
CONFIG_FILE=ttn-lw-stack-docker.yml
cp ${CONFIG_FILE}.template ${CONFIG_FILE}
sed -i -e "s/{{server_name}}/${TTS_SERVER_NAME}/g" $CONFIG_FILE
sed -i -e "s/{{admin_email}}/${TTS_ADMIN_EMAIL}/g" $CONFIG_FILE
sed -i -e "s/{{noreply_email}}/${TTS_NOREPLY_EMAIL}/g" $CONFIG_FILE
sed -i -e "s/{{console_secret}}/${TTS_CONSOLE_SECRET}/g" $CONFIG_FILE
sed -i -e "s/{{domain}}/${TTS_DOMAIN}/g" $CONFIG_FILE
sed -i -e "s/{{mail_provider}}/${MAIL_PROVIDER}/g" $CONFIG_FILE
sed -i -e "s/{{sendgrid_key}}/${TTS_SENDGRID_KEY}/g" $CONFIG_FILE
sed -i -e "s/{{smtp_host}}/${TTS_SMTP_HOST}/g" $CONFIG_FILE
sed -i -e "s/{{smtp_user}}/${TTS_SMTP_USER}/g" $CONFIG_FILE
sed -i -e "s/{{smtp_pass}}/${TTS_SMTP_PASS}/g" $CONFIG_FILE
sed -i -e "s/{{block_key}}/${BLOCK_KEY}/g" $CONFIG_FILE
sed -i -e "s/{{hash_key}}/${HASH_KEY}/g" $CONFIG_FILE
sed -i -e "s/{{metrics_password}}/${TTS_METRICS_PASSWORD}/g" $CONFIG_FILE
sed -i -e "s/{{pprof_password}}/${TTS_PPROF_PASSWORD}/g" $CONFIG_FILE
sed -i -e "s/{{device_claiming_secret}}/${TTS_DEVICE_CLAIMING_SECRET}/g" $CONFIG_FILE
sed -i -e "s/{{data_folder}}/${DATA_FOLDER_ESC}/g" $CONFIG_FILE

mkdir -p config/stack
cp ${CONFIG_FILE} config/stack/${CONFIG_FILE}

# Build docker-compose
DOCKER_FILE=docker-compose.yml
cp ${DOCKER_FILE}.template ${DOCKER_FILE}
sed -i -e "s/{{domain}}/${TTS_DOMAIN}/g" $DOCKER_FILE

# Certificates are rebuild on subject change
sh credential.sh

# mkdir -p srv/data
# DATA_FOLDER=${PWD}/srv/data
# DATA_FOLDER_ESC=$(echo "${DATA_FOLDER}" | sed 's/\//\\\//g')

# cp ca.pem ${DATA_FOLDER}/ca.pem
# cp ca-key.pem ${DATA_FOLDER}/ca-key.pem
# cp cert.pem ${DATA_FOLDER}/cert.pem
# cp cert-key.pem ${DATA_FOLDER}/key.pem
# chmod 664 srv/data/*.pem

sh exec.sh
