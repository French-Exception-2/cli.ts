param(
    [string] $Path
)

import-module "$PSScriptRoot/../posh_modules/Utils.psm1" -Force

if ([string]::IsNullOrEmpty($Path)) {
    $path = get-location
}

frenchex2 vagrant:init --instance "$Instance" --group "$group"

$json = get-content "$PSScriptRoot/../init.json" -raw -Encoding ascii | convertfrom-json

$machinesTypes = $json.vagrant.'machines-types'.psobject.Properties

foreach($machineType in $machinesTypes) {
    
        frenchex2 vagrant:machine-type:add               `
        --name $machineType.Name                    `
        --vcpus $machineType.Value.Vcpus                 `
        --cpucap $machineType.Value.cpucap               `
        --os-type $machineType.Value.'os-type'          `
        --os-version $machineType.Value.'os-version'        `
        --ram-mb $machineType.Value.'ram-mb'           `
        --vram-mb $machineType.Value.'vram-mb'          `
        --no-3d                                          `
        --no-gui                                         `
        --provider $machineType.Value.provider       `
        --enabled                                        `
        --box $machineType.Value.box
}

foreach($provisioner in $json.vagrant.provisioners) {
    $osName = $provisioner."os-name"
    $osVersion = $provisioner."os-version"

    $provisioners = get-childitem -path "./provisioning/${osName}/${osVersion}" -file

    foreach($file in $provisioners){
        write-host $file
    }
}

# $files = get-childitem -Path $json.vagrant.provisioners -Recurse -File

# foreach ($file in $files) {

#     $filepath = Split-Path -path $file -parent

#     $parent = split-path -Path $filepath -parent

#     write-host $parent
# }

# APT-CACHERNG
ExecuteWithCode @'
sudo=${sudo:=sudo}
apt_get=${apt_get:="apt-get"}
apt_cacher_ng_deb_name=${apt_cacher_ng_deb_name:="apt-cacher-ng"}
DEBIAN_FRONTEND=noninteractive $sudo -E $apt_get install -y ${apt_cacher_ng_deb_name}
echo \"BindAddress: 0.0.0.0\" | sudo tee -a /etc/apt-cacher-ng/acng.conf
# give tim to apt cacher ng to load up
sleep 5
sync
sudo systemctl daemon-reload
sudo systemctl restart apt-cacher-ng
'@ {
    frenchex2 vagrant:provision:add   `
        --name "apt-cacherng.install" `
        --os-type "Debian_64"         `
        --os-version "10.9.0"         `
        --is-bash                     `
        --code "$code"
}

# APT CONFIGURE
ExecuteWithCode @'
apt_conf_file=${apt_conf_file:="/etc/apt/apt.conf.d/00no_recommends_no_suggest"}
apt_conf=$(cat <<EOF
APT::Get::Install-Recommends "false";
APT::Get::Install-Suggests "false";
EOF
)
echo \"$apt_conf\" | sudo tee /etc/apt/apt.conf.d/00no_recommends_no_suggest 
'@ {
    frenchex2 vagrant:provision:add `
        --name "apt.configure"      `
        --os-type "Debian_64"       `
        --os-version "10.9.0"       `
        --is-bash                   `
        --code "$code"
}


# APT DIST UPGRADE
ExecuteWithCode @'
sudo apt-get update
sudo DEBIAN_FRONTEND=noninteractive apt-get -fy \
    -o Dpkg::Options::="--force-confdef"        \
    -o Dpkg::Options::="--force-confold"        \
    dist-upgrade
'@ {
    frenchex2 vagrant:provision:add `
        --name "apt.dist-upgrade"   `
        --os-type "Debian_64"       `
        --os-version "10.9.0"       `
        --is-bash                   `
        --code "$code"
}


# APT PROXY CONFIGURE
ExecuteWithCode @'
APT_PORT=${APT_PORT:=3142}

if [[ $APT_IP_FILE ]]; then
    ip=$(cat $APT_IP_FILE)
else
    ip=$APT_IP
fi
 
content=$(cat <<EOF
Acquire::http::Proxy "http://${ip}:${APT_PORT}/";
Acquire::https::Proxy "none";
EOF
)

echo "$content" | sudo tee /etc/apt/apt.conf.d/proxy.conf
echo \"APT proxy configured with ’http://${ip}:${APT_PORT}/’\"
sudo apt-get update
'@ {
    frenchex2 vagrant:provision:add  `
        --name "apt.proxy.configure" `
        --os-type "Debian_64"        `
        --os-version "10.9.0"        `
        --is-bash                    `
        --code "$code"
}

# APT PROXY UNCONFIGURE
ExecuteWithCode @'
echo \"\" | sudo tee /etc/apt/apt.conf.d/proxy.conf
'@ {
    frenchex2 vagrant:provision:add    `
        --name "apt.proxy.unconfigure" `
        --os-type "Debian_64"          `
        --os-version "10.9.0"          `
        --is-bash                      `
        --code "$code"
}

# APT UPDATE
ExecuteWithCode @'
sudo apt-get update
'@ {
    frenchex2 vagrant:provision:add `
        --name "apt.update"         `
        --os-type "Debian_64"       `
        --os-version "10.9.0"       `
        --is-bash                   `
        --code "$code"
}

