param(
    [parameter(Mandatory = $true)]   [string] $Name,
    [parameter(Mandatory = $false)]   [string] $Scope,
    [parameter(Mandatory = $false)]  [string] $PackagesPath = "./packages",
    [switch] $ChangeLocation,
    [switch] $DestroyBefore,
    [switch] $Force,
    [switch] $Independant,
    [switch] $Fixed
)

. "$PSScriptRoot/../posh_modules/_.ps1"

New-LernaWorkspace -Name:"$Name" `
    -Scope:"$Scope" `
    -PackagesPath:"$PackagesPath" `
    -DestroyBefore:$DestroyBefore `
    -Force:$Force `
    -Independant:$Independant `
    -Fixed:$Fixed