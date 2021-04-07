param(
    [string] $BoxKind = "win10",
    [string] $BoxTemplate = "box-win10pro",
    [string] $OSVersion = "10",
    [string] $OSType = "Windows",
    [string] $DiskSizeGB_HR = "200",
    [string] $BoxType = "dev",
    [string] $Provider = "virtualbox",
    [int] $Cpus = 4,
    [int] $RamGB_HR = 6
)

. "${PSScriptRoot}\Build-PackerBox.ps1"     `
    -BoxKind "$boxKind"                     `
    -BoxTemplate "$boxTemplate"             `
    -OSVersion "$osversion"                 `
    -OSType "$OSType"                       `
    -DiskSizeGB_HR "$DiskSizeGB_HR"         `
    -BoxType "$BoxType"                     `
    -Provider "$Provider"                   `
    -Cpus $Cpus                             `
    -RamGB_HR $RamGB_HR