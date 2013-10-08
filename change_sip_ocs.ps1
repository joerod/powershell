#This scrip will change the OCS (Outlook Communicator) login to conform with the users AD login. 

$searchBase = 'ou=users,dc=contoso,dc=local'
 
$users = Get-ADUser -filter { ObjectClass -eq "user" } -SearchBase $searchBase -SearchScope Subtree -Properties *|Select-Object SamAccountName, Name

 
ForEach ($user in $users) {
   
    Write-Host "Adding SIP" $user.samaccountname "to" $user.name
    Set-ADUser -Identity $user.samaccountname -clear ProxyAddresses
    Set-ADUser -Identity $user.samaccountname -Add @{ProxyAddresses = 'sip:' + $user.samaccountname + '@im.contoso.com'}
    Set-ADUser -Identity $user.samaccountname -clear msRTCSIP-PrimaryUserAddress
    Set-ADUser -Identity $user.samaccountname -Add @{"msRTCSIP-PrimaryUserAddress" = 'sip:' + $user.samaccountname + '@im.contoso.com'}
}
