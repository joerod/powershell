#I created this script to gain more Bing Rewards.  I have it running as a schedualed task every hour while I'm a sleep.
#The script gets its searches by querying google trends for that day then it opens IE with the search. 

Function QueryBing($Query){
    $IE = New-Object -com internetexplorer.application
    $Query = [Web.HttpUtility]::UrlEncode($Query)
    $IE.navigate2("https://www.bing.com/search?q=" + $query)
    $IE.visible = $true
    Start-Sleep -Seconds 20
    Get-Process iexplore | Stop-Process
}

Function Get-GoogleTrends($Date){
    $result = Invoke-RestMethod -Uri "http://www.google.com/trends/hottrends/hotItems" -Method Post -Body "ajax=1&htd=$Date&pn=p1&htv=l"
    $result.trendsByDateList.trendsList.relatedSearchesList
}

$Date = Get-Date -Format yyyyMMd

Get-GoogleTrends $Date | Get-Random -Count 3 | % { QueryBing $_ }
