[cmdletbinding]
function Update-SshConfigHost {
    param(
        [parameter(Mandatory = $true)] [string] $HostName,

        [parameter(Mandatory = $true)] [scriptblock] $ConfigCommand,

        [string] $Path
    )

    Remove-SshConfigHost -HostName $HostName -Path $Path

    $result = $ConfigCommand | Invoke-Expression

    Add-SshConfigHost -HostName $HostName -Path $Path -Config $result

    Clear-SshConfig -Path $Path
}

Export-ModuleMember -Function Update-SshConfigHost