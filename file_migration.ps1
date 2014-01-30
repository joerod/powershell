<# Prerequisite robocopy
                RSAT

This script will copy files from one server (server_a) to another (server_b) using robocopy and a list of folders.  Populate a list of SAMAccount Names into a file named
userlist.txt.   
First we check to see if the folder being copied to the destination server (server_b) exists on the host server (server_a), 
if not  the folder is created and  the ACL are modified, Then the users AD profile is updated with the new home drive and specified drive letter.  

If the folder already exists on server_a robocopy copies all the contents including file perms and sends a log everything
#>

foreach($user in (Get-Content C:\Users\admin\Desktop\userlist.txt)){

#checks if user has a home directory if not it creates one on target server
if((Test-Path -Path "\\server_a\d$\user\$user") -eq $false) {
#creates new path since one does not exist
$CreatePath = New-Item -Path "\\server_b\f$\UsersNY\$user" -itemtype directory
$CreatePath = "\\server_b\f$\UserNew\$user"

#sets file permsion on new folder
$acl = Get-Acl $CreatePath
$permission = "contoso\$user","Modify", "ContainerInherit, ObjectInherit", "None", "Allow"
$accessRule = New-Object System.Security.AccessControl.FileSystemAccessRule $permission
$acl.SetAccessRule($accessRule)
$acl | Set-Acl $CreatePath

#adds new home directory to AD
$drive = "\\server_b\f$\UsersNew\"
Set-ADUser $user -HomeDirectory ("$drive" + "$user") -HomeDrive U 

  }
  else
  {
#Copies data (only delta if file already exist)
Send-mailmessage -to "Joe Rodriguez <joerod@companycom>" -From "Joe Rodriguez <joerod@companycom>" -Subject "Started Copying $User" -SmtpServer "mailserver.company.com"
robocopy \\server_a\f$\UsersOld\$user \\server_b\f$\UsersNew\$user /e /COPYALL /xo /Z /R:1000000 /W:1 /LOG+:C:\robocopy.log /tee
#Sets home drive in AD
$drive = "\\contoso\dfs\UsersNew\"
Set-ADUser $user -HomeDirectory ("$drive" + "$user") -HomeDrive U 
Send-mailmessage -to "Joe Rodriguez <joerod@companycom>"" -From "Joe Rodriguez <joerod@companycom>"" -Subject "$User has been moved" -SmtpServer "mailserver.company.com"
  }
}
