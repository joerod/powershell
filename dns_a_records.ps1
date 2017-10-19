param(
[string]$DNSServer,
[string]$DomainName,
[string]$IPAddress
)

get-wmiobject -ComputerName $DNSServer -Namespace root\microsoftDNS -Class MicrosoftDNS_ResourceRecord -Filter "domainname='$DomainName'"|
 select IPAddress, Ownername |
 ? {$_.ipaddress -like '$IPAddress'}  |
 sort ownername
