<#this script will move a machine to the proper OU based on OS

#>
$machines = Get-ADObject -SearchBase "OU=WIN7,DC=CONTOSO,DC=LOCAL" -Filter * -Properties * |
  select operatingSystem, DistinguishedName
foreach ($machine in $machines){
  if($machine.operatingSystem  -match "Windows XP Professional"){
   Move-ADObject -Identity $machine.DistinguishedName -TargetPath "OU=WINXP,DC=CONTOSO,DC=LOCAL"
   Write-Output "$machine has been moved"
   }
  }
