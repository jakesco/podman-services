#!/bin/sh

PODNAME="nextcloud"

DB_MOUNT="$HOME/projects/podman-services/nextcloud/db"
HTML_MOUNT="$HOME/projects/podman-services/nextcloud/html"
DATA_MOUNT="$HOME/projects/podman-services/nextcloud/data"

MYSQL_DB_NAME="nextcloud"
MYSQL_ROOT_PASSWORD="myrootpass"
MYSQL_PASSWORD="mynextcloudpass"

SERVER_IP="127.0.0.1"
SERVER_DOMAIN="nextcloud.example.com"

REDIS_PASSWORD="redispassword"

NEXTCLOUD_ADMIN="admin"
NEXTCLOUD_PASSWORD="password"

# Create Pod
podman pod create --hostname ${PODNAME} --name ${PODNAME} -p 127.0.0.1:9000:80

# MariaDB
podman run \
    --detach \
    --restart=always \
    --pod=${PODNAME} \
    --env MYSQL_ROOT_PASSWORD=${MYSQL_ROOT_PASSWORD} \
    --env MYSQL_DATABASE=${MYSQL_DB_NAME} \
    --env MYSQL_USER=${MYSQL_DB_NAME} \
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
    --env MYSQL_USER=${MYSQL_DB_NAME} \
    --env MYSQL_PASSWORD=${MYSQL_PASSWORD} \
    --env MYSQL_DATABASE=${MYSQL_DB_NAME} \
    --env REDIS_HOST="127.0.0.1" \
    --env REDIS_HOST_PASSWORD=${REDIS_PASSWORD} \
    --env NEXTCLOUD_ADMIN_USER=${NEXTCLOUD_ADMIN} \
    --env NEXTCLOUD_ADMON_PASSWORD=${NEXTCLOUD_PASSWORD} \
    --env NEXTCLOUD_TRUSTED_DOMAINS="${SERVER_IP} ${SERVER_DOMAIN}" \
    --volume ${HTML_MOUNT}:/var/www/html:z \
    --volume ${DATA_MOUNT}:/var/www/html/data:z \
    --name=${PODNAME}-app docker.io/library/nextcloud:21-apache

