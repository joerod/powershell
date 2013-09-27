$strUserName = Read-Host 'Enter username'
$newuser = Read-Host 'Copy groups to this user'
$groupname = get-aduser $strUserName -Properties memberOF |Select-Object memberOF -ExpandProperty memberOF
foreach($i in $groupname){
Add-ADPrincipalGroupMembership -Identity $newuser -MemberOf $i
}
