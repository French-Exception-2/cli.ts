[cmdletbinding]
function Add-SshConfigHost {
    param(
        [Parameter(Mandatory=$true)] [string] $Hostname,

        [string] $Path, 
        [string[]] $Config
    )

    if ([string]::IsNullOrEmpty($Path)) {
        $Path = "$HOME\.ssh\config"
    }

    $newConfig = [System.Collections.ArrayList]::new();

    $newConfig.add("") | out-null

    $newConfig.AddRange($Config) | out-null

    $newConfig.add("") | out-null

    $newConfig | Out-File -FilePath $Path -Encoding ASCII -Append
}

Export-ModuleMember -Function Add-SshConfigHost