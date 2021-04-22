#!/usr/bin/env bash

contexts=$(docker context list -q)

for context in $contexts
do
    docker context rm $context -f
done
