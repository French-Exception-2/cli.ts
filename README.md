```
frenchex2 config:dump                     Dump configuration
frenchex2 config:get                      Get value from configuration
frenchex2 config:set                      Set value and save configuration
frenchex2 docker:context:add              Docker add a context
frenchex2 docker:context:list             Docker list contexts
frenchex2 init                            Initialize
frenchex2 k8s:endpoint:add                Kubernetes Add endpoint
frenchex2 packer:add                      Packer Add an existing template
frenchex2 packer:box                      Packer run build
frenchex2 packer:clean                    Packer clean builds and artefacts
frenchex2 packer:destroy                  Packer destroy build
frenchex2 packer:edit                     Packer edit build file
frenchex2 packer:init                     Packer initialize a directory
frenchex2 packer:list                     List available Packer boxes
frenchex2 project:add <directory>         Add an existing directory as a project into current workspace
frenchex2 project:clone                   Clone a project
frenchex2 project:list <name>             List project instances
frenchex2 project:new <name>              Create a new project in current workspace
frenchex2 vagrant:init                    Initialize a Vagrant instance
frenchex2 vagrant:machine:add             Add a new machine
frenchex2 vagrant:machine:destroy <name>  Add a new machine a new project in current workspace
frenchex2 vagrant:machine:halt            Halt a machine
frenchex2 vagrant:machine:provision:add   Add new Vagrant Machine Provisioning
frenchex2 vagrant:machine:up              Up a new machine in current workspace
frenchex2 vagrant:ssh-config              Print ssh-config for machines
frenchex2 vagrant:type:add                Add new Vagrant Machine Type
frenchex2 vagrant:type:list               List Vagrant Machine Types
frenchex2 vagrant:type:provision:add      Add new Vagrant Type Provisioning
frenchex2 vscode:init                     Init .vscode directory
frenchex2 workspace:clone                 Clone a workspace
frenchex2 workspace:get                   Get current workspace
frenchex2 workspace:list                  List workspaces
frenchex2 workspace:new <name>            Create a new project in current workspace
frenchex2 workspace:set <name>            Set current workspace
```


These example commands must be run in the same folder.

```
vagrant:init --status --instance 1 --group "Test" --provider "virtualbox"

vagrant:type:add --name "my-dev-machine-type"    \
                 --vcpus 4                       \ 
                 --os_type Debian_64             \
                 --os_version "10.8.0"           \
                 --ram_mb 2048                   \
                 --vram_mb 8                     \
                 --no-3d                         \
                 --no-gui                        \
                 --provider virtualbox           \
                 --enabled                       \
                 --box "debian/contrib-buster64"

vagrant:type:provision:add --name "docker.install"       \ 
                           --type "my-dev-machine-type"  \ 
                           --env 'DOCKER_VAR1=value1'    \ 
                           --env 'DOCKER_VAR2=value2'    \
                           --edit

vagrant:machine:add --name "dev"                   \
                    --type "my-dev-machine-type"   \ 
                    --vram_mb "4096"               \
                    --no-gui                       \
                    --instances 1       

vagrant:machine:provision:add --name "docker.configure"     \ 
                              --type "my-dev-machine-type"  \ 
                              --env 'DOCKER_VAR1=value1'    \ 
                              --env 'DOCKER_VAR2=value2'    \
                              --edit

vagrant:machine:ssh --name dev [--instance 0]
```