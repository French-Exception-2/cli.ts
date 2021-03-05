#!/usr/bin/env bash

device=${device:="eth0"}

ip=$(ip addr show $device | grep "inet\b" | awk '{print $2}' | cut -d/ -f1)

(mkdir -p /vagrant/instance/IPv4/) || true

echo "$ip" | tee /vagrant/instance/IPv4/$(hostname)