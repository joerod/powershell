 #This script finds empty groups in the OU listed in the 4th line

 function empty_groups{
 Get-ADGroup -Filter {GroupCategory -eq 'Security'} -SearchBase "OU=Empty,DC=contoso, DC=local" | 
 {@(Get-ADGroupMember $_).Length -eq 0} | 
 Select-Object Distinguishedname -expandproperty Distinguishedname 
 }

foreach($i in empty_groups){

#shows progress of script
Write-Host $i

#removes accidental deletion of object
Set-ADObject $i -ProtectedFromAccidentalDeletion $false

#removes the object from AD
Remove-ADGroup -Identity $i -confirm:$false

}
