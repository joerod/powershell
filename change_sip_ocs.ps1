
#spat this
#This scrip will change the OCS (Outlook Communicator) login to conform with the users AD login. 

 
ForEach ($user in (Get-ADUser -filter { ObjectClass -eq "user" } -SearchBase 'ou=users,dc=contoso,dc=local' -SearchScope Subtree -Properties *|Select-Object SamAccountName, Name)) {
   
    Write-Host "Adding SIP" $user.samaccountname "to" $user.name
    Set-ADUser -Identity $user.samaccountname -clear ProxyAddresses
    Set-ADUser -Identity $user.samaccountname -Add @{ProxyAddresses = 'sip:' + $user.samaccountname + '@im.contoso.com'}
    Set-ADUser -Identity $user.samaccountname -clear msRTCSIP-PrimaryUserAddress
    Set-ADUser -Identity $user.samaccountname -Add @{"msRTCSIP-PrimaryUserAddress" = 'sip:' + $user.samaccountname + '@im.contoso.com'}
}