# APT UPGRADE
ExecuteWithCode @'
sudo apt-get upgrade -y -o Dpkg::Options::=--force-confdef -o Dpkg::Options::=--force-confold
'@ {
    frenchex2 vagrant:provision:add `
        --name "apt.upgrade"        `
        --os-type "Debian_64"       `
        --os-version "10.9.0"       `
        --is-bash                   `
        --code "$code"
}

# INFOS
ExecuteWithCode @'
info_dir=${info_dir:=/vagrant/instance/IPv4/}
device=${device:=eth1}
ip=$(ip addr show $device | grep inet\b | awk '{print $2}' | cut -d/ -f1)
(mkdir -p $info_dir) || true
echo $ip | tee /vagrant/instance/IPv4/$(hostname)
'@ {
    frenchex2 vagrant:provision:add `
        --name "infos"              `
        --os-type "Debian_64"       `
        --os-version "10.9.0"       `
        --is-bash                   `
        --code "$code"
}


# CLEAN INSTALL
ExecuteWithCode @'
# Credits to:
#  - http://vstone.eu/reducing-vagrant-box-size/
#  - https://github.com/mitchellh/vagrant/issues/343
#  - https://gist.github.com/adrienbrault/3775253

# Unmount project
umount /vagrant

# Remove APT cache
apt-get clean -y
apt-get autoclean -y

# Zero free space to aid VM compression
dd if=/dev/zero of=/EMPTY bs=1M
rm -f /EMPTY

# Remove APT files
find /var/lib/apt -type f | xargs rm -f

# Remove documentation files
find /var/lib/doc -type f | xargs rm -f

# Remove Virtualbox specific files
rm -rf /usr/src/vboxguest* /usr/src/virtualbox-ose-guest*

# Remove Linux headers
rm -rf /usr/src/linux-headers*

# Remove Unused locales (edit for your needs, this keeps only en* and pt_BR)
find /usr/share/locale/{af,am,ar,as,ast,az,bal,be,bg,bn,bn_IN,br,bs,byn,ca,cr,cs,csb,cy,da,de,de_AT,dz,el,en_AU,en_CA,eo,es,et,et_EE,eu,fa,fi,fo,fr,fur,ga,gez,gl,gu,haw,he,hi,hr,hu,hy,id,is,it,ja,ka,kk,km,kn,ko,kok,ku,ky,lg,lt,lv,mg,mi,mk,ml,mn,mr,ms,mt,nb,ne,nl,nn,no,nso,oc,or,pa,pl,ps,qu,ro,ru,rw,si,sk,sl,so,sq,sr,sr*latin,sv,sw,ta,te,th,ti,tig,tk,tl,tr,tt,ur,urd,ve,vi,wa,wal,wo,xh,zh,zh_HK,zh_CN,zh_TW,zu} -type d -delete

# Remove bash history
unset HISTFILE
rm -f /root/.bash_history
rm -f /home/vagrant/.bash_history

# Cleanup log files
find /var/log -type f | while read f; do echo -ne '' > $f; done;

# Whiteout root
count=`df --sync -kP / | tail -n1  | awk -F ' ' '{print $4}'`;
count=$((count -= 1))
dd if=/dev/zero of=/tmp/whitespace bs=1024 count=$count;
rm /tmp/whitespace;

# Whiteout /boot
count=`df --sync -kP /boot | tail -n1 | awk -F ' ' '{print $4}'`;
count=$((count -= 1))
dd if=/dev/zero of=/boot/whitespace bs=1024 count=$count;
rm /boot/whitespace;

# Whiteout swap 
swappart=`cat /proc/swaps | tail -n1 | awk -F ' ' '{print $1}'`
swapoff $swappart;
dd if=/dev/zero of=$swappart;
mkswap $swappart;
swapon $swappart;
'@ {
    frenchex2 vagrant:provision:add `
        --name "clean1"             `
        --os-type "Debian_64"       `
        --os-version "10.9.0"       `
        --is-bash                   `
        --code "$code"
}


# CLEANUP
ExecuteWithCode @'
umount /vagrant

# Apt cleanup.
apt autoremove -y
apt update

#  Blank netplan machine-id (DUID) so machines get unique ID generated on boot.
truncate -s 0 /etc/machine-id
rm /var/lib/dbus/machine-id
ln -s /etc/machine-id /var/lib/dbus/machine-id

# Remove APT files
find /var/lib/apt -type f | xargs rm -f

# Remove documentation files
find /var/lib/doc -type f | xargs rm -f

# Remove Virtualbox specific files
rm -rf /usr/src/vboxguest* /usr/src/virtualbox-ose-guest*

# Remove Linux headers
rm -rf /usr/src/linux-headers*

# Remove Unused locales (edit for your needs, this keeps only en* and pt_BR)
find /usr/share/locale/{af,am,ar,as,ast,az,bal,be,bg,bn,bn_IN,br,bs,byn,ca,cr,cs,csb,cy,da,de,de_AT,dz,el,en_AU,en_CA,eo,es,et,et_EE,eu,fa,fi,fo,fr,fur,ga,gez,gl,gu,haw,he,hi,hr,hu,hy,id,is,it,ja,ka,kk,km,kn,ko,kok,ku,ky,lg,lt,lv,mg,mi,mk,ml,mn,mr,ms,mt,nb,ne,nl,nn,no,nso,oc,or,pa,pl,ps,qu,ro,ru,rw,si,sk,sl,so,sq,sr,sr*latin,sv,sw,ta,te,th,ti,tig,tk,tl,tr,tt,ur,urd,ve,vi,wa,wal,wo,xh,zh,zh_HK,zh_CN,zh_TW,zu} -type d -delete --force

# Remove bash history
unset HISTFILE
rm -f /root/.bash_history
rm -f /home/vagrant/.bash_history

# Add `sync` so Packer doesn't quit too early, before the large file is deleted.
sync

'@ {
    frenchex2 vagrant:provision:add `
        --name "clean2"             `
        --os-type "Debian_64"       `
        --os-version "10.9.0"       `
        --is-bash                   `
        --code "$code"
}

