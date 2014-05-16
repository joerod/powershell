#rewrote this script using invoke-command and net lcoalgroup cmd.  Also added logging to each function

Function Get-AdminGroups{

foreach($i in (Get-Content C:\Users\joerod\Desktop\remove_users.txt)){

#test if machine is on the network
if (-not (Test-Connection -computername $i -count 1 -Quiet -ErrorAction SilentlyContinue)) {
        Write-Warning "$i is Unavalible"
        "`r"
        $i | Out-File C:\Script_logs\remove_local_admin_$(get-date -f MM-dd-yyyy).log -Append
        }
 else {
$i | Out-File C:\Script_logs\remove_local_admin_$(get-date -f MM-dd-yyyy).log -Append
Write-Output "Added $i to list...."
(invoke-command {
$members = net localgroup administrators | 
 where {$_ -AND $_ -notmatch "command completed successfully"} | 
 select -skip 4
New-Object PSObject -Property @{
 Computername = $env:COMPUTERNAME
 Group = "Administrators"
 Users=$members
 }
} -computer $i -HideComputerName | 
Select * -ExcludeProperty RunspaceID )
  }
}
 }
$admins = Get-AdminGroups


Function Remove-Admin{

 foreach($admin in $admins){


  #deletes local accounts if conditions are met
  for($i=0;$i -lt $admin.users.count;$i++){
  if(($admin.users[$i] -ne "contoso\Domain Admins") -and ($admin.users[$i] -notlike "contoso\WkstPerm*") -and ($admin.users[$i] -notlike "administrator") -and ($admin.users[$i] -ne $null)){
    
    #Add user to Remote Desktop Users Group
   Try{
   # adds logged in use to remote desktop users group
    $logoff_user = gwmi -computername $($admin.computername) -class win32_computersystem |select -ExpandProperty UserName
      if($logoff_user -ne $null){
    $scriptblock = $ExecutionContext.InvokeCommand.NewScriptBlock("NET LOCALGROUP 'Remote Desktop Users' $logoff_user /add")
    Invoke-Command -ComputerName $($admin.computername) -ScriptBlock $scriptblock -ErrorAction Stop -ErrorVariable remotedesktop
    }
     }
     Catch{
    Write-Warning "$($admin.users[$i]) is already a member of the remote users group." #| Out-File C:\Script_logs\remove_local_admin$(get-date -f MM-dd-yyyy).log -append
    
    }
    
    Try{
    # add users who are in admin group to remote admin group
    $scriptblock2 = $ExecutionContext.InvokeCommand.NewScriptBlock("NET LOCALGROUP 'Remote Desktop Users' $($admin.users[$i]) /add")
    Invoke-Command -ComputerName $($admin.computername) -ScriptBlock $scriptblock2 -ErrorAction Stop -ErrorVariable remotedesktop
    Write-Output "Add $($admin.users[$i]) to Remote Desktop Users group on $($admin.computername)`r" #|Out-File C:\Script_logs\remove_local_admin.log -Append
    $remotedesktop  | Out-File C:\Script_logs\remove_local_admin_$(get-date -f MM-dd-yyyy).log -append
  }
   Catch{
    Write-Warning "$($admin.users[$i]) is already a member of the  remote users group." #| Out-File C:\Script_logs\remove_local_admin_$(get-date -f MM-dd-yyyy).log -append
    $($admin.users[$i]) | Out-File C:\Script_logs\remove_local_admin_$(get-date -f MM-dd-yyyy).log -append
    }
   
    #Removes user from Administrators Group
    $scriptblock = $ExecutionContext.InvokeCommand.NewScriptBlock("NET LOCALGROUP administrators $($admin.users[$i]) /delete")
    Invoke-Command -ComputerName $($admin.computername) -ScriptBlock $scriptblock -ErrorAction Stop -ErrorVariable $admingroup
    Write-Output "Delete $($admin.users[$i]) from Administrators group on $($admin.computername)`r" #|Out-File C:\Script_logs\remove_local_admin_$(get-date -f MM-dd-yyyy).log -Append


    
   }
  }
 #Logs off user
    Try{
    Invoke-Command -ComputerName $($admin.computername) { (gwmi win32_operatingsystem).Win32Shutdown(4) |Out-Null} -ErrorAction Stop -ErrorVariable logoff
    Write-Output "Logging off $logoff_user" #|Out-File C:\Script_logs\remove_local_admin_$(get-date -f MM-dd-yyyy).log -Append
   }
    Catch{
   Write-Output "Cannot log off $logoff_user" #|Out-File C:\Script_logs\remove_local_admin_$(get-date -f MM-dd-yyyy).log -Append
    }
   }
}
 
 
  Remove-Admin
