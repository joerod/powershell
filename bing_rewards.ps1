#I created this script to gain more Bing Rewards.  I have it running as a schedualed task every hour while I'm asleep.
#The script gets its searches by querying google trends for that day then it opens IE with the search. 
Add-Type -AssemblyName System.Web  

Function QueryBing{
 [cmdletbinding()]
   param(
   [parameter(mandatory=$true,ValueFromPipeline=$True,Position=0)]
   [string[]] $Query) 
    $IE = New-Object -ComObject internetexplorer.application
    $Query = [System.Web.HttpUtility]::UrlEncode($Query)
    $IE.navigate2("https://www.bing.com/search?q=" + $query)
    $IE.visible = $true
    Start-Sleep -Seconds 2
    Get-Process iexplore | Stop-Process -Force
    #add query to form from bing API
}

Function Get-GoogleTrends{
    [xml]$result = Invoke-WebRequest http://www.google.com/trends/hottrends/atom/feed?pn=p1
    $result.rss.channel.item.title 
}

#loop twice because the xml from google  only yeilds 20 results and bing allows 30 queries for rewards 
$i = 0
for ($i -eq 0; $i -lt 2; )
{
Get-GoogleTrends | %{QueryBing $_}
$i++
}
