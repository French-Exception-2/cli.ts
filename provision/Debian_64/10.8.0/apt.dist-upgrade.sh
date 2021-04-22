#!/usr/bin/env pwsh

sudo apt-get update
sudo DEBIAN_FRONTEND=noninteractive apt-get -fy \
    -o Dpkg::Options::=--force-confdef        \
    -o Dpkg::Options::=--force-confold        \
    dist-upgrade
