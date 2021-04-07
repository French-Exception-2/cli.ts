#!/usr/bin/env bash

sudo=${sudo:=sudo}
apt_get=${apt_get:="apt-get"}
apt_cacher_ng_deb_name=${apt_cacher_ng_deb_name:="apt-cacher-ng"}
DEBIAN_FRONTEND=noninteractive $sudo -E $apt_get install -y ${apt_cacher_ng_deb_name}
echo "BindAddress: 0.0.0.0" | sudo tee -a /etc/apt-cacher-ng/acng.conf
# give tim to apt cacher ng to load up
sleep 5
sync
sudo systemctl daemon-reload
sudo systemctl restart apt-cacher-ng
