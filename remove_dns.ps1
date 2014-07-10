<#
    .SYNOPSIS 
        This script will query all the zones on a DNS server then remove entries based on a criteria in this case IP
        Addresses
    .EXAMPLE
     remove_dns.ps1
#>


foreach ($domainname in (Get-DnsServerZone -ComputerName crpnycdcrt01 | ? {($_.IsReverseLookupzone -like "false") -and ($_.ZoneType -like "Primary") } |select -ExpandProperty ZoneName)){
function list{

get-wmiobject -ComputerName dnsserver -Namespace root\microsoftDNS -Class MicrosoftDNS_ResourceRecord -Filter "domainname='$domainname'" |
 select IPAddress, ownername |
  ? {($_.IPAddress -like '10.7.*') -or ($_.IPAddress -like '10.9.*') -and ($_.IPAddress -notlike $null)} |
  Sort IPAddress #|
  #export-csv C:\Users\jorodriguez\Desktop\$domainname.csv  -NoTypeInformation
  }


ForEach($ip in list){
$ipnew = $ip.ownername -replace "\..+"
#Remove-DnsServerResourceRecord -ZoneName "corporate.local" -RRType "A" -Name $($ip.ownername) -RecordData $($ip.IPAddress)
dnscmd crpnycdcrt01 /RecordDelete $domainname $ipnew A $ip.IPAddress /f
Write-output "$ipnew $($ip.IPAddress) has been removed from DNS" 
}
 }
