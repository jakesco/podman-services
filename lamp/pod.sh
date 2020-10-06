#!/bin/sh

if ! [ "$1" = "up" ] && ! [ "$1" = "down" ]; then
    echo "usage: ./pod.sh up|down"
fi

if ! podman pod exists cphp-lamp; then
    echo "cphp-lamp pod does not exists"
    echo "run mklamp.sh"
fi

up () {
    if ! podman pod ps | grep -e "cphp-lamp.*Running" >/dev/null 2>&1; then
        podman pod start cphp-lamp
    fi
}

down () {
    if podman pod ps | grep -e "cphp-lamp.*Running" >/dev/null 2>&1; then
        podman pod stop cphp-lamp
    fi
}

case $1 in
    up) up
        ;;
    down) down
        ;;
esac