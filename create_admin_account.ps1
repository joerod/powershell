<#
    .SYNOPSIS 
    Created this script copy make admin accounts for best practices.  It copies the security groups and creates a new AD
    Account named admin
  
   .EXAMPLE
    create_admin_account.ps1 -user someuser
  
#>

Param(
    [Parameter(mandatory)]
    [string]$User
)

function Get-GroupMember($User) {
    #gets groups that are not distribution groups
    foreach ($group in ((Get-ADUser -Identity $user -Properties memberof).memberof)) {
        $group = Get-Group $group # missing
        if ($group.GroupType -like "*SecurityEnabled*") {
            Write-Output $group
        }
    }
}

function Set-NewUser($User) {
    #creates new user 
    $newuser = ($user.substring(0, 4) + "admin" ) 
    $oldaccount = Get-ADUser -Identity $user -Properties *
    #Write-Output "User account created... $newuser"

    #parses out OU path to set to new users OU
    $LikeUN = $oldaccount.DistinguishedName | Out-String
    $OU = $LikeUN.Substring($LikeUN.IndexOf("OU="))
    #Write-Output "User will be located in $OU"

    #sets password
    $password = "Strong Password" | ConvertTo-SecureString -AsPlainText -Force
    New-ADUser -Name ($($oldaccount).displayname + " (Admin)") -SamAccountName $newuser -AccountPassword $password -UserPrincipalName ($newuser + "@CONTOSO.LOCAL") -GivenName $($oldaccount).givenname -Surname $($oldaccount).Surname `
        -DisplayName ($($oldaccount).displayname + " (Admin)")  -Path $OU -ChangePasswordAtLogon $true -Enabled $true
    $newuser

    #sets email address for new admin account to admins primary account 
    Set-ADUser -Identity $newuser -add @{mail = (Get-ADUser -Identity $user -Properties mail).mail }
    Set-ADUser -Identity $newuser -EmailAddress (Get-ADUser -Identity $user -Properties mail).mail
}

function Add-Groups {
    foreach ($addgroup in $groupmember.samaccountname) {
        Write-Output "added to $addgroup"
        Add-ADGroupMember $addgroup -Members $brandnewuser
    }
}

Get-GroupMember
Set-Newuser
Start-Sleep -Sleep 5
Write-Output "Waiting for AD to catch up with the script"
Add-Groups 
