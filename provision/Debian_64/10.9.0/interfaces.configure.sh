#!/usr/bin/env bash

echo TimeoutStartSec=5 | sudo tee -a /etc/systemd/system/network-online.target.wants/networking.service 
