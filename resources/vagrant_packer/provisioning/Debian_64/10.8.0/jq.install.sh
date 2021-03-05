#!/usr/bin/env bash

VERSION=${VERSION:="1.6"}

sudo wget https://github.com/stedolan/jq/releases/download/jq-${VERSION}/jq-linux64 -o /usr/bin/jq
sudo chmod +x /usr/bin/jq
