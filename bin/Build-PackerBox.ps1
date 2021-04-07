param(
    [string] $BoxKind = "debian10",
    [string] $BoxTemplate = "box-debian10",
    [string] $OSVersion = "10.8.0",
    [string] $OSType = "Debian_64",
    [string] $DiskSizeGB_HR = "200",
    [string] $BoxType = "dev-docker",
    [string] $Provider = "virtualbox",
    [parameter(Mandatory=$true)] [string] $SHA512Checksum,
    [int] $Cpus = 4,
    [int] $RamGB_HR = 2
)
import-module "$psscriptroot\util.psm1"

$ram_mb = Convert-Size -from "GB" -to "MB" -Value $RamGB_HR
$DiskSize = Convert-Size -from "GB" -to "MB" -Value $DiskSizeGB_HR

packer build  --force                       `
    --var "os_version=$OSVersion"           `
    --var "os_type=$OSType"                 `
    --var "disk_size=$DiskSize"             `
    --var "disk_size_hr=${DiskSizeGB_HR}GB" `
    --var "box_type=$BoxType"               `
    --var "cpus=$Cpus"                      `
    --var "ram=$ram_mb"                     `
    --var "SHA512Checksum=$SHA512Checksum"  `
    ".\$BoxTemplate.json"

# Win 10 Pro
# builds/{{.Provider}}-win10-{{ user `os_version` }}-{{ user `box_type` }}-{{ user `disk_size_hr` }}.box
# Win 10 Pro Dev
# builds/{{.Provider}}-win10-{{ user `os_version` }}-{{ user `box_type` }}-{{ user `disk_size_hr` }}.box
# Debian 10
# builds/{{.Provider}}-debian10-{{ user `os_version` }}-{{ user `box_type` }}-{{ user `disk_size_hr` }}.box
$box = "${provider}-${BoxKind}-${OSVersion}-${boxType}-${disksizegb_hr}GB"

vagrant box remove -f $box
vagrant box add --name $box  "builds/${box}.box"
