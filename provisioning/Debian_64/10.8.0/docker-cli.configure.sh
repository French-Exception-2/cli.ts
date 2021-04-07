#!/usr/bin/env bash

contexts=/vagrant/instance/docker-hosts/*.json

for f in $contexts
do
    echo "Processing $f"
    config_hostname=$(basename $f .json)
    echo "$config_hostname"
    host=$(jq -r '.host' $f)
    echo "$host"

    docker context create "docker-$config_hostname" \
        --docker host=$host
done
