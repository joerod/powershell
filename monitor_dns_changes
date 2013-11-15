#Get machines and date added from DNS and exports to CSV for comparison

Function Get-DNSentry{
Get-WMIObject -Computer crpnycdcrt01 -Namespace "root\MicrosoftDNS" -Class "MicrosoftDNS_AType" `
-Filter "ContainerName='contoso.local' and TimeStamp <> 0" `
|Select-Object OwnerName, IPAddress, @{n="Date";e={([datetime]"1.1.1601").AddHours($_.Timestamp)}} `
|sort Date `
|Export-Csv C:\temp\update.csv -NoTypeInformation 
}

Get-DNSentry

Function Compare-CSV {
$baseline = Import-csv -Path C:\temp\baseline.csv -Header "Computername","IPAddress", "Date" #| Sort-Object Property "Computername" 
$new = Import-csv -Path C:\temp\update2.csv -Header "Computername","IPAddress", "Date"# | Sort-Object Property "Computername"

Compare-Object $baseline $new -Property "Computername" -PassThru | Where-Object{$_.SideIndicator -eq '=>'} `
| Select-Object  "Computername", "IPAddress", "Date"
}

#Send email only if there is a differance from the baseline DNS entries
Function Send-Email {
   #SMTP server name
     $smtpServer = "smtp.server.com"

     #Creating a Mail object
     $msg = new-object Net.Mail.MailMessage

     #Creating SMTP server object
     $smtp = new-object Net.Mail.SmtpClient($smtpServer)

     #Email structure 
     $msg.From = "email@address.com"
     $msg.ReplyTo = "replyto@address.com"
     $msg.To.Add("to@address.com")
     $msg.subject = "Email Subject"
     $msg.body = Compare-CSV 

     #Sending email 
     $smtp.Send($msg)
}

#Only sends email if there is a change
if (Compare-CSV -ne $null) {
     Send-Email
   } 




