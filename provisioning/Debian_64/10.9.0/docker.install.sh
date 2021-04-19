#!/usr/bin/env pwsh

sudo apt-get install -y curl gdebi-core

debian_id=${debian_id:=$(lsb_release -is | tr '[:upper:]' '[:lower:]')}
debian_realcodename=${debian_code_name:=$(lsb_release