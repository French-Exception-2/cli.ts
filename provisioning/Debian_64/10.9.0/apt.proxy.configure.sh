#!/usr/bin/env pwsh

APT_PORT=${APT_PORT:=3142}

if [[ $APT_IP_FILE ]]; then
    ip=$(cat $APT_IP_FILE)
else
    ip=$APT_IP
fi
 
content=$(cat <<EOF
Acquire::http::Proxy http://${ip}:${APT_PORT}/;
Acquire::https::Proxy none;
EOF
)

echo $content | sudo tee /etc/apt/apt.conf.d/proxy.conf
echo APT