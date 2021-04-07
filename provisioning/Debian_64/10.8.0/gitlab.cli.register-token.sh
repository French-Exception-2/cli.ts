#!/usr/bin/env bash

eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)

GITLAB_PRIVATE_TOKEN=$(jq -r '.user.gitlab_private_token' /home/vagrant/config.json)
(glab auth login --hostname $GITLAB_HOSTNAME --token $GITLAB_PRIVATE_TOKEN) || true
