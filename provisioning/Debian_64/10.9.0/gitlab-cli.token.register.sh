#!/usr/bin/env pwsh

eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)
GITLAB_HOSTNAME=${GITLAB_HOSTNAME:=gitlab.com}
GITLAB_PRIVATE_TOKEN=$(jq -r '.user.gitlab_private_token' /home/vagrant/config.json)

(glab auth login --hostname $GITLAB_HOSTNAME --token $GITLAB_PRIVATE_TOKEN) || true