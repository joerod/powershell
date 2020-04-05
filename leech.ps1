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

$Password = "" # API password for qbittorrent
$token = "" # Token for plex API
$Username = 'admin' # password for qbittorrent
$Port = '6969' # port for qbittorrent
$plex = $Computer = '192.168.1.231' # address of plex server and where qbittorrent is running
[int]$minutes = '1' # how often to check on downloading file(s)

Connect-qBtorrent -Username $Username -Password $Password -Computer $Computer -Port $Port
while ($results = Get-qBtorrentInfo -WebSession $session -Computer $Computer -Port $port) {
  foreach ($result in $results) {
    switch ($result.state) {
      {$_ -in 'uploading','stalledUP'} {
        Write-output "Removing $($result.name)"
        Remove-qBtorrent -WebSession $session -Hash $result.hash -Computer $Computer -Port $port
        # refresh plex if a movie is downloaded
        $return = Invoke-restmethod -uri "http://$($plex):32400/library/sections?X-Plex-Token=$($token)"
        foreach ($path in ($results.save_path | Select-Object -Unique)) {
          if($id = $return.MediaContainer.Directory.Location | Where-Object { ($_.path + "\") -eq $path}){
            Invoke-restmethod -uri "http://$($plex):32400/library/sections/$($id.id)/refresh??force=1&X-Plex-Token=$($token)"
          }
          else{
            Write-warning ("Could not find folder {0} to refresh in Plex" -f ($($id.path) ? $($id.path) : "Null"))
          }
        }
      }
      default {
        Write-Warning ("Still leeching: {0} - {1}%" -f $($result.name), [math]::Round($($($result.progress) * 100), 2))
      }
    }
    if ((Get-qBtorrentInfo -WebSession $session -Computer $Computer -Port $port).Count -eq 0) {
      Write-output "You're all leeched up... Ending"
      return
    }
  }
  Start-Sleep ($minutes * 60)
}

