param(
    [parameter(Mandatory=$true)] [string] $Name,
    [parameter(Mandatory=$false)] [string] $TemplatesPath = "./templates"
)

. "$PSScriptRoot/../posh_modules/_.ps1"

New-Template -Name:"$Name" `
    -Scope:"$Scope" `
    -TemplatesPath:"$TemplatesPath"
