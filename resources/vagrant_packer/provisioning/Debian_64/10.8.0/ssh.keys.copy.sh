#!/usr/bin/env bash

test ! -d $HOME/.ssh && mkdir $HOME/.ssh

machines=/vagrant/.vagrant/machines/*

for m in $machines
do
    name=$(basename $m)
    echo "Processing $name"

    cp -f /vagrant/.vagrant/machines/$name/virtualbox/private_key $HOME/.ssh/$name
    chmod 600 $HOME/.ssh/$name

    content=$(cat << EOF

Host $name
  User vagrant
  Port 22
  UserKnownHostsFile /dev/null
  StrictHostKeyChecking no
  PasswordAuthentication no
  IdentityFile /home/vagrant/.ssh/$name
  IdentitiesOnly yes
  LogLevel FATAL

EOF
)
    echo "$content" | tee -a $HOME/.ssh/config
done
