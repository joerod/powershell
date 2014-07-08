<#
    .SYNOPSIS 
        This script will query all the zones on a DNS server then remove entries based on a criteria in this case IP
        Addresses
    .EXAMPLE
     remove_dns.ps1.ps1
 
#>


$domainnames =  Get-DnsServerZone -ComputerName dnsserver | ? {($_.IsReverseLookupzone -like "false") -and ($_.ZoneType -like "Primary") } |
  select -ExpandProperty ZoneName

foreach ($domainname in $domainnames){
function list{

get-wmiobject -ComputerName crpnycdcrt01 -Namespace root\microsoftDNS -Class MicrosoftDNS_ResourceRecord -Filter "domainname='$domainname'" |
 select IPAddress, ownername |
  ? {($_.IPAddress -like '172.17.*') -or ($_.IPAddress -like '172.19.*') -and ($_.IPAddress -notlike $null)} |
  Sort IPAddress #|
  #export-csv C:\Users\jorodriguez\Desktop\$domainname.csv  -NoTypeInformation
  }


ForEach($ip in list){
#gives a usable DNS name  
$ipnew = $ip.ownername -replace "\..+"
#Remove-DnsServerResourceRecord -ZoneName "corporate.local" -RRType "A" -Name $($ip.ownername) -RecordData $($ip.IPAddress)
dnscmd crpnycdcrt01 /RecordDelete $domainname $ipnew A $ip.IPAddress /f
Write-output "$ipnew $($ip.IPAddress) has been removed from DNS" 
}
 }
