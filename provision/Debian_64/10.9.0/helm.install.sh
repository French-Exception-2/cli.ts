#!/usr/bin/env bash

version=${version:=3.5.3}
url=${url:=https://get.helm.sh/helm-v${version}-linux-amd64.tar.gz}

sudo curl -L $url -o $vagrant_cache_dir/helm.$version.tar.gz

tar -zxvf helm.$version.tar.gz 
mv linux-adm64/helm /usr/local/bin/helm
chmod +x /usr/local/bin/helm