# DNS RESOLVER CONFIGURE
ExecuteWithCode @'
echo \"nameserver ${nameserver}\" | sudo tee /etc/resolv.conf
'@ {
    frenchex2 vagrant:provision:add     `
        --name "dns.resolver.configure" `
        --os-type "Debian_64"           `
        --os-version "10.9.0"           `
        --is-bash                       `
        --code "$code"
}

# DOCKER CLI CONFIGURE
ExecuteWithCode @'
content_dir=${context_dir:=/vagrant/instance/docker-hosts}
contexts=$content_dir/*.json

for f in $contexts
do
    echo \"Processing $f\"
    config_hostname=$(basename $f .json)
    echo "$config_hostname"
    host=$(jq -r '.host' $f)
    echo "$host"

    docker context create "docker-$config_hostname" --docker host=$host
done
'@ {
    frenchex2 vagrant:provision:add   `
        --name "docker-cli.configure" `
        --os-type "Debian_64"         `
        --os-version "10.9.0"         `
        --is-bash                     `
        --code "$code"
}

# DOCKER CLI INSTALL
ExecuteWithCode @'
sudo apt-get -y install apt-transport-https ca-certificates curl gnupg2 software-properties-common
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable"
sudo apt-get update
sudo apt-get -y install docker-ce-cli
'@ {
    frenchex2 vagrant:provision:add `
        --name "docker-cli.install" `
        --os-type "Debian_64"       `
        --os-version "10.9.0"       `
        --is-bash                   `
        --code "$code"
}

# DOCKER COMPOSE INSTALL
ExecuteWithCode @'
sudo apt-get install -y curl gdebi-core

vagrant_cache_dir=${vagrant_cache_dir:="/vagrant/.vagrant/cache"}
(mkdir -p $vagrant_cache_dir) || true

docker_compose_version=${docker_compose_version:="1.28.6"}

if [[ ! -e $vagrant_cache_dir/docker-compose_${docker_compose_version} ]]; then
  sudo curl -L \"https://github.com/docker/compose/releases/download/${docker_compose_version}/docker-compose-$(uname -s)-$(uname -m)\" -o $vagrant_cache_dir/docker-compose_${docker_compose_version}
fi

if [[ ! -e $vagrant_cache_dir/docker-compose_compl_${docker_compose_version} ]]; then
  sudo curl -L \"https://raw.githubusercontent.com/docker/compose/${docker_compose_version}/contrib/completion/bash/docker-compose\" -o $vagrant_cache_dir/docker-compose_compl_${docker_compose_version}
fi

sudo cp $vagrant_cache_dir/docker-compose_${docker_compose_version} /usr/bin/docker-compose
sudo chmod +x /usr/bin/docker-compose
'@ {
    frenchex2 vagrant:provision:add     `
        --name "docker-compose.install" `
        --os-type "Debian_64"           `
        --os-version "10.9.0"           `
        --is-bash                       `
        --code "$code"
}

# DOCKER CONFIGURE
ExecuteWithCode @'
bind_address=${bind_address:="0.0.0.0"}

docker_systemd_config=$(cat <<EOF
[Unit]
Description=Docker Application Container Engine
Documentation=https://docs.docker.com
BindsTo=containerd.service
After=network-online.target firewalld.service containerd.service
Wants=network-online.target
Requires=docker.socket

[Service]
Type=notify
# the default is not to use systemd for cgroups because the delegate issues still
# exists and systemd currently does not support the cgroup feature set required
# for containers run by docker
ExecStart=/usr/bin/dockerd -H fd:// -H tcp://${bind_address}:2375 --containerd=/run/containerd/containerd.sock
ExecReload=/bin/kill -s HUP \$MAINPID
TimeoutSec=0
RestartSec=2
Restart=always

# Note that StartLimit* options were moved from "Service" to "Unit" in systemd 229.
# Both the old, and new location are accepted by systemd 229 and up, so using the old location
# to make them work for either version of systemd.
StartLimitBurst=3

# Note that StartLimitInterval was renamed to StartLimitIntervalSec in systemd 230.
# Both the old, and new name are accepted by systemd 230 and up, so using the old name to make      
# this option work for either version of systemd.
StartLimitInterval=60s

# Having non-zero Limit*s causes performance problems due to accounting overhead
# in the kernel. We recommend using cgroups to do container-local accounting.
LimitNOFILE=infinity
LimitNPROC=infinity
LimitCORE=infinity

# Comment TasksMax if your systemd version does not support it.
# Only systemd 226 and above support this option.
TasksMax=infinity

# set delegate yes so that systemd does not reset the cgroups of docker containers
Delegate=yes

# kill only the docker process, not all processes in the cgroup
KillMode=process

[Install]
WantedBy=multi-user.target
EOF
)

echo "$docker_systemd_config" | sudo tee /lib/systemd/system/docker.service

sudo systemctl daemon-reload
sudo systemctl restart docker
'@ {
    frenchex2 vagrant:provision:add `
        --name "docker.configure"   `
        --os-type "Debian_64"       `
        --os-version "10.9.0"       `
        --is-bash                   `
        --code "$code"
}

# DOCKER CONTEXT REMOVE ALL
ExecuteWithCode @'
contexts=$(docker context list -q)

for context in $contexts
do
    docker context rm $context -f
done
'@ {
    frenchex2 vagrant:provision:add         `
        --name "docker.contexts.remove.all" `
        --os-type "Debian_64"               `
        --os-version "10.9.0"               `
        --is-bash                           `
        --code "$code"
}

