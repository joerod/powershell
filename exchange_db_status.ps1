add-pssnapin Microsoft.Exchange.Management.PowerShell.E2010

#stylesheet for html email
$style = "<style>BODY{font-family: Arial; font-size: 10pt;}"
$style = $style + "TABLE{border: 1px solid black; border-collapse: collapse;}"
$style = $style + "TH{border: 1px solid black; background: #dddddd; padding: 5px; }"
$style = $style + "TD{border: 1px solid black; padding: 5px; }"
$style = $style + "</style>"

$servers = @("mailboxserver1","mailboxserver2","mailboxserver3")

Function Get-DBstatus{
foreach($server in $servers){
Get-MailboxDatabaseCopyStatus -Server $server |Select-Object DatabaseName, Mailboxserver,Status |? {($_.Status -ne "Healthy") -and ($_.Status -ne "Mounted") -and ($_.Status -notlike "Seeding*") } |ft
   # ConvertTo-Html -Head $style


    }
  }
  $status = Get-DBstatus

  if($status -ne $null){
  Send-MailMessage -To  joerod@contoso.com `
-from exchangedbalerts@contoso.com -Body ($status|Out-String) -subject "Error on Exchange DB" -smtpserver stmpmailbox -priority High
  }

