#This script finds empty sub OUs in the OU listed in the 4th line

function empty_OU{
Get-ADOrganizationalUnit -Filter * -SearchBase "OU=Empty,DC=contoso, DC=local" `
| Where-Object {-not ( Get-ADObject -Filter * -SearchBase $_.Distinguishedname -SearchScope OneLevel -ResultSetSize 1 )}`
| Select-Object Distinguishedname
}

empty_OU
