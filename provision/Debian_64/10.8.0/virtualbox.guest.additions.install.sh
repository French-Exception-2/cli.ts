#!/usr/bin/env pwsh

iso_path=${iso_path:=VBoxGuestAdditions.iso}

(sudo mkdir /media/iso) || true
sudo mount $iso_path /media/iso -o loop
sudo sh /media/iso/VBoxLinuxAdditions.run
sudo umount /media/iso
