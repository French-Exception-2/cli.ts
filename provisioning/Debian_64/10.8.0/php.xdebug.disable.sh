#!/usr/bin/env bash
source /home/vagrant/.phpbrew/bashrc

php_ver_full=${php_ver_full:="7.3.25"}

content=$(cat <<EOF
zend_extension=xdebug.so
xdebug.discover_client_host=false
xdebug.mode=develop
xdebug.start_with_request=false
EOF
)

echo "$content" | tee /home/vagrant/.phpbrew/php/php-${php_ver_full}/var/db/xdebug.ini