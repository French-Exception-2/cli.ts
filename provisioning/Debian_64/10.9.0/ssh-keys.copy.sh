#!/usr/bin/env pwsh

test ! -d $HOME/.ssh && mkdir $HOME/.ssh

machines=/vagrant/.vagrant/machines/*

for m in $machines
do
    name=$(basename $m)
    echo Processing