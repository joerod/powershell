#find users samaccount name from real name
import-module ActiveDirectory
param
    (
        
        [Parameter(Mandatory=$true)] [string]$Name,
        [switch]$All
     )

if($all){
$user = Get-ADUser -Filter "Name -like '$Name*'" -Properties * | Select-Object Name, SamAccountName, Mail, Enabled
 if($user -eq $null){
 Write-Output "$name cannot be found"

 }
else {
$user
 }
}

else {
$user = Get-ADUser -Properties * -Filter "Name -like '$Name*'" | ? {$_.Enabled -contains "True"}  | Select-Object Name, SamAccountName, Mail
 if($user -eq $null){
 Write-Output "$name cannot be found"

 }
else {
$user
 }
}


