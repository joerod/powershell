#Added a Param to make it easier to run this script use -CopyUser and -ToUser
Param(
[String]$CopyUser,
[String]$ToUser
)
Function Copy-AdGroups{
$groupname = get-aduser $CopyUser -Properties memberOF |Select-Object memberOF -ExpandProperty memberOF
foreach($i in $groupname){
Add-ADPrincipalGroupMembership -Identity $ToUser -MemberOf $i
Write-Host "Copied $i to $ToUser"
}

}
Copy-AdGroups
