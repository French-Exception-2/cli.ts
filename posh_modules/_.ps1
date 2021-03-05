$modules=@("Bootstrap-Instance", 
    "New-LernaWorkspace", 
    "New-NpmProduct",
    "New-NpmProject",
    "New-Template"
    )

foreach ($module in $modules){
    Import-Module "$PSScriptRoot/$module.psm1" -force
}