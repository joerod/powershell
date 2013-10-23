#This script reads off a csv with column 1 being a list of IPs and column 2 the corresponding computer names.  

$list = Import-Csv C:\temp\removedns.csv

ForEach($ip in $list){

dnscmd dnsserver /RecordDelete contoso.local $ip.name A $ip.ip /f
Write-Host "$($ip.name) has been removed from DNS" 
}
