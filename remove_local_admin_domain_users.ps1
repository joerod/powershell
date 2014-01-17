#Gets list of machines from specified OU
Function Get-Complist{
Get-ADObject -Filter { ObjectClass -eq "computer" } -SearchBase "OU=Computers,DC=contoso,DC=LOCAL"`
 | Select-Object -expandproperty Name |Sort
}


<#
Gets a list of local Admin accounts from each computers in OU from Get-Complist function, will ping machine to see if its alive and write error message
if machine is unavalible
#>
Function Get-AdminGroups{

foreach($i in Get-CompList){

if (-not (Test-Connection -computername $i -count 1 -Quiet -ErrorAction SilentlyContinue)) {
        Write-Warning $i.toupper() "is Unavalible"
        "`r"
        $i | Out-File C:\Users\Administrator\Desktop\bad_machines.log -Append
        }
 else {
$i | Out-File C:\Users\Administrator\Desktop\good_machines.log -Append
Write-Output "Added $i to list...."
$adsi = [ADSI]("WinNT://$i/Administrators,group")

$Object = $adsi.PSBase.Invoke('Members') | % {
New-Object -TypeName PSCustomObject -Property @{
    ComputerName = $i.toupper() -join ''
    Users = ($_.GetType().InvokeMember('Name', 'GetProperty', $null, $_, $null)) -join ',' 
    
    }  
  } 
  $Object
    }
  }
}

$admins = 
Get-AdminGroups
 
Function Remove-Admin{


 foreach($admin in $admins){
  #deletes accounts if conditions are met
 
 if(($admin.users -ne "Domain Admins") -and ($admin.users -notlike "AD_Group_Permissions*") -and ($admin.users -notlike "Administrator") -and ($admin.users -ne $null)){
    
    Write-Output "Delete $($admin.users) on $($admin.computername)`r"
    $scriptblock = $ExecutionContext.InvokeCommand.NewScriptBlock("NET LOCALGROUP administrators $($admin.users) /delete")
    Invoke-Command -ComputerName $($admin.computername) -ScriptBlock $scriptblock
    
   }
  }
 }   

Remove-Admin 
