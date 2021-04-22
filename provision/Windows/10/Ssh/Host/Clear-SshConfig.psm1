[cmdletbinding]
function Clear-SshConfig {
    param(
        [string] $Path
    )

  if ([string]::IsNullOrEmpty($Path)) {
      $Path = "$HOME\.ssh\config"
  }

  $content = get-content $path

  $replaced = $content.replace("\r\r", "")
  
  $replaced | out-file $Path -Encoding ASCII
}

Export-ModuleMember -Function Clear-SshConfig