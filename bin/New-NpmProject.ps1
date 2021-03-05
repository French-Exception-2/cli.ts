param(
    [parameter(Mandatory = $true)] [string] $Name,
    [parameter(Mandatory = $true)] [string] $Scope,
    [parameter(Mandatory = $true)]  [string] $Template,
    [parameter(Mandatory = $false)]  [string] $PackagesPath = "./packages",
    [switch] $ChangeLocation,
    [switch] $DestroyBefore,
    [switch] $Force
)

. "$PSScriptRoot/../posh_modules/_.ps1"

New-NpmProject -Name:"$Name" `
    -Scope:"$Scope" `
    -Template:"$Template" `
    -PackagesPath:"$PackagesPath" `
    -ChangeLocation:$false `
    -Force:$Force