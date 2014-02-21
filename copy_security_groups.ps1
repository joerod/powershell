$Source_Group = "CN=GouptoCopy,OU=Groups,OU=Resources,DC=contoso,DC=LOCAL" 
$Destination_Group = "CN=CopytoGroup,OU=Groups,OU=Resources,DC=contoso,DC=LOCAL" 

foreach ($Person in ($Target)Get-ADGroupMember -Identity $Source_Group)) { 
    Add-ADGroupMember -Identity $Destination_Group -Members $Person.distinguishedname 
}
