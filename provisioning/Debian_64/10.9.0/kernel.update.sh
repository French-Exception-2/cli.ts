#!/usr/bin/env bash

kernel_version=${kernel_version:=5.9.0-0.bpo.5}

echo "deb http://deb.debian.org/debian buster-backports main contrib non-free" | sudo tee /etc/apt/sources.list.d/buster-backport.list

sudo apt-get update

sudo apt-get install -y linux-image-${kernel_version}-amd64 linux-headers-${kernel_version}-amd64
sudo apt install -y byobu

sudo purge-old-kernels --keep 1