#!/bin/sh

podman build -t git .

podman container stop git && podman container rm git

podman run \
    --detach \
    --publish 9022:22 \
    --volume /mnt/pool/git/:/home/git/repos/ \
    --restart unless-stopped \
    --name git git:latest
