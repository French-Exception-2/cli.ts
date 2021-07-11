
<#
.SYNOPSIS
Execute a scriptblock with "$code" referenced

.DESCRIPTION
Helper to execute $Expression with a scope reference to "$code",
helping

.PARAMETER Code
Parameter containg a @"" textblock to be referenced in $Expression

.PARAMETER Expression
Parameter containg code using "$code" text

.EXAMPLE

ExecuteWithCode @'
sudo=${sudo:=sudo}
apt_get=${apt_get:="apt-get"}
apt_cacher_ng_deb_name=${apt_cacher_ng_deb_name:="apt-cacher-ng"}
DEBIAN_FRONTEND=noninteractive $sudo -E $apt_get install -y ${apt_cacher_ng_deb_name}
echo "BindAddress: 0.0.0.0" | sudo tee -a /etc/apt-cacher-ng/acng.conf
# give tim to apt cacher ng to load up
sleep 5
sync
sudo systemctl daemon-reload
sudo systemctl restart apt-cacher-ng
'@ {
    frenchex2 vagrant:provision:add    `
    --name "apt.cacherng.install"      `
    --os-type "Debian_64"              `
    --os-version "10.9.0"              `
    --is-bash                   `
    --code "$code"
}


.NOTES
This is a simple helper providing great flexibility in writing code.
#>
function ExecuteWithCode {
    param(
        [parameter(Mandatory=$true)] [string]       $Code,
        [parameter(Mandatory=$true)] [scriptblock]  $Expression
    )

    $Expression | Invoke-Expression
}

Export-ModuleMember -Function ExecuteWithCode