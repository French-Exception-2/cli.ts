#!/usr/bin/env pwsh

contexts=/vagrant/instance/kubernetes-hosts/*.json

for f in $contexts
do
    echo Processing