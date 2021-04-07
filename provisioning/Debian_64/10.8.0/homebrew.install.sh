#!/usr/bin/env bash

sudo apt-get install -y curl

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
echo 'eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)' >> /home/vagrant/.profile
eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)
