#!/bin/sh

PODNAME="nextcloud"
PORT=9000

DB_MOUNT=
HTML_MOUNT=
DATA_MOUNT=

SERVER_IP=
SERVER_DOMAIN=

MYSQL_ROOT_PASSWORD=
MYSQL_PASSWORD=

REDIS_PASSWORD=

NEXTCLOUD_ADMIN_NAME=
NEXTCLOUD_ADMIN_PASS=

# Create Pod
podman pod create --hostname ${PODNAME} --name ${PODNAME} -p ${PORT}:80

# MariaDB
podman run \
    --detach \
    --restart=always \
    --pod=${PODNAME} \
    --env MYSQL_ROOT_PASSWORD=${MYSQL_ROOT_PASSWORD} \
    --env MYSQL_DATABASE="nextcloud" \
    --env MYSQL_USER="nextcloud" \
    --env MYSQL_PASSWORD=${MYSQL_PASSWORD} \
    --volume ${DB_MOUNT}:/var/lib/mysql:Z \
    --name=${PODNAME}-db docker.io/library/mariadb:10.5 \
    --transaction-isolation=READ-COMMITTED --binlog-format=ROW

# Redis
podman run \
    --detach \
    --restart=always \
    --pod=${PODNAME} \
    --name=${PODNAME}-redis docker.io/library/redis:6.2-alpine \
    redis-server --requirepass ${REDIS_PASSWORD}

# Nextcloud
podman run \
    --detach \
    --restart=always \
    --pod=${PODNAME} \
    --env MYSQL_HOST="127.0.0.1" \
    --env MYSQL_USER="nextcloud" \
    --env MYSQL_PASSWORD=${MYSQL_PASSWORD} \
    --env MYSQL_DATABASE="nextcloud" \
    --env REDIS_HOST="127.0.0.1" \
    --env REDIS_HOST_PASSWORD=${REDIS_PASSWORD} \
    --env NEXTCLOUD_ADMIN_USER=${NEXTCLOUD_ADMIN_NAME} \
    --env NEXTCLOUD_ADMON_PASSWORD=${NEXTCLOUD_ADMIN_PASS} \
    --env NEXTCLOUD_TRUSTED_DOMAINS="${SERVER_IP} ${SERVER_DOMAIN}" \
    --env OVERWRITEHOST="${SERVER_DOMAIN}:${PORT}" \
    --env OVERWRITEPROTOCOL="http" \
    --volume ${HTML_MOUNT}:/var/www/html:z \
    --volume ${DATA_MOUNT}:/var/www/html/data:z \
    --name=${PODNAME}-app docker.io/library/nextcloud:21-apache

