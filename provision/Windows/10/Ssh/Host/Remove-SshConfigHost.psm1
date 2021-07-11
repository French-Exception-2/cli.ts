[cmdletbinding]
function Remove-SshConfigHost {
    param(
        [parameter(Mandatory = $true)] [string] $HostName,

        [string] $Path
    )

    if ([string]::IsNullOrEmpty($Path)) {
        $Path = "$HOME\.ssh\config"
    }

    if (test-path $path) {
        $sshConfigHosts = get-content -Path $Path 
    }
    else {
        $sshConfigHosts = ""
    }

    $newSshConfig = [System.Collections.ArrayList]::new();
    $found = $false
    for ($i = 0; $i -lt $sshConfigHosts.Length; $i++) {
        if (!$found -and $sshConfigHosts[$i] -eq "Host ${HostName}") {
            $found = $true
            continue
        }
        elseif ($found -and ![string]::IsNullOrEmpty($sshConfigHosts[$i])) {
            # we have found Host xx and next line is not empty ?
            # now we are issueing sub declarations
            continue
        }
        else {
            $found = $false
        }

        if(!$found -and [string]::IsNullOrEmpty($sshConfigHosts[$i]) `
            -and [string]::IsNullOrEmpty($sshConfigHosts[$i+1])) {

            } else {
                $newSshConfig += $sshConfigHosts[$i]
            }

      
    }
    
    $newSshConfig | out-file -FilePath $Path -Encoding ASCII 
}

Export-ModuleMember -Function Remove-SshConfigHost