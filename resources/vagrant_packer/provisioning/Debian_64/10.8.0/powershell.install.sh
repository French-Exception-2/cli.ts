#!/usr/bin/env bash

powershell_version=${powershell_version:="7.1.2"}
powershell_arch="x64"
powershell_deb="powershell-${powershell_version}-linux-${powershell_arch}.tar.gz"
powershell_url="https://github.com/PowerShell/PowerShell/releases/download/v${powershell_version}/${powershell_deb}"

sudo apt-get update
# install the requirements
sudo apt-get install -y \
        less \
        locales \
        ca-certificates \
        libicu63 \
        libssl1.1 \
        libc6 \
        libgcc1 \
        libgssapi-krb5-2 \
        liblttng-ust0 \
        libstdc++6 \
        zlib1g \
        curl

vagrant_cache_dir=${vagrant_cache_dir:="/vagrant/.vagrant-cache"}

curl -sSL  $powershell_url -o $vagrant_cache_dir/${powershell_deb}

# Create the target folder where powershell will be placed
sudo mkdir -p /opt/microsoft/powershell/7

# Expand powershell to the target folder
sudo tar zxf $vagrant_cache_dir/${powershell_deb} -C /opt/microsoft/powershell/7

# Set execute permissions
sudo chmod +x /opt/microsoft/powershell/7/pwsh

# Create the symbolic link that points to pwsh
(sudo ln -s /opt/microsoft/powershell/7/pwsh /usr/bin/pwsh) || true

rm $vagrant_cache_dir/${powershell_deb}