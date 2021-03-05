#!/usr/bin/env bash

VERSION=${VERSION:="v4.5.1"}

sudo wget https://github.com/mikefarah/yq/releases/download/${VERSION}/yq_linux_amd64 -O /usr/bin/yq
sudo chmod +x /usr/bin/yq