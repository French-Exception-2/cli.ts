# TL;DR

Frenchex2 CLI.ts is a Node.js & TypeScript application which helps you configure versatile development environments.

Using Packer, Vagrant and VirtualBox, you will be able to create your Agile Software Factory instance and tooling.

# Dependencies

* Git
* Node.js
* Packer
* Vagrant
* Virtual Box
* VS Code
* PowerShell Core

## Installation

### Windows 10

Installing Chocolatey

```powershell
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
```

Installing dependencies & configuring main host

```powershell
choco install -y git packer vagrant virtualbox vscode powershell.core nvm
```

```powershell
# Node.js install and use v15
nvm install 15.11.0
nvm use 15.11.0

# generate user ssh key
ssh-keygen -f

# vagrant plugins
vagrant plugin install vagrant-vbguest
vagrant plugin install vagrant-reload
vagrant plugin install vagrant-hostmanager

mkdir $HOME/code
cd $HOME/code

git clone git@github.com:French-Exception-2/cli.ts.git frenchex2/cli.ts_i1

cd frenchex2/cli.ts_i1

npm install --also dev
npm install --global # make it globally available

```

# Initialize new Agile Software Factory instance

```powershell
frenchex2 asf:init --name "My ASF"  `
         --instance 1               `
         --acme "My ACME"           `
         --git                      `
         --edit                     `
         --editor "vscode"          
```

This will : 

* Initialize a new directory
* Initialize a new Git repository
* Initialize a config.json and a config-local.json files
* Mark Name, and ACME into config.json
* Mark instance # in config-local.json
* Create first commit
* Edit your instance configuration within VS Code

## Configuring your Agile Software Factory Instance

Adding a pattern of hosts :

```powershell
frenchex2 asf:hosts:add                 `
    --pattern                           `
    --name "baremetal-X"                `
    --pattern "instance=X"              `
    --pub-file "./ssh/id_rsa-X.pub"     `
    --keyfile "./ssh/id_rsa-X"          `
    --hypervisor "virtualbox"
```

Adding an Host :

```powershell
frenchex2 asf:hosts:add             `
            --type "baremetal-X"    `
            --instance 1            `
            --ip "10.100.2.2"       `
            --install
```
The `--install` switch will install all dependencies automatically.