# DOCKER HOST CONFIGURE
ExecuteWithCode @'
vm_max_map_count=${vm_max_map_count:="262144"}
sudo sysctl -w vm.max_map_count=$vm_max_map_count
'@ {
    frenchex2 vagrant:provision:add    `
        --name "docker-host.configure" `
        --os-type "Debian_64"          `
        --os-version "10.9.0"          `
        --is-bash                      `
        --code "$code"
}

# DOCKER INSTALL
ExecuteWithCode @'
sudo apt-get install -y curl gdebi-core

debian_id=${debian_id:=$(lsb_release -is | tr '[:upper:]' '[:lower:]')}
debian_realcodename=\"${debian_code_name:=$(lsb_release -cs | tr '[:upper:]' '[:lower:]')}\"
#debian_codename=\"${debian_realcodename}\"
realarch=$(dpkg --print-architecture)
docker_ce_cli_version=${docker_ce_cli_version:="20.10.5~3-0"}
docker_ce_cli_deb="docker-ce-cli_${docker_ce_cli_version}~${debian_id}-${debian_realcodename}_${realarch}.deb"
docker_ce_cli_deb_download_url="https://download.docker.com/linux/${debian_id}/dists/${debian_realcodename}/pool/stable/${realarch}/${docker_ce_cli_deb}"
containerd_version=${containerd_version:="1.4.4-1"}
containerd_deb="containerd.io_${containerd_version}_amd64.deb"
containerd_deb_download_url="https://download.docker.com/linux/${debian_id}/dists/${debian_realcodename}/pool/stable/${realarch}/${containerd_deb}"
docker_ce_version=${docker_ce_version:="20.10.5~3-0"}
docker_ce_deb="docker-ce_${docker_ce_version}~${debian_id}-${debian_realcodename}_${realarch}.deb"
docker_ce_deb_download_url="https://download.docker.com/linux/${debian_id}/dists/${debian_realcodename}/pool/stable/${realarch}/${docker_ce_deb}"

vagrant_cache_dir=${vagrant_cache_dir:="/vagrant/.vagrant/cache"}

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
'@ {
    frenchex2 vagrant:provision:add `
        --name "docker.install"     `
        --os-type "Debian_64"       `
        --os-version "10.9.0"       `
        --is-bash                   `
        --code "$code"
}

# GITLAB CLI INSTALL
ExecuteWithCode @'
eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)
brew install glab
'@ {
    frenchex2 vagrant:provision:add `
        --name "gitlab-cli.install" `
        --os-type "Debian_64"       `
        --os-version "10.9.0"       `
        --is-bash                   `
        --code "$code"
}

# GITLAB CLI REGISTER TOKEN
ExecuteWithCode @'
eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)
GITLAB_HOSTNAME=${GITLAB_HOSTNAME:="gitlab.com"}
GITLAB_PRIVATE_TOKEN=$(jq -r '.user.gitlab_private_token' /home/vagrant/config.json)

(glab auth login --hostname $GITLAB_HOSTNAME --token $GITLAB_PRIVATE_TOKEN) || true
'@ {
    frenchex2 vagrant:provision:add        `
        --name "gitlab-cli.token.register" `
        --os-type "Debian_64"              `
        --os-version "10.9.0"              `
        --is-bash                          `
        --code "$code"
}

# GITLAB SSH KEYSCAN
ExecuteWithCode @'
ssh-keyscan gitlab.com -y
'@ {
    frenchex2 vagrant:provision:add `
        --name "gitlab.ssh.keyscan" `
        --os-type "Debian_64"       `
        --os-version "10.9.0"       `
        --is-bash                   `
        --code "$code"
}

# HELM INSTALL
ExecuteWithCode @'
version=${version:="3.5.3"}
url=${url:="https://get.helm.sh/helm-v${version}-linux-amd64.tar.gz"}

sudo curl -L $url -o $vagrant_cache_dir/helm.$version.tar.gz

tar -zxvf helm.$version.tar.gz 
mv linux-adm64/helm /usr/local/bin/helm
chmod +x /usr/local/bin/helm
'@ {
    frenchex2 vagrant:provision:add `
        --name "helm.install"       `
        --os-type "Debian_64"       `
        --os-version "10.9.0"       `
        --is-bash                   `
        --code "$code"
}

# HOMEBREW INSTALL
ExecuteWithCode @'
sudo apt-get install -y curl

/bin/bash -c \"$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\"
echo 'eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)' | tee /home/vagrant/.profile
'@ {
    frenchex2 vagrant:provision:add `
        --name "homebrew.install"   `
        --os-type "Debian_64"       `
        --os-version "10.9.0"       `
        --is-bash                   `
        --code "$code"
}

# INTERFACES CONFIGURE
ExecuteWithCode @'
echo "TimeoutStartSec=5" | sudo tee -a /etc/systemd/system/network-online.target.wants/networking.service 
'@ {
    frenchex2 vagrant:provision:add   `
        --name "interfaces.configure" `
        --os-type "Debian_64"         `
        --os-version "10.9.0"         `
        --is-bash                     `
        --code "$code"
}

## IPV6 DISABLE
ExecuteWithCode @'
sudo /sbin/sysctl -w net.ipv6.conf.all.disable_ipv6=1

content=$(cat <<EOF
# désactivation de ipv6 pour toutes les interfaces
net.ipv6.conf.all.disable_ipv6 = 1

# désactivation de l’auto configuration pour toutes les interfaces
net.ipv6.conf.all.autoconf = 0

# désactivation de ipv6 pour les nouvelles interfaces (ex:si ajout de carte réseau)
net.ipv6.conf.default.disable_ipv6 = 1

# désactivation de l’auto configuration pour les nouvelles interfaces
net.ipv6.conf.default.autoconf = 0
EOF
)

