#!/usr/bin/env bash

apt_conf=$(cat <<EOF
APT::Get::Install-Recommends "false";
APT::Get::Install-Suggests "false";
EOF
)

echo "$apt_conf" | sudo tee /etc/apt/apt.conf.d/00no_recommends_no_suggest
