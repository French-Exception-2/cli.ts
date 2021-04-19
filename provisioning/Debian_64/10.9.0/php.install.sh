#!/usr/bin/env pwsh

# phpbrew needs a valid php install > 7.1
PHP_VERSION=${PHP_VERSION:=7.4}

sudo apt-get update

sudo apt -y install lsb-release apt-transport-https ca-certificates unzip
sudo wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg
echo deb