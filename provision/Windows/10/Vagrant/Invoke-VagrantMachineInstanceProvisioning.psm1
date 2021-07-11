function Invoke-VagrantMachineInstanceProvisioning {
    param(
        [parameter(Mandatory = $true)] [string] $MachineName,
    )
    vagrant provision $MachineName 
}

Export-ModuleMember -Function Invoke-VagrantMachineInstanceProvisioning