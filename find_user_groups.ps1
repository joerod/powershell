#this will find all the users in the domain and what groups they belong to.  Editing the Get-ADUser filter will narrow down
# the results

Function Export-usernamegroup{

foreach ($username in (Get-ADUser -filter * |select -expand samaccountname)) { 

Get-ADPrincipalGroupMembership $username | select -ExpandProperty name |
 % {

New-Object -TypeName PSCustomObject -Property @{
    Name = Get-ADUser -Identity $username -Properties Name | select -ExpandProperty Name 
    Group = $_

     } 
    }
          
 }
 }
 
 Export-usernamegroup
