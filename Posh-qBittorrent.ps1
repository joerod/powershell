<#
I wrote this script to remove a torrent from my qBittorrent list once it has completed.  I know I'm a leecher ;-)
You must enble the WebUI and set a username and password in qBittorrent for this to work.
More info - https://github.com/qbittorrent/qBittorrent/wiki/WebUI-API-Documentation
#> 

#start session
Invoke-RestMethod -Uri "http://192.168.1.2:6969/login" -Body "username=admin&password=password" -Method Post -SessionVariable myWebSession
#get all torrents running
$torrents = Invoke-RestMethod  -Uri "http://192.168.1.2:6969/query/torrents" -Method Get -WebSession $myWebSession

#if torrent is completely downloaded delete it
foreach($torrent in $torrents){
    if($torrent.progress -eq 1){
      Invoke-RestMethod  -Uri "http://192.168.1.2:6969/command/delete" -Method Post -WebSession $myWebSession -Body "hashes=$($torrent.hash)"
    }
}
