#!/usr/bin/env bash

timeoutstartsec=${timeoutstartsec:="10sec"}

echo "TimeoutStartSec=$timeoutstartsec" | sudo tee -a /lib/systemd/system/networking.service
sudo systemctl daemon-reload
