#!/usr/bin/env pwsh

# phpbrew needs a valid php install > 7.1
php_ver_full=${php_ver_full:=7.3.25}

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
echo source