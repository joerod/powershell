get-wmiobject -ComputerName DNSServer -Namespace root\microsoftDNS -Class MicrosoftDNS_ResourceRecord -Filter "domainname='contoso.local'"`
| select IPAddress, Ownername `
| ? {$_.ipaddress -like '10.50.*'}  `
| sort ownername
