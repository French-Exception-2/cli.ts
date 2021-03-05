#!/usr/bin/bash

sudo apt-get install -y curl gdebi-core

vagrant_cache_dir=${vagrant_cache_dir:="/vagrant/.vagrant-cache"}
(mkdir -p $vagrant_cache_dir) || true

docker_compose_version=${docker_compose_version:="1.28.2"}

if [[ ! -e $vagrant_cache_dir/docker-compose_${docker_compose_version} ]]; then
  sudo curl -L "https://github.com/docker/compose/releases/download/${docker_compose_version}/docker-compose-$(uname -s)-$(uname -m)" -o $vagrant_cache_dir/docker-compose_${docker_compose_version}
fi

if [[ ! -e $vagrant_cache_dir/docker-compose_compl_${docker_compose_version} ]]; then
  sudo curl -L "https://raw.githubusercontent.com/docker/compose/${docker_compose_version}/contrib/completion/bash/docker-compose" -o $vagrant_cache_dir/docker-compose_compl_${docker_compose_version}
fi

sudo cp $vagrant_cache_dir/docker-compose_${docker_compose_version} /usr/bin/docker-compose
sudo chmod +x /usr/bin/docker-compose