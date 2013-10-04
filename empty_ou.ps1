#This script finds empty sub OUs in the OU listed in the 4th line

function empty_OU{
Get-ADOrganizationalUnit -Filter * -SearchBase "OU=Empty,DC=contoso, DC=local" `
| Where-Object {-not ( Get-ADObject -Filter * -SearchBase $_.Distinguishedname -SearchScope OneLevel -ResultSetSize 1 )}`
| Select-Object Distinguishedname
}

#this removes each empty OU
foreach($i in empty_OU){
#removes characters from beginning and end of the empty_ou function 
$i = $i -replace "@{Distinguishedname=", ""
$i = $i -replace "}", ""

#shows progress of script
Write-Host "Removing $i"

#removes accidental deletion of object
Set-ADObject $i -ProtectedFromAccidentalDeletion $false

#removes the object from AD
Remove-ADOrganizationalUnit -Identity $i -confirm:$false

}

