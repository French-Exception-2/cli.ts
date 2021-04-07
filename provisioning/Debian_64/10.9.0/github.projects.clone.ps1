#!/usr/bin/env pwsh

if (!(test-path $HOME/code)){
    mkdir $HOME/code
}

set-location $HOME/code

$groups_of_projects=$(jq -r '.github' /vagrant/projects.json)

foreach ($groups_of_project in $groups_of_projects){
    foreach($group in $groups_of_project) {
        write-output $group
    }
}