#!/bin/bash

set -o xtrace
set -e
cd "$(dirname "$0")"

IFS='|'
while read -r name url
do
    if [ -z "$name" ] # $name is empty
    then
        continue
    fi

    mkdir -p $name
    cat template/Dockerfile | sed "s|%GRAV_URL%|$url|g" > $name/Dockerfile
    cp -f template/docker-entrypoint.sh $name
done < template/versions.txt
