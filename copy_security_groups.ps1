Param(
[Parameter(Position=0,mandatory=$true)]
[string]$SourceGroup,

[Parameter(Position=0,mandatory=$true)]
[string]$DestinationGroup
)

$SourceGroupCheck = Get-ADGroup -Identity $SourceGroup 
$DestinationGroupCheck = Get-ADGroup -filter {sAMAccountName -eq $DestinationGroup}

$Group = Get-ADGroupMember -Identity $SourceGroupCheck.SamAccountName

 if($DestinationGroupCheck -ne $null){
   Write-Output "Copying users from $SourceGroup to $DestinationGroup"
   foreach ($Person in $Group) { 
      Add-ADGroupMember -Identity $DestinationGroupCheck.SamAccountName -Members $Person.distinguishedname 

                                 }
                            }

 else {
 Write-Output "$DestinationGroup does not exist... Creating Group"
 New-ADGroup -Name $DestinationGroup -Path ($SourceGroupCheck.DistinguishedName -replace '^[^,]*,','') -GroupScope Global
    foreach ($Person in $Group) { 
      Add-ADGroupMember -Identity $DestinationGroup -Members $Person
 Write-Output "Group created and users copied"
                                 }
 }
                         
