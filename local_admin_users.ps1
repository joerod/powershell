#Gets list of machines from specified OU
Function Get-CompList{
Get-ADObject -Filter { ObjectClass -eq "computer" } -SearchBase "OU=Resources,DC=NWTraders,DC=LOCAL" `
| Select-Object -expandproperty Name
}

<#
Gets Admin accounts from computers in OU from Get-Complist function, will ping machine to see if its alive and write error message
if machine is unavalible
#>
Function Get-AdminGroups{

foreach($i in Get-CompList){
 if (-not (Test-Connection -computername $i -count 1 -Quiet -ErrorAction SilentlyContinue)) {
        write-host $i.toupper() "is Unavalible"  -foreground red;
        "`r";
        continue;
        }

$adsi = [ADSI]"WinNT://$i"
$Object = $adsi.Children | ? {$_.SchemaClassName -eq 'user'} | % {
    New-Object -TypeName PSCustomObject -Property @{
        ComputerName = $i.toupper() -join ''
        UserName = $_.Name -join ''
        Groups = ($_.Groups()  |Foreach-Object {$_.GetType().InvokeMember("Name", 'GetProperty', $null, $_, $null)}) -join ',' 
          }  
      } 
      

   $Object | Select-object ComputerName,UserName,Groups |? {$_.Groups -match "Administrators*"}  
   "`r"
  
 }

  }
  
<# 
Coming soon, remove any admin account that is not "Autorized" and if the proper admin account does not exist create it.
#>
