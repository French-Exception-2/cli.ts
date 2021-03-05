function New-NpmProduct {
    param(
        [parameter(Mandatory = $true)]   [string] $Name,
        [parameter(Mandatory = $false)]   [string] $Scope,
        [switch] $DestroyBefore,
        [switch] $Force,
        [switch] $ChangeLocation
    )

    $location = get-location

    try {
        New-LernaWorkspace -Name:"$Name" `
        -PackagesPath:"packages" `
        -ChangeLocation:$true `
        -DestroyBefore:($DestroyBefore.IsPresent -and $DestroyBefore) `
        -Force:($Force.IsPresent -and $Force) `
        -Scope:"$Scope"

    # we are now in the lerna workspace

    $config = @{
        projects = @{
            "api"            = @{
                Name     = "api"
                Template = "api"
            }
            "lib"            = @{
                Name     = "lib"
                Template = "lib"
            }
            "cli"            = @{
                Name     = "cli"
                Template = "cli"
            }
            "api-web-client" = @{
                Name     = "api-web-client"
                Template = "api-web-client"
            }
            "api-web-server" = @{
                Name     = "api-web-server"
                Template = "api-web-server"
            }
        }
    }

    $config | convertto-json | Out-File projects.json -Encoding utf8

    $packages_location = Get-Location

    $config.projects.foreach( {
            $_.Keys.foreach( {
                    $project_name = $_
                    $project_template = $config.projects.$project_name.Template

                    set-location $packages_location

                    New-NpmProject -Name:"$RealName-${project_name}" `
                        -Scope:"$scope" `
                        -Template:"$project_template" `
                        -ChangeLocation:$false
                })
    
        })
    } catch {
        Write-Error $_
        set-location $location
    } finally {
        if (!$ChangeLocation.IsPresent) {
            set-location $location
        }
    }

    
}

Export-ModuleMember -Function New-NpmProduct
