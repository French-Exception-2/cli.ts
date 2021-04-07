#!/bin/bash -eux

# Add vagrant user to sudoers.
echo "vagrant        ALL=(ALL)       NOPASSWD: ALL" >> /etc/sudoers
sed -i "s/^.*requiretty/#Defaults requiretty/" /etc/sudoers

sudo apt-get install -y wget
mkdir /home/vagrant/.ssh/
wget -L -O /home/vagrant/.ssh/authorized_keys  https://github.com/mitchellh/vagrant/raw/master/keys/vagrant.pub
chmod 0600 /home/vagrant/.ssh/authorized_keys
chown -Rf vagrant:vagrant /home/vagrant 