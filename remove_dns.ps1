<#
    .SYNOPSIS 
        This script will query all the zones on a DNS server then remove entries based on a criteria in this case IP
        Addresses
    .EXAMPLE
     remove_dns.ps1
#>

foreach ($domainname in (Get-DnsServerZone -ComputerName crpnycdcrt01 | ? { ($_.IsReverseLookupzone -like "false") -and ($_.ZoneType -like "Primary") } | Select-Object -ExpandProperty ZoneName)) {
  function list {

    get-wmiobject -ComputerName dnsserver -Namespace root\microsoftDNS -Class MicrosoftDNS_ResourceRecord -Filter "domainname='$domainname'" |
    Select-Object IPAddress, ownername |
    Where-Object { ($_.IPAddress -match '10.7') -or ($_.IPAddress -match '10.9') -and ($_.IPAddress -notlike $null) } |
    Sort-Object IPAddress 
  }

  ForEach ($ip in list) {
    $ipnew = $ip.ownername -replace "\..+"
    #Remove-DnsServerResourceRecord -ZoneName "corporate.local" -RRType "A" -Name $($ip.ownername) -RecordData $($ip.IPAddress)
    dnscmd crpnycdcrt01 /RecordDelete $domainname $ipnew A $ip.IPAddress /f
    Write-output "$ipnew $($ip.IPAddress) has been removed from DNS" 
  }
}
