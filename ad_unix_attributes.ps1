#sets unix attribues and creates a group based on the last attribute avalible

Param(
[Parameter(Position=0,mandatory=$true)]
[string]$Username
)
Function Check-account{
get-aduser -Identity $Username
}

Function Check-GID{ 
$user = ("g_" + "$username")
get-adgroup -SearchBase "OU=UnixGroups,DC=Contoso,DC=LOCAL" -filter 'Name -eq $user'
}

Function NextGid {
#gets the next avalible gid number to assign to the object
$gidnum = (Get-ADObject -SearchBase "OU=UnixGroups,DC=Contoso,DC=LOCAL" -filter {gidnumber -like "*"}  -Properties gidnumber).gidnumber | sort gidnumber
$next = $gidnum[-1]
#skips GID 8000 
  if ($next -eq 8000){
    $next = 8001
    $next
  }
  else{
    $next++
    $next 
 }
}
$nextid = NextGid

Function Create-Group{
$group_name = ("g_" + "$username")
#creates group
New-ADGroup -Path "OU=UnixGroups,DC=Contoso,DC=LOCAL" -Name $group_name -GroupScope Global

#adds unix attributes to newly created group
Set-ADGroup -Identity $group_name -Add @{"gidNumber" = "$nextid"}
Set-ADGroup -Identity $group_name -Add @{"msSFU30NisDomain" = 'Contso'}
}

Function Check-user{
$check = get-aduser -Identity $Username -Properties * |select -ExpandProperty uidNumber
if($check -ne $null){
    Write-Output "$Username already has a UID #$check"
}

else {
    Set-ADUser -Identity $Username -replace @{msSFU30NisDomain = 'contoso'}
    Set-ADUser -Identity $Username -replace @{loginshell = '/bin/bash'}
    Set-ADUser -Identity $Username -replace @{gidnumber = "$nextid"}
    Set-ADUser -Identity $Username -replace @{uidnumber = "$nextid"}

    Write-Output "Unix attributes added to $username"
  }
}

$check = Check-GID
$check_account = Check-account

if(($check -eq $null) -and ($check_account -ne $null)){
NextGid
Create-Group
Check-user
Write-Output "Created Group and updated $username Unix attributes"
}

else {
if ($check_account -ne $null){
Check-account
Check-user
 }
}


