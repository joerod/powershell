<# powershell leacher for qbtorrent.
   removes torrents that are 100%
   stops running when all torents are complete
#>

Function Remove-qBtorrent {
    #start session
    [CmdletBinding(SupportsShouldProcess = $True)]
    Param (
        $Password,
        $Username,
        $Port,
        $Computer
    )
    Begin {
        Write-Verbose "Creating Session"
        #get all torrents running
        Invoke-RestMethod -Uri "http://$($computer):$($Port)/api/v2/auth/login" -Body "username=$Username&password=$Password" -Method Post -SessionVariable myWebSession -Verbose:$false
    }
    Process {
        foreach ($torrent in (Invoke-RestMethod -Uri "http://$($computer):$($Port)/api/v2/torrents/info?filter=downloading" -Method Get -WebSession $myWebSession -Verbose:$false)) {
          if ($torrent.progress -ne 1) {
          Write-Verbose ("Checking: {0} - {1}" -f $($torrent.name), $($torrent.progress).tostring("P"))
          }
          else {
                #if torrent is completely downloaded delete it
                if ($PSCmdlet.ShouldProcess("Remove $($torrent.name)")) {
                    Write-Verbose "$($torrent.name)"
                    Invoke-RestMethod  -Uri "http://$($computer):$($Port)/api/v2/torrents/delete?hashes=$($torrent.hash)&deleteFiles=false" -Method Post -WebSession $myWebSession -Verbose:$false

                }
            }
        }
    }
}

$Password = ""
$Username = 'admin'
$Port = ''
$Computer = ''
[int]$minutes = '1'

Invoke-RestMethod -Uri "http://$($computer):$($Port)/api/v2/auth/login" -Body "username=$Username&password=$Password" -Method Post -SessionVariable myWebSession -Verbose:$false | Out-Null
while($(($results = Invoke-RestMethod -Uri "http://$($computer):$($Port)/api/v2/torrents/info?filter=downloading" -Method Get -WebSession $myWebSession -Verbose:$false).Count) -ne 0){
  $remove_result = Remove-qBtorrent -Password $Password -Computer $computer -username $username -port $port
  foreach($result in $results){
    if($results.Count -eq 1 -and $null -ne $remove_result){
      Write-Warning ("Still leeching: {0} - {1}%" -f $($result.name), [math]::Round($($($result.progress) * 100),2))
    }
  }
  if($results.Count -gt 0){Start-Sleep ($minutes * 60)
  }
}
