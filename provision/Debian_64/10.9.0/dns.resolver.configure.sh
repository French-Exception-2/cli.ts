#!/usr/bin/env pwsh

echo "nameserver ${nameserver}" | sudo tee /etc/resolv.conf
