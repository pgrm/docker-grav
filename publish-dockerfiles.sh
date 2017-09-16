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

    cd $name
    docker build -t pgrm/grav:$name .
    docker push pgrm/grav:$name
done < template/versions.txt
