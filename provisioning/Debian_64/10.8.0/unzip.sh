#!/usr/bin/env bash

content=$(cat <<EOF
#!/bin/sh
/usr/bin/unzip "\$@"
sleep 1
EOF
)
(sudo mkdir -p /usr/local/bin) || true
echo "$content" | sudo tee /usr/local/bin/unzip

sudo chmod 755 /usr/local/bin/unzip
