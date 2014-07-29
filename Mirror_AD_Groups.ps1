<#
    .SYNOPSIS 
        Copies AD security groups from one user to another
     
#>

#Added a Param to make it easier to run this script use -CopyUser and -ToUser
Param(
[String]$CopyUser,
[String]$ToUser
)
Function Copy-AdGroups{
foreach($i in (get-aduser $CopyUser -Properties memberOF |Select-Object memberOF -ExpandProperty memberOF)){
Add-ADPrincipalGroupMembership -Identity $ToUser -MemberOf $i
Write-Host "Copied $i to $ToUser"
}

}
Copy-AdGroups
