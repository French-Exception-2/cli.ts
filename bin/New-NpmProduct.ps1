param(
    [parameter(Mandatory = $true)]   [string] $Name,
    [parameter(Mandatory = $false)]   [string] $Scope,
    [switch] $DestroyBefore,
    [switch] $Force
)

. "$PSScriptRoot/../posh_modules/_.ps1"

New-NpmProduct -Name:"$Name" `
    -SCope:"$SCope" `
    -DestroyBefore:$DestroyBefore `
    -force:$Force