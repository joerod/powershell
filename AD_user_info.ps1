#This script will find users in AD with email address like @contoso.com, print out specific properties in this case displayname
#mailm street adddress, OfficePhone, MobilePhone, then export this to a CSV

$searchBase = 'ou=users,ou=resources,dc=contoso,dc=local'
 
$users = Get-ADUser -filter {mail -like '*@contoso.com'} -SearchBase $searchBase 

Foreach ($user in $users){ 
Get-ADUser -Identity $user -Properties Displayname, Mail, StreetAddress, OfficePhone, MobilePhone `
|select Displayname, Mail, StreetAddress, OfficePhone, MobilePhone |
 Export-Csv -Path C:\Users\admin\Desktop\contoso_users.csv -Append
}
