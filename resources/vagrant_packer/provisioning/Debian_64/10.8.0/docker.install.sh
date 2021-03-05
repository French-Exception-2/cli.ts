#!/usr/bin/bash

sudo apt-get install -y curl gdebi-core

debian_id=${debian_id:=$(lsb_release -is | tr '[:upper:]' '[:lower:]')}
debian_realcodename="${debian_code_name:=$(lsb_release -cs | tr '[:upper:]' '[:lower:]')}"
#debian_codename="${debian_realcodename}"
realarch=$(dpkg --print-architecture)
docker_ce_cli_version=${docker_ce_cli_version:="19.03.9~3-0"}
docker_ce_cli_deb="docker-ce-cli_${docker_ce_cli_version}~${debian_id}-${debian_realcodename}_${realarch}.deb"
docker_ce_cli_deb_download_url="https://download.docker.com/linux/${debian_id}/dists/${debian_realcodename}/pool/stable/${realarch}/${docker_ce_cli_deb}"
containerd_version=${containerd_version:="1.4.3-1"}
containerd_deb="containerd.io_${containerd_version}_amd64.deb"
containerd_deb_download_url="https://download.docker.com/linux/${debian_id}/dists/${debian_realcodename}/pool/stable/${realarch}/${containerd_deb}"
docker_ce_version=${docker_ce_version:="19.03.9~3-0"}
docker_ce_deb="docker-ce_${docker_ce_version}~${debian_id}-${debian_realcodename}_${realarch}.deb"
docker_ce_deb_download_url="https://download.docker.com/linux/${debian_id}/dists/${debian_realcodename}/pool/stable/${realarch}/${docker_ce_deb}"

vagrant_cache_dir=${vagrant_cache_dir:="/vagrant/.vagrant-cache"}

(mkdir -p $vagrant_cache_dir) || true

# Download Debs if necessary
if [[ ! -e $vagrant_cache_dir/${docker_ce_cli_deb} ]]; then
  curl -sSL ${docker_ce_cli_deb_download_url} > $vagrant_cache_dir/${docker_ce_cli_deb}
fi

if [[ ! -e $vagrant_cache_dir/${containerd_deb} ]]; then
  curl -sSL ${containerd_deb_download_url} > $vagrant_cache_dir/${containerd_deb}
fi 

if [[ ! -e $vagrant_cache_dir/${docker_ce_deb} ]]; then
  curl -sSL ${docker_ce_deb_download_url} > $vagrant_cache_dir/${docker_ce_deb}
fi

sudo gdebi -n $vagrant_cache_dir/${docker_ce_cli_deb}
sudo gdebi -n $vagrant_cache_dir/${containerd_deb}
sudo gdebi -n $vagrant_cache_dir/${docker_ce_deb}

sudo usermod -aG docker vagrant
sudo mkdir -p /etc/bash_completion.d/

content=$(cat <<EOF
{
  "exec-opts": ["native.cgroupdriver=systemd"],
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "100m"
  },
  "storage-driver": "overlay2"
}
EOF
)

echo "$content" | sudo tee /etc/docker/daemon.json

sudo systemctl restart docker