echo \"$content\" | sudo tee -a /etc/sysctl.conf
sudo sysctl -p
'@ {
    frenchex2 vagrant:provision:add `
        --name "ipv6.disable"       `
        --os-type "Debian_64"       `
        --os-version "10.9.0"       `
        --is-bash                   `
        --code "$code"
}

# JQ INSTALL
ExecuteWithCode @'
version=${version:="1.6"}

sudo wget https://github.com/stedolan/jq/releases/download/jq-${version}/jq-linux64 -o /usr/bin/jq
sudo chmod +x /usr/bin/jq
'@ {
    frenchex2 vagrant:provision:add `
        --name "jq.install"         `
        --os-type "Debian_64"       `
        --os-version "10.9.0"       `
        --is-bash                   `
        --code "$code"
}

# # K8S CLI CONFIGURE
# ExecuteWithCode @'
# contexts=/vagrant/instance/kubernetes-hosts/*.json

# for f in $contexts
# do
#     echo \"Processing $f\"
#     config_hostname=$(basename $f .json)
#     echo "$config_hostname"
#     config_file=$(jq -r '.config' $f)
#     docker_host=$(jq -r '.host' "/vagrant/instance/docker-hosts/${config_hostname}.json")
   
#     docker context create "k8s-${config_hostname}" \
#     --default-stack-orchestrator=kubernetes \
#     --kubernetes config-file=$config_file \
#     --docker host=$docker_host

#     docker context use "k8s-${config_hostname}"
# done
# '@ {
#     frenchex2 vagrant:provision:add `
#         --name "k8s-cli.configure"  `
#         --os-type "Debian_64"       `
#         --os-version "10.9.0"       `
#         --is-bash                   `
#         --code "$code"
# }

# K8S CONFIGURE
ExecuteWithCode @'
sudo swapoff -a

if [[ $MASTER == $(hostname) ]]; then
    echo \"Running as PRIMARY MASTER\"
    sudo ufw allow 6443/tcp
    sudo ufw allow 2379:2380/tcp
    sudo ufw allow 10250/tcp
    sudo ufw allow 10251/tcp
    sudo ufw allow 10252/tcp

    k_iface=${k_iface:=enp0s8}
    k_apiserver_advertise_address=${k_apiserver_advertise_address:=$(ip addr show $k_iface | grep -Po 'inet \K[\d.]+')}
    k_pod_network_cidr=${k_pod_network_cidr:="172.18.0.0/16"}

    sudo kubeadm init --apiserver-advertise-address=${k_apiserver_advertise_address} --pod-network-cidr=${k_pod_network_cidr} 
    
    (mkdir -p $HOME/.kube) || true
    (rm /vagrant/instance/k8s.conf) || true
    sudo cp -i /etc/kubernetes/admin.conf /vagrant/instance/k8s.conf
    sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
    sudo chown $(id -u):$(id -g) $HOME/.kube/config
    kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml
    kubeadm token create --print-join-command > /vagrant/instance/k8s.join.command.create.sh
    cat /vagrant/instance/k8s.join.command.create.sh
    chmod +x /vagrant/instance/k8s.join.command.create.sh
    sudo cp -f /var/lib/kubelet/pki/kubelet-client-current.pem /vagrant/instance/kubelet-client-current.pem
