#!/usr/bin/env bash

sudo DEBIAN_FRONTEND=noninteractive apt-get -fy -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" install debconf-utils 
sudo debconf-set-selections <<< "mysql-server mysql-server/root_password password root"
sudo debconf-set-selections <<< "mysql-server mysql-server/root_password_again password root"
sudo DEBIAN_FRONTEND=noninteractive apt-get -fy -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" install default-mysql-server

sudo mysql -uroot -proot -e "SET PASSWORD FOR 'root'@'localhost' = PASSWORD('root');"

sudo mysql -uroot -proot -e "FLUSH PRIVILEGES;"
