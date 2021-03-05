```
frenchex2 init                             Initialize
frenchex2 project:clone <git>              Clone a project into current workspace
frenchex2 project:new <name>               Create a new project in current workspace
frenchex2 vagrant:destroy <name>           Destroy a vagrant instance
frenchex2 vagrant:clone <git>             Clone a project into current workspace
frenchex2 vagrant:init                    Initialize a vagrant instance
frenchex2 vagrant:machine:add <name>      Add a new machine a new project in current workspace
frenchex2 vagrant:machine:destroy <name>  Add a new machine a new project in current workspace
frenchex2 vagrant:machine:halt <name>     Halt a machine
frenchex2 vagrant:machine:up <name>       Up a new machine in current workspace
frenchex2 vagrant:clone <git>             Clone a project into current workspace
frenchex2 vagrant:clone <git>             Clone a project into current workspace
frenchex2 project:clone <git>              Clone a project into current workspace
frenchex2 workspace:get                    Get current workspace
frenchex2 project:list                     List workspaces
frenchex2 workspace:new <name>             Create a new project in current workspace
frenchex2 workspace:set <name>             Set current workspace
```


```
vagrant:init --status --instance 1 --group "Test" --provider "virtualbox"

vagrant:type:add --name "test"                  \
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

vagrant:type:provision:add --name "test"                \ 
                           --type "test"                \ 
                           --env 'TEST_VAR1=value1'     \ 
                           --env 'TEST_VAR2=value2'

vagrant:machine:add --name "test"               \
                    --type "test"               \ 
                    --vram_mb "4096"            \
                    --no-gui                    \
                    --instances 4               
```