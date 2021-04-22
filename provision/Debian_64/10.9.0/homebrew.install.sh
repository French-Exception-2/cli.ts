#!/usr/bin/env pwsh

sudo apt-get install -y curl

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
echo 'eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)' | tee /home/vagrant/.profile
