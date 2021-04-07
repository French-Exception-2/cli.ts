param(
    [string] $BoxKind = "debian10",
    [string] $BoxTemplate = "box-debian10",
    [string] $OSVersion = "10.8.0",
    [string] $OSType = "Debian_64",
    [string] $DiskSizeGB_HR = "200",
    [string] $BoxType = "dev-docker",
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
    -RamGB_HR "$RamGB_HR"