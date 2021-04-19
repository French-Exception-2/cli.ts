#!/usr/bin/env pwsh

version=${version:=1.6}

sudo wget https://github.com/stedolan/jq/releases/download/jq-${version}/jq-linux64 -o /usr/bin/jq
sudo chmod +x /usr/bin/jq