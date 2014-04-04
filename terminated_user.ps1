#Runs check to make sure AD Module and Exchange plugins are isntalled
Function Get-MyModule 
{ 
if(-not(Get-Module -name "ActiveDirectory")) {
try
{
Import-Module ActiveDirectory -ErrorAction Stop
}
catch{
Write-Output "Please install Windows Server Administrator tools"
  }
 }
}
Get-MyModule

if ((Get-PSSnapin -Name Microsoft.Exchange.Management.PowerShell.e2010 -ErrorAction SilentlyContinue) -eq $null){

try{
add-pssnapin Microsoft.Exchange.Management.PowerShell.e2010 -ErrorAction Stop
 }

Catch{
Write-Output "Please install EMC for Exchange 2010"
 }
}


#####            Start Main Script         #####

Param(
[string]$termuser
)

#####             AD processes             #####               

Function Disable-User{
#disable user
Disable-ADAccount -Identity $termuser
Write-Output "*  $termuser has been disabled"
}

Function Reset-password{
#creates random 10 charecter password
$randomObj = New-Object System.Random
$NewPassword=""
1..10 | ForEach { $NewPassword = $NewPassword + [char]$randomObj.next(33,126) }
Set-ADAccountPassword -Identity $termuser -Reset -NewPassword -NewPassword (ConvertTo-SecureString -AsPlainText $NewPassword -Force)
Write-Output "*  Password reset to $NewPassword"
}

Function Remove-Groups{
#removes from all distribution groups
$dlists =(Get-ADUser $termuser -Properties memberof | select -expand memberof)
foreach($dlist in $dlists){Remove-ADGroupMember $termuser -Identity $dlist -Confirm:$False}
Write-Output "*  Removed $termuser from $dlists"
}

Function MoveOU{
#Move to "Disabled Users" OU
Move-ADObject -Identity $termuser -TargetPath 'OU=Disabled,OU=Users,DC=CONTOSO,DC=LOCAL'
Write-Output "*  $termuser moved to Disabled Users"
}

Function Remove-Manager{
#Removes manager from AD profile
$findoldmanager = Get-ADUser $termuser -Properties * |select -ExpandProperty Manager
$oldmanager = Get-ADUser $findoldmanager |select -ExpandProperty Name
Set-ADUser $termuser -Manager $null
Write-Output "*  Removed manager $oldmanager from $termuser"
}

Function Get-TermTimestamp{
#Time stamp added to AD user account 
$terminatedby = $env:username
$termDate = get-date -uformat "%m/%d/%y"
$termUserDesc = "Terminated " + $termDate + " - " + $terminatedby
set-ADUser $termuser -Description $termUserDesc 
write-output "*  $termuser description set to $termUserDesc"
}

#####      Mailbox and OCS processes      #####

Function Set-MailboxHidden{
#Hides user from Outlook GAL
Set-Mailbox -identity $termuser -HiddenFromAddressListsEnabled $true
Write-Output "*  $termuser Has been removed from GAL"
}

Function Move-disabledMB{
#Moves mailbox to disabled mailbox DisabledUserMailbox
$oldmailbox = Get-Mailbox -Identity $termuser |select -ExpandProperty servername
New-MoveRequest -Identity $termuser -TargetDatabase 'DisabledUserMailbox'
Write-Output "*  $termuser has been moved from $oldmailbox.toupper() to DisabledUserMailbox"
}

Function Disable-OCS{
#Disables users account in OCS
Set-ADUser -Identity $termuser -clear msRTCSIP-UserEnabled
Set-ADUser -Identity $termuser -clear msRTCSIP-PrimaryHomeServer
Set-ADUser -Identity $termuser -clear msRTCSIP-PrimaryUserAddress
Set-ADUser -Identity $termuser -clear msRTCSIP-OptionFlags
Write-Output "*  $termuser OCS has been disabled"
}

Disable-User
Reset-password
MoveOU
Remove-Groups
Remove-Manager
Set-MailboxHidden
Move-disabledMB
Disable-OCS
Get-TermTimestamp
