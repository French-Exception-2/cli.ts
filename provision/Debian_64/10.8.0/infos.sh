#!/usr/bin/env bash

info_dir=${info_dir:=/vagrant/instance/IPv4/}
device=${device:=eth1}
ip=$(ip addr show $device | grep inet\b | awk '{print $2}' | cut -d/ -f1)
(mkdir -p $info_dir) || true
echo $ip | tee /vagrant/instance/IPv4/$(hostname)
