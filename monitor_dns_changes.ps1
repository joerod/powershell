#Get machines and date added from DNS and exports to CSV for comparison
<# Use this if your using windows 2008 or prior
Function Get-DNSentry{
Get-WMIObject -Computer DNSServer -Namespace "root\MicrosoftDNS" -Class "MicrosoftDNS_AType" `
-Filter "ContainerName='contoso.local' and TimeStamp <> 0" `
|Select-Object OwnerName, IPAddress, @{n="Date";e={([datetime]"1.1.1601").AddHours($_.Timestamp)}} `
|sort Date `
|Export-Csv C:\temp\update.csv -NoTypeInformation 
}
#>

#Use this for Windows 2012 DNS server
Function Get-DNSentry{
Get-DnsServerResourceRecord -zonename contoso.local |Select-Object Hostname, TimeStamp|sort Hostname `
| Export-Csv C:\Scripts\update.csv -NoTypeInformation 
}


Get-DNSentry

Function Compare-CSV {
$baseline = Import-csv -Path C:\temp\baseline.csv -Header "Computername","IPAddress", "Date" 
$new = Import-csv -Path C:\temp\update2.csv -Header "Computername","IPAddress", "Date"

Compare-Object $baseline $new -Property "Computername" -PassThru | Where-Object{$_.SideIndicator -eq '=>'} `
| Select-Object  "Computername", "IPAddress", "Date"
}

#Creates email
Function Send-Email {
Send-mailmessage 
-to "Joe Rodriguez <joerod@company.com>" `
-From "Joe Rodriguez <joerod@company.com>" `
-Subject "DNS Changes" `
-SmtpServer "mailserver.com"`
-Body (Compare-CSV | Format-Table | Out-String)

  
}

#Only sends email if there is a change
if (Compare-CSV -ne $null) {
     Send-Email
   } 




