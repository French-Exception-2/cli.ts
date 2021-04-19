#!/usr/bin/env pwsh

contexts=/vagrant/instance/docker-hosts/*.json

for f in $contexts
do
    echo Processing