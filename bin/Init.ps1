param(

)

if (test-path .vagrant) {
    Remove-Item -recurse -force .vagrant
}

frenchex2 vagrant:init --instance 1 --group "Test"

frenchex2 vagrant:machine-type:add                          `
                         --name "dev"                       `
                         --vcpus 4                          `
                         --cpucap 100                       `
                         --os_type "Debian_64"              `
                         --os_version "10.8.0"              `
                         --ram_mb 2048                      `
                         --vram_mb 8                        `
                         --no-3d                            `
                         --no-gui                           `
                         --provider "virtualbox"            `
                         --enabled                          `
                         --box "debian/contrib-buster64"

frenchex2 vagrant:machine-type:provision:add                `
                        --name "apt.configure"              `
                        --type "dev"                        

frenchex2 vagrant:machine-type:provision:add                `
                        --name "apt.update"                 `
                        --type "dev"                        

frenchex2 vagrant:machine-type:provision:add                `
                        --name "docker.install"             `
                        --type "dev"                        

frenchex2 vagrant:machine-type:provision:add                `
                        --name "docker.configure"           `
                        --type "dev"                        

frenchex2 vagrant:machine:add --name "dev"                  `
                        --type "dev"                        `
                        --instance 0                        `
                        --status

frenchex2 vagrant:machine:up --name "dev" --instance 0

docker context remove remote -f

$name = frenchex2 vagrant:machine:name --name dev --instance 0

docker context create remote --docker "host=ssh://vagrant@${name}"

frenchex2 vagrant:machine:halt --name "dev" --instance 0
frenchex2 vagrant:machine:destroy --name "dev" --instance 0