#Gets list of machines from specified OU
Function Get-CompList{
Get-ADObject -Filter { ObjectClass -eq "computer" } -SearchBase "OU=Resources,DC=NWTraders,DC=LOCAL" `
| Select-Object -expandproperty Name
}


<#
Gets a list of local Admin accounts from each computers in OU from Get-Complist function, will ping machine to see if its alive and write error message
if machine is unavalible
#>
Function Get-AdminGroups{

foreach($i in Get-CompList){
 if (-not (Test-Connection -computername $i -count 1 -Quiet -ErrorAction SilentlyContinue)) {
        write-host $i.toupper() "is Unavalible"  -foreground red
        "`r"
        }
 else {

$adsi = [ADSI]"WinNT://$i"
$Object = $adsi.Children | ? {$_.SchemaClassName -eq 'user'} | % {
$UserName = $_.Name -join '';
New-Object -TypeName PSCustomObject -Property @{
    ComputerName = $i.toupper() -join ''
    UserName = $UserName
    Groups = ($_.Groups()  |Foreach-Object {$_.GetType().InvokeMember("Name",'GetProperty', $null, $_, $null)}) -join ',' 
    Disabled = (Get-WmiObject -ComputerName $i -Class Win32_UserAccount -Filter "LocalAccount='$true' and name='$UserName'"|Select-Object -expandproperty Disabled) -join ''
    }  
  } 

      

   $Object | Select-object ComputerName,UserName,Groups,Disabled |? {$_.Groups -match "Administrators*"}  
   "`r"
   }
  }
 }

#$admins = 
Get-AdminGroups 

#built-in admin account not named "winroot" will be changed via group policy
 Function Remove-Admin{

 
 foreach($admin in $admins){
 #renames a local account named winroot that is not built-in then disables it.  This is done so our GPO will can rename the built-in admin account to winroot.
 if($admin.UserName -eq "winroot" -and $admin.groups -eq "Administrators,Users"){
 $user = [ADSI]"WinNT://$($admin.computername)/$($admin.UserName),user"
 $user.psbase.rename("winroot_old")

 $user = [ADSI]"WinNT://$($admin.computername)/winroot_old"
 $user.UserFlags[0] = $User.UserFlags[0] -bor 0x2
 $user.SetInfo()

 Write-host $($admin.computername) "has been renamed to winroot_old"

 #disables all local accounts
 if($admin.UserName -ne "winroot"){
 $user = [ADSI]"WinNT://$($admin.computername)/$($admin.UserName)"
 $user.UserFlags[0] = $User.UserFlags[0] -bor 0x2
 $user.SetInfo()
 Write-host -NoNewline "\\$($admin.computername) $($admin.UserName) has been disabled"

 
 #enables winroot built-in account if its disabled
 if($admin.UserName -eq "winroot" -or "Administrator" -and $admin.groups -eq "Administrators"){
 $user = [ADSI]"WinNT://$($admin.computername)/winroot"
 $user.UserFlags[0] = $User.UserFlags[0] -bxor 0x2
 $user.SetInfo()
 Write-host "$($admin.computername)\winroot has been enabled"



 }

    else {

 Write-host "$($admin.computername) is OK"

 }

 
     }
    }   
   }
  }

Remove-Admin
