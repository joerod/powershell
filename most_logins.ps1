<# This script uses my user login script (https://github.com/joerod/powershell/blob/master/logon.ps1) log and finds 
what machine the user logs into most.  In my environment users log into several machines, this makes finding their primary
machine much easier.  I will use this script in subsequent scripts to auto find the users primary machine and preform an 
action
#>

Param(
[Parameter(Position=0,mandatory=$true)]
[string]$Name
)

foreach($user in (Get-ADUser -Properties * -Filter "Name -like '$Name*'" | ? {$_.Enabled -contains "True"})){
$array = Import-Csv \\Path\to\Share\Logon.log | ? {$_.username -eq $user.samaccountname} | % {

New-Object -TypeName PSCustomObject -Property @{
    Name = $user.name
    SAMAccoutName = $user.samaccountname
    ComputerName = $_.computername 
     } 
    }

$array | sort | group ComputerName | sort Count | select -ExpandProperty Group | select -last 1
    

}
