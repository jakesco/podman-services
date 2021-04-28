#!/bin/sh

DB_DIR="$HOME/projects/podman-services/nextcloud/db"
DATA_DIR="$HOME/projects/podman-services/nextcloud/data"
HTML_DIR="$HOME/projects/podman-services/nextcloud/html"

BACKUP_LOCATION="$HOME/projects/podman-services/nextcloud"

BACKUP_DIR="nextcloud-backup-$(date +%Y%m%d)"

sudo rsync -a ${DB_DIR} ${DATA_DIR} ${HTML_DIR} ${BACKUP_LOCATION}/${BACKUP_DIR}
