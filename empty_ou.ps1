#This script finds empty sub OUs in the OU listed in the 4th line and removes them

function Get-EmptyOU{
Get-ADOrganizationalUnit -Filter * -SearchBase "OU=Empty,DC=contoso, DC=local" `
| Where-Object {-not ( Get-ADObject -Filter * -SearchBase $_.Distinguishedname -SearchScope OneLevel -ResultSetSize 1 )}`
| Select-Object -ExpandProperty Distinguishedname
}

#this removes each empty OU
foreach($i in Get-EmptyOU){

#shows progress of script
Write-Output "Removing $i"

#removes accidental deletion of object
Set-ADObject $i -ProtectedFromAccidentalDeletion $false

#removes the object from AD
Remove-ADOrganizationalUnit -Identity $i -confirm:$false

}

