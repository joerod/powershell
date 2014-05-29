#Created this script copy make admin accounts for best practices.  It copies the security groups and creates a new AD
#Account named admin

Param(
[Parameter(Position=0,mandatory=$true)]
[string]$user
)

function get-groupmember{
#gets groups that are not distribution groups
$Groups = Get-ADUser -Identity $user -Properties * |select -expand memberof

foreach($group in $groups){
$group = Get-Group $group

if ($group.GroupType -like "*SecurityEnabled*"){
Write-Output $group
  }
 }
}

function create-newuser{
#creates new user 
$newuser = ($user.substring(0,4) + "admin" ) 
$oldaccount = Get-ADUser -Identity $user -Properties *
#Write-Output "User account created... $newuser"

#parses out OU path to set to new users OU
$LikeUN = $oldaccount.DistinguishedName | Out-String
$OU = $LikeUN.Substring($LikeUN.IndexOf("OU="))
#Write-Output "User will be located in $OU"

#sets password
$password = "Welcome1" |ConvertTo-SecureString -AsPlainText -Force
New-ADUser -Name ($($oldaccount).displayname + " (Admin)") -SamAccountName $newuser -AccountPassword $password -GivenName $($oldaccount).givenname -Surname $($oldaccount).Surname `
 -DisplayName ($($oldaccount).displayname + " (Admin)")  -Path $OU -ChangePasswordAtLogon $true -Enabled $true
$newuser

#sets email address for new account
Set-ADUser -Identity $newuser -add @{mail = (get-aduser -Identity $user -Properties mail).mail}
Set-ADUser -Identity $newuser -EmailAddress (get-aduser -Identity $user -Properties mail).mail

}

$groupmember = get-groupmember

function Add-Groups{
foreach($addgroup in $groupmember.samaccountname){
write-output "added to $addgroup"
Add-ADGroupMember $addgroup -Members $brandnewuser
 }
}

$brandnewuser = create-newuser
Write-Output "Waiting for AD to catch up with the script"
Start-Sleep -s 5
add-groups

