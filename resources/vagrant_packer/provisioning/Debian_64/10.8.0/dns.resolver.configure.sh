#!/usr/bin/env bash

echo "nameserver ${nameserver}" | sudo tee /etc/resolv.conf