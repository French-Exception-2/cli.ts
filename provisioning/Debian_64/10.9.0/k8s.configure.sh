#!/usr/bin/env pwsh

sudo swapoff -a

if [[ $MASTER == $(hostname) ]]; then
    echo Running