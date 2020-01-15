Function Connect-qBtorrent {
  [CmdletBinding()]
  #[OutputType([Microsoft.PowerShell.Commands.WebRequestSession])]
  Param (
    $Username,
    $Password,
    $Computer,
    $Port
  )
  Invoke-RestMethod -Uri "http://$($computer):$($Port)/api/v2/auth/login" -Body "username=$Username&password=$Password" -Method Post -SessionVariable webSession
  $Global:Session = $websession
}
Function Remove-qBtorrent {
  #start session
  [CmdletBinding(SupportsShouldProcess = $True)]
  Param (
    $Hash,
    $DeleteFiles = 'false',
    $Computer,
    $Port,
    $WebSession
  )
  #if torrent is completely downloaded delete it
  if ($PSCmdlet.ShouldProcess("Removing $Hash")) {
    Invoke-RestMethod  -Uri "http://$($computer):$($Port)/api/v2/torrents/delete?hashes=$($Hash)&deleteFiles=$($DeleteFiles)" -Method Get -webSession $webSession
  }
}
Function Get-qBtorrentInfo {
  #start session
  [CmdletBinding()]
  Param (
    $Filter,
    $WebSession,
    $Computer,
    $Port
  )
  $uri = "http://$($computer):$($Port)/api/v2/torrents/info"
  if ($Filter) {
    $uri = $uri + "?filter=$($Filter)"
  }
  Invoke-RestMethod -Uri $uri -Method Get -webSession  $webSession
}

$Password = ""
$Username = 'admin'
$Port = ""
$Computer = ""
[int]$minutes = '1'

Connect-qBtorrent -Username $Username -Password $Password -Computer $Computer -Port $Port
while ($results = Get-qBtorrentInfo -WebSession $session -Computer $Computer -Port $port) {
  foreach ($result in $results) {
    switch ($result.state) {
      'downloading' {
        Write-Warning ("Still leeching: {0} - {1}%" -f $($result.name), [math]::Round($($($result.progress) * 100), 2))
      }
      'uploading' {
        Write-output "Removing $($result.name)"
        Remove-qBtorrent -WebSession $session -Hash $result.hash -Computer $Computer -Port $port
      }
    }
    if ((Get-qBtorrentInfo -WebSession $session -Computer $Computer -Port $port).Count -eq 0) {
      Write-output "You're all leeched up... Ending"
      return
    }
  }
  Start-Sleep ($minutes * 60)
}
