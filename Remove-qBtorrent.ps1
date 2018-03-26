Function Remove-qBtorrent {
    #start session
    [CmdletBinding(SupportsShouldProcess = $True)]
    Param ($Password,
    $Username='admin')
    Begin {
        Write-Verbose "Creating Session"
        #get all torrents running
        [void](Invoke-RestMethod -Uri "http://localhost:6969/login" -Body "username=$Username&password=$Password" -Method Post -SessionVariable myWebSession) 
    }
    Process {
        foreach ($torrent in (Invoke-RestMethod  -Uri "http://localhost:6969/query/torrents" -Method Get -WebSession $myWebSession)) {
            Write-Verbose ("Checking: {0} - {1}" -f $($torrent.name), $($torrent.progress).tostring("P"))
            if ($torrent.progress -eq 1) {
                #if torrent is completely downloaded delete it
                if ($pscmdlet.ShouldProcess($torrent)) {
                    Write-Verbose "Removing $($torrent.name)"
                    Invoke-RestMethod  -Uri "http://localhost:6969/command/delete" -Method Post -WebSession $myWebSession -Body "hashes=$($torrent.hash)"
                }
            }
        }
    }
} 

Remove-qBtorrent -Password "foobar" -Verbose
