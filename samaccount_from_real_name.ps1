#find users samaccount name from real name
param
    (
        [Parameter(Mandatory=$true)] [string]$Name
      )

Get-ADUser -Filter "Name -like '*$Name*'" -Properties * | Select-Object Name, SamAccountName, mail