else
    ROLE=${ROLE:=\"master\"}

    if [[ $ROLE == \"master\" ]]; then 
        echo \"Running as (secondary) MASTER\"
    else
        echo \"Running as WORKER\"
    fi

    sudo ufw allow 10250/tcp
    sudo ufw allow 30000:32767/tcp

    mkdir -p $HOME/.kube
    sudo cp -fi /vagrant/instance/k8s.conf $HOME/.kube/config
    sudo chown $(id -u):$(id -g) $HOME/.kube/config
    sudo mkdir -p /var/lib/kubelet/pki/
    sudo cp -fi /vagrant/instance/kubelet-client-current.pem /var/lib/kubelet/pki/kubelet-client-current.pem
    (sudo bash /vagrant/instance/k8s.join.command.create.sh) || true # will fail after timeout 40s
    sudo kubeadm reset -f
    sudo bash /vagrant/instance/k8s.join.command.create.sh
    kubectl label nodes $(hostname) kubernetes.io/role=${ROLE}
fi

kubectl cluster-info
'@ {
    frenchex2 vagrant:provision:add `
        --name "k8s.configure"      `
        --os-type "Debian_64"       `
        --os-version "10.9.0"       `
        --is-bash                   `
        --code "$code"
}

# K8S INSTALL
ExecuteWithCode @'
cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF
sudo sysctl --system

sudo apt-get -y install apt-transport-https gnupg2 curl 
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add - 
echo \"deb http://apt.kubernetes.io/ kubernetes-xenial main\" | sudo tee -a /etc/apt/sources.list.d/kubernetes.list 
sudo apt-get update


sudo apt-get -y install kubeadm kubelet kubectl 
sudo apt-mark hold kubelet kubeadm kubectl

sudo systemctl daemon-reload
sudo systemctl enable kubelet 
sudo systemctl restart kubelet

sudo kubeadm config images pull

sudo apt-get install -y ufw
sudo ufw status
sudo ufw enable
'@ {
    frenchex2 vagrant:provision:add `
        --name "k8s.install"        `
        --os-type "Debian_64"       `
        --os-version "10.9.0"       `
        --is-bash                   `
        --code "$code"
}

# KERNEL UPDATE
ExecuteWithCode @'
kernel_version=${kernel_version:=5.9.0-0.bpo.5}

echo \"deb http://deb.debian.org/debian buster-backports main contrib non-free\" | sudo tee /etc/apt/sources.list.d/buster-backport.list
sudo apt-get update

sudo apt-get install -y linux-image-${kernel_version}-amd64 linux-headers-${kernel_version}-amd64
sudo apt install -y byobu

sudo purge-old-kernels --keep 1
'@ {
    frenchex2 vagrant:provision:add `
        --name "kernel.update"      `
        --os-type "Debian_64"       `
        --os-version "10.9.0"       `
        --is-bash                   `
        --code "$code"
}

# KEYBOARD LAYOUT CONFIGURE
ExecuteWithCode @'
keyboard_layout=${keyboard_layout:=\"us\"}

content=$(cat <<EOF
XKBMODEL=\"pc105\"
XKBLAYOUT=\"$keyboard_layout\"
XKBVARIANT=\"\"
XKBOPTIONS=\"grp:alt_shift_toggle\"

BACKSPACE=\"guess\"
EOF
)

echo \"$content\" | sudo tee /etc/default/keyboard
'@ {
    frenchex2 vagrant:provision:add        `
        --name "keyboard.layout.configure" `
        --os-type "Debian_64"              `
        --os-version "10.9.0"              `
        --is-bash                          `
        --code "$code"
}

# MYSQL INSTALL
ExecuteWithCode @'
sudo DEBIAN_FRONTEND=noninteractive apt-get -fy -o Dpkg::Options::=\"--force-confdef\" -o Dpkg::Options::=\"--force-confold\" install debconf-utils
sudo debconf-set-selections <<< \"mysql-server mysql-server/root_password password root\"
sudo debconf-set-selections <<< \"mysql-server mysql-server/root_password_again password root\"
sudo DEBIAN_FRONTEND=noninteractive apt-get -fy -o Dpkg::Options::=\"--force-confdef\" -o Dpkg::Options::=\"--force-confold\" install default-mysql-server

sudo mysql -uroot -proot -e \"SET PASSWORD FOR 'root'@'localhost' = PASSWORD('root');\"

sudo mysql -uroot -proot -e \"FLUSH PRIVILEGES;\"
'@ {
    frenchex2 vagrant:provision:add `
        --name "mysql.install"      `
        --os-type "Debian_64"       `
        --os-version "10.9.0"       `
        --is-bash                   `
        --code "$code"
}

# NVM INSTALL
ExecuteWithCode @'
sudo apt install curl 
curl https://raw.githubusercontent.com/creationix/nvm/master/install.sh | bash

export NVM_DIR=\"$HOME/.nvm\"
[ -s \"$NVM_DIR/nvm.sh\" ] && \. \"$NVM_DIR/nvm.sh\"  # This loads nvm
[ -s \"$NVM_DIR/bash_completion\" ] && \. \"$NVM_DIR/bash_completion\"  # This loads nvm bash_completion

node_version=${node_version:=\"15.11\"}
nvm install $node_version
nvm use $node_version
'@ {
    frenchex2 vagrant:provision:add `
        --name "nvm.install"        `
        --os-type "Debian_64"       `
        --os-version "10.9.0"       `
        --is-bash                   `
        --code "$code"
}

# PHP COMPOSER INSTALL
ExecuteWithCode @'
EXPECTED_CHECKSUM=\"$(wget -q -O - https://composer.github.io/installer.sig)\"
php -r \"copy('https://getcomposer.org/installer', 'composer-setup.php');\"
ACTUAL_CHECKSUM=\"$(php -r \"echo hash_file('sha384', 'composer-setup.php');\")\"

if [ \"$EXPECTED_CHECKSUM\" != \"$ACTUAL_CHECKSUM\" ]
then
    >&2 echo 'ERROR: Invalid installer checksum'
    rm composer-setup.php
    exit 1
fi

php composer-setup.php --quiet
RESULT=$?
rm composer-setup.php
sudo mv composer.phar /usr/local/bin/composer
exit $RESULT
'@ {
    frenchex2 vagrant:provision:add   `
        --name "php.composer.install" `
        --os-type "Debian_64"         `
        --os-version "10.9.0"         `
        --is-bash                     `
        --code "$code"
}

# PHP INSTALL
ExecuteWithCode @'
# phpbrew needs a valid php install > 7.1
PHP_VERSION=${PHP_VERSION:=\"7.4\"}

sudo apt-get update

sudo apt -y install lsb-release apt-transport-https ca-certificates unzip
sudo wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg
echo \"deb https://packages.sury.org/php/ $(lsb_release -sc) main\" | sudo tee /etc/apt/sources.list.d/php.list
sudo apt update

sudo apt -y install php${PHP_VERSION}   \
            php${PHP_VERSION}-gd        \
            php${PHP_VERSION}-mysql     \
            php${PHP_VERSION}-xdebug    \
            php${PHP_VERSION}-dom       \
            php${PHP_VERSION}-mbstring  \
            php${PHP_VERSION}-zip

content_xdebugv3=$(cat <<EOF
zend_extension=xdebug.so
xdebug.discover_client_host=true
xdebug.mode=debug
xdebug.start_with_request=yes
EOF
)

echo \"$content_xdebugv3\" | sudo tee /etc/php/$PHP_VERSION/cli/conf.d/20-xdebug.ini 
(sudo systemctl stop apache2 && sudo a2dissite 000-default && sudo systemctl disable apache2) || true
'@ {
    frenchex2 vagrant:provision:add `
        --name "php.install"        `
        --os-type "Debian_64"       `
        --os-version "10.9.0"       `
        --is-bash                   `
        --code "$code"
}

# PHP XDEBUG DISABLE
ExecuteWithCode @'
source /home/vagrant/.phpbrew/bashrc

