#!/bin/sh

build_php_image() {
    if ! [ -x "$(command -v buildah)" ] ; then
        echo "buildah not found; can build images"
        exit 1
    fi

    echo -e "Building Apache PHP image"
    id=$(buildah from --pull php:7.4.10-apache-buster)
    buildah run $id docker-php-ext-install pdo pdo_mysql
    buildah commit $id cphp-apache
}

build_mysql_image() {
    if ! [ -x "$(command -v buildah)" ] ; then
        echo "buildah not found; can build images"
        exit 1
    fi

    mkdir mysqldb 2>/dev/null

    echo -e "\nBuilding MySQL image"
    id=$(buildah from --pull mysql:8)
    buildah commit $id cphp-mysql
}

create_pod() {
    podman run \
        --detach \
        --pod new:cphp-lamp \
        --publish 127.0.0.1:8080:80 \
        --name php-dev \
        --security-opt label=disable \
        --volume ./src:/var/www/html \
        cphp-apache

    podman run \
        --detach \
        --pod cphp-lamp \
        --name mysql-dev \
        --env MYSQL_ROOT_PASSWORD=dev \
        --security-opt label=disable \
        --volume ./mysqldb:/var/lib/mysql \
        cphp-mysql
}

if ! podman images | grep cphp-apache >/dev/null 2>&1; then
    build_php_image
fi

if ! podman images | grep cphp-mysql >/dev/null 2>&1; then
    build_mysql_image
fi

if ! podman pod exists cphp-lamp; then
    create_pod
fi

echo "Pod 'cphp-lamp' created..."
