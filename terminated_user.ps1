add-pssnapin Microsoft.Exchange.Management.PowerShell.Admin

Param(
[string]$termuser
)

Function Disable-User{
#disable user
Disable-ADAccount -Identity $termuser
}

Function Remove-Groups{
#removes from all distribution groups
$dlists =(Get-ADUser $termuser -Properties memberof | select -expand memberof)
foreach($dlist in $dlists){Remove-ADGroupMember $termuser -Identity $dlist -Confirm:$False}
write-output "* Removed $termuser from all distribution and security groups"
}

Function MoveOU{
#Move to "Disabled Users" OU
write-output "* " $termuser "moved to Disabled Users"
}

Function Get-TermTimestamp{
#Time stamp added to AD user account 
$terminatedby = $env:username
$termDate = get-date -uformat "%m/%d/%y"
$termUserDesc = "Terminated " + $termDate + " - " + $terminatedby
set-ADUser $termuser -Description $termUserDesc 
write-output "* " $termuser "description set to" $termUserDesc
}

Function Set-MailboxHidden{
#Hides user from Outlook GAL
Set-Mailbox -identity $termuser -HiddenFromAddressListsEnabled $true
write-output "* " $termuser "Has been removed from GAL"
}

Function Disable-OCS{
#Disables users account in OCS
Get-ADUser $termuser| Set-ADUser -clear msRTCSIP-UserEnabled
Set-ADUser -Identity $termuser -Add @{'msRTCSIP-UserEnabled' = $False}
write-output "* " $termuser "OCS has been disabled"
}

Disable-User
Remove-Groups
MoveOU
Get-TermTimestamp
Set-MailboxHidden
Disable-OCS
