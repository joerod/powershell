<#
    .SYNOPSIS 
        Copies AD security groups from one user to another
     
#>

#Added a Param to make it easier to run this script use -CopyUser and -ToUser

Function Copy-AdGroups{
    
Param(
[String]$CopyUser,
[String]$ToUser
)
    
Foraach($GroupMember in ((get-aduser $CopyUser -Properties memberOF).memberOF){
Add-ADPrincipalGroupMembership -Identity $ToUser -MemberOf $GroupMember
Write-Verbose ("Copied {0} to {1}" -f $GroupMember,$ToUser)
}

}
#Usage
Copy-AdGroups-CopyUser joerod -ToUser avarod
