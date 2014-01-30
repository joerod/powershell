#This script reads off a csv with column 1 being a list of IPs and column 2 the corresponding computer names.  


ForEach($ip in (Import-Csv C:\temp\removedns.csv){

dnscmd dnsserver /RecordDelete contoso.local $ip.name A $ip.ip /f
Write-Output "$($ip.name) has been removed from DNS" 
}
