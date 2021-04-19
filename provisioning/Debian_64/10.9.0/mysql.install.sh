#!/usr/bin/env pwsh

sudo DEBIAN_FRONTEND=noninteractive apt-get -fy -o Dpkg::Options::=--force-confdef -o Dpkg::Options::=--force-confold install debconf-utils 
sudo debconf-set-selections <<< mysql-server