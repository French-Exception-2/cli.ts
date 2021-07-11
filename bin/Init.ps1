param(
    [int] $Instance = 0,
    [string] $Path = $(get-location)
)

import-module "$PSScriptRoot/../posh_modules/Utils.psm1" -Force

frenchex2 vagrant:init --instance $Instance --group "$group"

$json = get-content "$PSScriptRoot/../init.json" -raw -Encoding ascii | convertfrom-json

$machinesTypes = $json.vagrant.'machines-types'.psobject.Properties

foreach($machineType in $machinesTypes) {
    
        frenchex2 vagrant:machine-type:add              `
        $machineType.Name                               `
        --vcpus $machineType.Value.Vcpus                `
        --cpucap $machineType.Value.cpucap              `
        --os-type $machineType.Value.'os-type'          `
        --os-version $machineType.Value.'os-version'    `
        --ram-mb $machineType.Value.'ram-mb'            `
        --vram-mb $machineType.Value.'vram-mb'          `
        --no-3d                                         `
        --no-gui                                        `
        --provider $machineType.Value.provider          `
        --enabled                                       `
        --box $machineType.Value.box
}

$provisioners = @(
    'apt-cacherng.install',
    'apt.configure',
    'apt.dist-upgrade',
    'apt.proxy.configure',
    'apt.proxy.unconfigure',
    'apt.update',
    'apt.upgrade',
    'infos',
    'clean1',
    'clean2',
    'dns.resolver.configure',
    'docker-cli.configure',
    'docker-cli.install',
    'docker-compose.install',
    'docker.configure',
    'docker.contexts.remove.all',
    'docker-host.configure',
    'docker.install',
    'gitlab-cli.install',
    'gitlab-cli.token.register',
    'gitlab.ssh.keyscan',
    'helm.install',
    'homebrew.install',
    'interfaces.configure',
    'ipv6.disable',
    'jq.install',
    'k8s-cli.configure',
    'k8s.configure',
    'k8s.install',
    'kernel.update',
    'keyboard.layout.configure',
    'mysql.install',
    'nvm.install',
    'php.composer.install',
    'php.install',
    'php.xdebug.disable',
    'php.xdebug.enable',
    'phpbrew.install',
    'powershell-core.install',
    'python.pip.install',
    'services.networking.configure',
    'ssh.keys.configure',
    'sysctl.configure',
    'unzip',
    'vagrant',
    'virtualbox.guest.additions.install',
    'yq.install'
)

foreach ($provision_name in $provisioners) {
    frenchex2 vagrant:provision:associate  `
        --machine-type-name 'dev'          `
        --provision-name "$provision_name"
}

frenchex2 vagrant:machine:add 'dev' 'dev' --machine-instances 1
frenchex2 vagrant:machine:up 'dev' --machine-instance 0
