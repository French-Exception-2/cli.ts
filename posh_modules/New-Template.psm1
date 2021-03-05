function New-Template {
    
    param(
        [parameter(Mandatory = $true)] [string] $Name,
        [parameter(Mandatory = $false)] [string] $TemplatesPath = "./templates"
    )

    $location = Get-location

    try {
        $fullPath = "$TemplatesPath/$Name"

        if (!(test-path $fullPath)) {
            new-item $fullPath -ItemType Directory
        }

        set-location $fullPath

        npm init -f

        @"
node_modules
build
"@ | out-file .gitignore -Encoding ascii

        "" | out-file index.ts -Encoding utf8
    }
    catch {
        Write-Error $_
    }
    finally {
        set-location $location
    }

}

Export-ModuleMember -Function New-Template
