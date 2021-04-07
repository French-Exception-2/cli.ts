#!/usr/bin/env bash

content=$(cat <<EOF
zend_extension=xdebug.so
xdebug.discover_client_host=true
xdebug.mode=develop
xdebug.start_with_request=true
EOF
)

echo "$content" | tee /home/vagrant/.phpbrew/php/php-7.4.13/var/db/xdebug.ini