#!/bin/sh

git clone https://github.com/doublespeakgames/adarkroom.git /tmp/adr

id=$(buildah from --pull nginx:latest)
buildah copy $id /tmp/adr /usr/share/nginx/html
buildah commit $id adarkroom
