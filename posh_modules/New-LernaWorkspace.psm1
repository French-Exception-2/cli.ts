function New-LernaWorkspace {
    param(
        [parameter(Mandatory = $true)]   [string] $Name,
        [parameter(Mandatory = $false)]  [string] $Scope,
        [parameter(Mandatory = $false)]  [string] $PackagesPath = "./packages",
        [switch] $ChangeLocation,
        [switch] $DestroyBefore,
        [switch] $Force,
        [switch] $Independant,
        [switch] $Fixed
    )

    $location = get-location

    try {

        if ([string]::IsNullOrEmpty($Scope)) {
            $Scope = $( $(jq -r '.name' $location/package.json ) -replace "/dev", "")
        }

        New-NpmProject -Name "$Name-dev" `
            -Scope:"$Scope" `
            -DestroyBefore:($DestroyBefore.IsPresent -and $DestroyBefore -eq $true) `
            -Force:($Force.IsPresent -and $Force -eq $true) `
            -ChangeLocation:$true `
            -PackagesPath:"$PackagesPath" `
            -Template:"lerna-workspace"
    

        # We are now in the location of the new Lerna workspace 
        get-location

        $lernaJson = @{
            version  = "0.0.0"
            packages = @('packages/*')
        }

        $lernaJson | out-file lerna.json

        new-item -path packages -ItemType Directory

        npm i --save ts-node
    }
    catch {
        Write-Error $_
        Set-location $location
    }
    finally {
        if (!$ChangeLocation.IsPresent) {
            set-location $location
        }
    }
}

Export-ModuleMember -Function New-LernaWorkspace