php_ver_full=${php_ver_full:=\"7.3.25\"}

content=$(cat <<EOF
zend_extension=xdebug.so
xdebug.discover_client_host=false
xdebug.mode=develop
xdebug.start_with_request=false
EOF
)

echo \"$content\" | tee /home/vagrant/.phpbrew/php/php-${php_ver_full}/var/db/xdebug.ini
'@ {
    frenchex2 vagrant:provision:add `
        --name "php.xdebug.disable" `
        --os-type "Debian_64"       `
        --os-version "10.9.0"       `
        --is-bash                   `
        --code "$code"
}

# PHP XDEBUG ENABLE
ExecuteWithCode @'
content=$(cat <<EOF
zend_extension=xdebug.so
xdebug.discover_client_host=true
xdebug.mode=develop
xdebug.start_with_request=true
EOF
)

echo \"$content\" | tee /home/vagrant/.phpbrew/php/php-7.4.13/var/db/xdebug.ini
'@ {
    frenchex2 vagrant:provision:add `
        --name "php.xdebug.enable"  `
        --os-type "Debian_64"       `
        --os-version "10.9.0"       `
        --is-bash                   `
        --code "$code"
}

# PHPBREW INSTALL
ExecuteWithCode @'
# phpbrew needs a valid php install > 7.1
php_ver_full=${php_ver_full:=\"7.3.25\"}

sudo apt-get update

sudo apt-get install -y         \
      procps                    \
      unzip                     \
      curl                      \
      libicu-dev                \
      zlib1g-dev                \
      libxml2                   \
      libxml2-dev               \
      libreadline-dev           \
      libzip-dev                \
      libfreetype6-dev          \
      libjpeg62-turbo-dev       \
      libpng-dev                \
      libonig-dev

curl -sS -L -O https://github.com/phpbrew/phpbrew/releases/latest/download/phpbrew.phar
chmod +x phpbrew.phar

# Move the file to some directory within your $PATH
sudo mv phpbrew.phar /usr/local/bin/

mkdir /home/vagrant/.phpbrew/
touch /home/vagrant/.phpbrew/bashrc
echo \"source /home/vagrant/.phpbrew/bashrc\" | tee -a /home/vagrant/.bash_profile

source /home/vagrant/.phpbrew/bashrc

# rocknroll
phpbrew.phar init

source /home/vagrant/.phpbrew/bashrc

phpbrew.phar install -j $(nproc) $php_ver_full +default +mysql +intl +gd
phpbrew.phar switch "php-$php_ver_full"
phpbrew.phar ext install xdebug
phpbrew.phar ext install apcu
phpbrew.phar ext install gd
phpbrew.phar ext install opcache

php -r \"copy('https://getcomposer.org/installer', 'composer-setup.php');\"
php composer-setup.php
sudo chmod +x composer.phar 
sudo mv composer.phar /usr/local/bin/
php -r \"unlink('composer-setup.php');\"

composer.phar global require hirak/prestissimo

echo \"fs.inotify.max_user_watches=524288\" | sudo tee -a /etc/sysctl.conf
sudo sysctl -p

content=$(cat <<EOF
zend_extension=xdebug.so
xdebug.discover_client_host=true
xdebug.mode=develop
xdebug.start_with_request=yes
EOF
)

echo \"$content\" | tee /home/vagrant/.phpbrew/php/php-${php_ver_full}/var/db/xdebug.ini
'@ {
    frenchex2 vagrant:provision:add `
        --name "phpbrew.install"    `
        --os-type "Debian_64"       `
        --os-version "10.9.0"       `
        --is-bash                   `
        --code "$code"
}


# POWERSHELL INSTALL
ExecuteWithCode @'
powershell_version=${powershell_version:=\"7.1.3\"}
powershell_arch=\"x64\"
powershell_deb=\"powershell-${powershell_version}-linux-${powershell_arch}.tar.gz\"
powershell_url=\"https://github.com/PowerShell/PowerShell/releases/download/v${powershell_version}/${powershell_deb}\"

sudo apt-get update
# install the requirements
sudo apt-get install -y         \
        less                    \
        locales                 \
        ca-certificates         \
        libicu63                \
        libssl1.1               \
        libc6                   \
        libgcc1                 \
        libgssapi-krb5-2        \
        liblttng-ust0           \
        libstdc++6              \
        zlib1g                  \
        curl

vagrant_cache_dir=${vagrant_cache_dir:=\"/vagrant/.vagrant/cache\"}

curl -sSL  $powershell_url -o $vagrant_cache_dir/${powershell_deb}

# Create the target folder where powershell will be placed
sudo mkdir -p /opt/microsoft/powershell/7

# Expand powershell to the target folder
sudo tar zxf $vagrant_cache_dir/${powershell_deb} -C /opt/microsoft/powershell/7

# Set execute permissions
sudo chmod +x /opt/microsoft/powershell/7/pwsh

# Create the symbolic link that points to pwsh
(sudo ln -s /opt/microsoft/powershell/7/pwsh /usr/bin/pwsh) || true
'@ {
    frenchex2 vagrant:provision:add      `
        --name "powershell-core.install" `
        --os-type "Debian_64"            `
        --os-version "10.9.0"            `
        --is-bash                        `
        --code "$code"
}

# PYTHON PIP INSTALL
ExecuteWithCode @'
sudo apt-get install -y python-pip
'@ {
    frenchex2 vagrant:provision:add `
        --name "python.pip.install" `
        --os-type "Debian_64"       `
        --os-version "10.9.0"       `
        --is-bash                   `
        --code "$code"
}

# SERVICES NETWORKING CONFIGURE
ExecuteWithCode @'
timeoutstartsec=${timeoutstartsec:=\"10sec\"}

echo \"TimeoutStartSec=$timeoutstartsec\" | sudo tee -a /lib/systemd/system/networking.service
sudo systemctl daemon-reload
'@ {
    frenchex2 vagrant:provision:add            `
        --name "services.networking.configure" `
        --os-type "Debian_64"                  `
        --os-version "10.9.0"                  `
        --is-bash                              `
        --code "$code"
}

