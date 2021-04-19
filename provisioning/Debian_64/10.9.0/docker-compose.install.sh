#!/usr/bin/env pwsh

sudo apt-get install -y curl gdebi-core

vagrant_cache_dir=${vagrant_cache_dir:=/vagrant/.vagrant/cache}
(mkdir -p $vagrant_cache_dir) || true

docker_compose_version=${docker_compose_version:=1.28.6}

if [[ ! -e $vagrant_cache_dir/docker-compose_${docker_compose_version} ]]; then
  sudo curl -L https://github.com/docker/compose/releases/download/${docker_compose_version}/docker-compose-$(uname