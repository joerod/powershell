Param(
[Parameter(Position=0,mandatory=$true)]
[string]$Username,
[switch]$Last
)

$array = Import-Csv \\share\Logon.log | ? {$_.username -eq $Username} | % {

New-Object -TypeName PSCustomObject -Property @{
    ComputerName = $_.computername 
    "Logon Date" = $_.date
     } 
    }


if($Last){

$array[-1] 
}

else
{
$array
    }
