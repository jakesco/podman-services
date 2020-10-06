#!/bin/sh

podman run \
    --rm \
    --name a-dark-room \
    --publish 80:80 \
    --detach \
    adarkroom
