#!/usr/bin/env bash

contexts=/vagrant/instance/kubernetes-hosts/*.json

for f in $contexts
do
    echo Processing
