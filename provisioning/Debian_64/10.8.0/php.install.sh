#!/usr/bin/env bash

# phpbrew needs a valid php install > 7.1
PHP_VERSION=${PHP_VERSION:="7.4"}

sudo apt-get update

sudo apt -y install lsb-release apt-transport-https ca-certificates unzip
sudo wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg
echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" | sudo tee /etc/apt/sources.list.d/php.list
sudo apt update

sudo apt -y install php${PHP_VERSION} php${PHP_VERSION}-gd php${PHP_VERSION}-mysql php${PHP_VERSION}-xdebug php${PHP_VERSION}-dom php${PHP_VERSION}-mbstring php${PHP_VERSION}-zip

content_xdebugv3=$(cat <<EOF
zend_extension=xdebug.so
xdebug.discover_client_host=true
xdebug.mode=debug
xdebug.start_with_request=yes
EOF
)

echo "$content_xdebugv3" | sudo tee /etc/php/$PHP_VERSION/cli/conf.d/20-xdebug.ini 
(sudo systemctl stop apache2 && sudo a2dissite 000-default && sudo systemctl disable apache2) || true