# SSH KEYS CONFIGURE
ExecuteWithCode @'
test ! -d /home/vagrant/.ssh && mkdir /home/vagrant/.ssh

cp -Rf /vagrant/instance/ssh/id_rsa* /home/vagrant/.ssh/

chmod 700 /home/vagrant/.ssh
chmod 644 /home/vagrant/.ssh/id_rsa.pub
chmod 600 /home/vagrant/.ssh/id_rsa
'@ {
    frenchex2 vagrant:provision:add `
        --name "ssh.keys.configure" `
        --os-type "Debian_64"       `
        --os-version "10.9.0"       `
        --is-bash                   `
        --code "$code"
}

# SYSCTL CONFIGURE
ExecuteWithCode @'
max_map_count=${max_map_count:=262144}
sudo sysctl -w vm.max_map_count=$max_map_count
'@ {
    frenchex2 vagrant:provision:add `
        --name "sysctl.configure"   `
        --os-type "Debian_64"       `
        --os-version "10.9.0"       `
        --is-bash                   `
        --code "$code"
}

# UNZIP
ExecuteWithCode @'
content=$(cat <<EOF
#!/bin/sh
/usr/bin/unzip "\$@"
sleep 1
EOF
)
(sudo mkdir -p /usr/local/bin) || true
echo \"$content\" | sudo tee /usr/local/bin/unzip

sudo chmod 755 /usr/local/bin/unzip
'@ {
    frenchex2 vagrant:provision:add `
        --name "unzip"              `
        --os-type "Debian_64"       `
        --os-version "10.9.0"       `
        --is-bash                   `
        --code "$code"
}

# VAGRANT
ExecuteWithCode @'
# Add vagrant user to sudoers.
echo \"vagrant        ALL=(ALL)       NOPASSWD: ALL\" >> /etc/sudoers
sed -i \"s/^.*requiretty/#Defaults requiretty/\" /etc/sudoers

sudo apt-get install -y wget
mkdir /home/vagrant/.ssh/
wget -L -O /home/vagrant/.ssh/authorized_keys  https://github.com/mitchellh/vagrant/raw/master/keys/vagrant.pub
chmod 0600 /home/vagrant/.ssh/authorized_keys
chown -Rf vagrant:vagrant /home/vagrant 
'@ {
    frenchex2 vagrant:provision:add `
        --name "vagrant"            `
        --os-type "Debian_64"       `
        --os-version "10.9.0"       `
        --is-bash                   `
        --code "$code"
}

# VIRTUALBOX GUEST ADDITIONS INSTALL
ExecuteWithCode @'
iso_path=${iso_path:=VBoxGuestAdditions.iso}

(sudo mkdir /media/iso) || true
sudo mount $iso_path /media/iso -o loop
sudo sh /media/iso/VBoxLinuxAdditions.run
sudo umount /media/iso
'@ {
    frenchex2 vagrant:provision:add                 `
        --name "virtualbox.guest.additions.install" `
        --os-type "Debian_64"                       `
        --os-version "10.9.0"                       `
        --is-bash                                   `
        --code "$code"
}

# YQ INSTALL
ExecuteWithCode @'
version=${version:="v4.5.1"}

sudo wget https://github.com/mikefarah/yq/releases/download/v${version}/yq_linux_amd64 -O /usr/bin/yq
sudo chmod +x /usr/bin/yq
'@ {
    frenchex2 vagrant:provision:add `
        --name "yq.install"         `
        --os-type "Debian_64"       `
        --os-version "10.9.0"       `
        --is-bash                   `
        --code "$code"
}

# $provisioners = @(
#     "apt-cacherng.install",
#     "apt.configure",
#     "apt.dist-upgrade",
#     "apt.proxy.configure",
#     "apt.proxy.unconfigure",
#     "apt.update",
#     "apt.upgrade",
#     "infos",
#     "clean1",
#     "clean2",
#     "dns.resolver.configure",
#     "docker-cli.configure",
#     "docker-cli.install",
#     "docker-compose.install",
#     "docker.configure",
#     "docker.contexts.remove.all",
#     "docker-host.configure",
#     "docker.install",
#     "gitlab-cli.install",
#     "gitlab-cli.token.register",
#     "gitlab.ssh.keyscan",
#     "helm.install",
#     "homebrew.install",
#     "interfaces.configure",
#     "ipv6.disable",
#     "jq.install",
#     "k8s-cli.configure",
#     "k8s.configure",
#     "k8s.install",
#     "kernel.update",
#     "keyboard.layout.configure",
#     "mysql.install",
#     "nvm.install",
#     "php.composer.install",
#     "php.install",
#     "php.xdebug.disable",
#     "php.xdebug.enable",
#     "phpbrew.install",
#     "powershell-core.install",
#     "pyhton.pip.install",
#     "services.networking.configure",
#     "ssh.keys.configure",
#     "ssh-keys.copy",
#     "sysctl.configure",
#     "unzip",
#     "user.update",
#     "vagrant",
#     "virtualbox.guest.additions.install",
#     "yq.install"
# )

# foreach ($provision_name in $provisioners) {
#     frenchex2 vagrant:provision:associate  `
#         --machine-type-name "dev"                           `
#         --provision-name "$provision_name"
# }

# # frenchex2 vagrant:machine:up --name "dev" --instance 0

# # docker context remove remote -f

# # $name = frenchex2 vagrant:machine:name --name dev --instance 0

# # docker context create remote --docker "host=ssh://vagrant@${name}"

# # frenchex2 vagrant:machine:halt --name "dev" --instance 0
# # frenchex2 vagrant:machine:destroy --name "dev" --instance 0