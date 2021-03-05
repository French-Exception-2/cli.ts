#!/usr/bin/env bash

iso_path=${iso_path:=/root/VBoxGuestAdditions.iso}

(sudo mkdir /media/iso) || true
sudo mount VBoxGuestAdditions.iso /media/iso -o loop
sudo sh /media/iso/VBoxLinuxAdditions.run
sudo umount /media/iso
