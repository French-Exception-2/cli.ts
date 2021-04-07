#!/usr/bin/env bash

# phpbrew needs a valid php install > 7.1
php_ver_full=${php_ver_full:="7.3.25"}

sudo apt-get update

sudo apt-get install -y \
      procps \
      unzip \
      curl \
      libicu-dev \
      zlib1g-dev \
      libxml2 \
      libxml2-dev \
      libreadline-dev \
      libzip-dev \
      libfreetype6-dev \
      libjpeg62-turbo-dev \
      libpng-dev \
      libonig-dev

curl -sS -L -O https://github.com/phpbrew/phpbrew/releases/latest/download/phpbrew.phar
chmod +x phpbrew.phar

# Move the file to some directory within your $PATH
sudo mv phpbrew.phar /usr/local/bin/

mkdir /home/vagrant/.phpbrew/
touch /home/vagrant/.phpbrew/bashrc
echo "source /home/vagrant/.phpbrew/bashrc" | tee -a /home/vagrant/.bash_profile

source /home/vagrant/.phpbrew/bashrc

# rocknroll
phpbrew.phar init

source /home/vagrant/.phpbrew/bashrc

phpbrew.phar install -j $(nproc) $php_ver_full +default +mysql +intl +gd
phpbrew.phar switch "php-$php_ver_full"
phpbrew.phar ext install xdebug
phpbrew.phar ext install apcu
phpbrew.phar ext install gd
phpbrew.phar ext install opcache

php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
php composer-setup.php
sudo chmod +x composer.phar 
sudo mv composer.phar /usr/local/bin/
php -r "unlink('composer-setup.php');"

composer.phar global require hirak/prestissimo

echo "fs.inotify.max_user_watches=524288" | sudo tee -a /etc/sysctl.conf
sudo sysctl -p

content=$(cat <<EOF
zend_extension=xdebug.so
xdebug.discover_client_host=true
xdebug.mode=develop
xdebug.start_with_request=yes
EOF
)

echo "$content" | tee /home/vagrant/.phpbrew/php/php-${php_ver_full}/var/db/xdebug.ini
