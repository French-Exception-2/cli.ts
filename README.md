# TL;DR

Easily boot a multi-environment.

Simply edit your structure.ps1 so it maps what you want,

Then run command to up your infrastructure.

# Structure.ps1

```powershell

$structure = $( ./structure.ps1 )

```

## Example

```powershell
PS C:\code\frenchex2\cli.ts_i1> $structure


Name                           Value     
----                           -----     
Provider                       virtualbox
Version                        1.0.0     
Acme                           acme
BareMetals                     {BAREMETAL-00, BAREMETAL-01, BAREMETAL-02}
Environments                   {PREPROD, UAT, CI, PROD…}
DNS                            {Intranet, Extranet}
Registries                     {VAGRANT, NPM, DOCKER, APT}
TLD                            fr

```

# Initialize Infrastructure

```powershell
infra:init
infra:up
``` 

This will
* Initialize a git repository
* Put your structure.ps1 here
* Git it
* Boot k8s cluster for infra env
* Boot Aptitude Reverse Proxy-cache on infra
* publish public IP & PORT to infra

```powershell

git:init --flow
npm:init --scope acme --name infra
vagrant:init --name "infra" --git
vagrant:machine-type:add "infra" --group infra
vagrant:machine-type:provision:add "apt.cacherng.install" --type "infra"
vagrant:machine:add --name infra --instance 0 --group infra 
vagrant:machine:up --group infra
$ip = $( vagrant:machine:ip --group infra --instance 0 --name infra --json ) | convertfrom-json
config:set --global apt.registry.ip $ip[0].IP

```


# Initialize Environments

```powershell
environment:init --all
environment:up --all
```

This will
* Create a new package for each env, representing environment
* Add this package to the infra package.json
* Git this as a repository
* Boot them using interface shell scripts
* Create Bastion VMs to access environments
* Create networks accross hosts and isolate them

















For example :


```powershell
vagrant:init --status                       `
             --instance $instance           `
             --group "${Group}-Infra"       `
             --provider "${Provider}"

vagrant:machine-type:add --name "infra-dev"              `
                         --vcpus 4                       ` 
                         --os_type Debian_64             `
                         --os_version "10.8.0"           `
                         --ram_mb 2048                   `
                         --vram_mb 8                     `
                         --no-3d                         `
                         --no-gui                        `
                         --provider "$provider"          `
                         --enabled                       `
                         --box "debian/contrib-buster64"

vagrant:machine-type:provision:add --name "apt.cacherng.install"       ` 
                                   --type "infra-dev"                  `
                                   --create-if                         `
                                   --edit-if                           

vagrant:machine-type:provision:add --name "npm.registry.install"       ` 
                                   --type "infra-dev"                  `
                                   --create-if                         `
                                   --edit-if        
                   
vagrant:machine:add --name "infra-dev"          `
                    --type "infra-dev"
                    --instance 0

npm:registry:add "infra-dev"
apt:proxy:add "infra-dev"

vagrant:commit -m"Initial commit"
vagrant:tag 0.0.1
vagrant:push

```


## Add your bare-metals IPs and private keys

```powershell

foreach($BareMetal in $BareMetals) {
    vagrant:host:add --name "${BareMetal.Hostname}"                     `
                     --ip "${BareMetal.IP}"                             `
                     --private_key "${BareMetal.PrivateKeyFile}"        `
                     --apt-proxy-ip "${apt.Proxy.IP}"                   `
                     --route 
                     --inititialize
}

```

# Initialize your cluster
```powershell


```



k8s:cluster:init --name "k8s-dev"               `
                 --instance 0                   `

config:set npm.registry http://10.100.2.5:8080
config:set vagrant.registry http://10.100.2.3
config:set docker.registry http://10.100.2.4
config:set scope "@acme"

route:add 10.100.2.0 /24 $host_ip

vagrant:init --status --instance 1 --group "Test" --provider "virtualbox"

vagrant:type:add --name "my-dev-machine-type"    `
                 --vcpus 4                       ` 
                 --os_type Debian_64             `
                 --os_version "10.8.0"           `
                 --ram_mb 2048                   `
                 --vram_mb 8                     `
                 --no-3d                         `
                 --no-gui                        `
                 --provider virtualbox           `
                 --enabled                       `
                 --box "debian/contrib-buster64"

vagrant:type:provision:add --name "docker.install"       ` 
                           --type "my-dev-machine-type"  ` 
                           --env 'DOCKER_VAR1=value1'    ` 
                           --env 'DOCKER_VAR2=value2'    `
                           --edit

vagrant:machine:add --name "dev"                   `
                    --type "my-dev-machine-type"   ` 
                    --vram_mb "4096"               `
                    --no-gui                       `
                    --instances 1       

vagrant:machine:provision:add --name "docker.configure"     ` 
                              --type "my-dev-machine-type"  ` 
                              --env 'DOCKER_VAR1=value1'    ` 
                              --env 'DOCKER_VAR2=value2'    `
                              --edit

vagrant:machine:ssh --name dev [--instance 0]

workspace:init local --vagrant dev --dev

project:clone --all --configure dev --install --also dev

k8s:cluster:init --instance 1 
                 --also dev                         `
                 --code "c:\code\k8s_i1"            `
                 --masters 1                        `
                 --workers 3                        `
                 --workerRAM_mb 3072                `
                 
```