#!/usr/bin/env bash

contexts=/vagrant/instance/kubernetes-hosts/*.json

for f in $contexts
do
    echo "Processing $f"
    config_hostname=$(basename $f .json)
    echo "$config_hostname"
    config_file=$(jq -r '.config' $f)
    docker_host=$(jq -r '.host' "/vagrant/instance/docker-hosts/${config_hostname}.json")
   
    docker context create "k8s-${config_hostname}" \
    --default-stack-orchestrator=kubernetes \
    --kubernetes config-file=$config_file \
    --docker host=$docker_host

    docker context use "k8s-${config_hostname}"
done
