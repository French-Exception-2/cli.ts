param(
    [string] $BoxKind = "debian10",
    [string] $BoxTemplate = "box-debian10",
    [string] $OSVersion = "10.9.0",
    [string] $OSType = "Debian_64",
    [string] $DiskSizeGB_HR = "200",
    [string] $BoxType = "dev-docker",
    [string] $Provider = "virtualbox",
    [string] $SHA512Checksum = "47d35187b4903e803209959434fb8b65ead3ad2a8f007eef1c3d3284f356ab9955aa7e15e24cb7af6a3859aa66837f5fa2e7441f936496ea447904f7dddfdc20",
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
    -RamGB_HR "$RamGB_HR"                   `
    -SHA512Checksum "$SHA512Checksum"