#!/usr/bin/env bash

test ! -d /home/vagrant/.ssh && mkdir /home/vagrant/.ssh

cp -Rf /vagrant/instance/ssh/id_rsa* /home/vagrant/.ssh/

chmod 700 /home/vagrant/.ssh
chmod 644 /home/vagrant/.ssh/id_rsa.pub
chmod 600 /home/vagrant/.ssh/id_rsa

