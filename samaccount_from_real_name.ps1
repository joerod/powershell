#find users samaccount name from real name
#-all switch shows every user in AD even if the account is not enabled.  

param
    (
      
        [Parameter(Mandatory=$true)] [string]$Name,
        [switch]$All
     )

if($all){
Get-ADUser -Filter "Name -like '$Name*'" -Properties * | Select-Object Name, SamAccountName, Mail, Enabled
}

else {
Get-ADUser -Properties * -Filter "Name -like '$Name*'" | ? {$_.Enabled -contains "True"}  | Select-Object Name, SamAccountName, Mail

}


