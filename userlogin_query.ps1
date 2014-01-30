Param(
[Parameter(Position=0,mandatory=$true)]
[string]$Username,
[switch]$Last
)

$csv = Import-Csv \\share\Logon.log
$array = $csv | ? {$_.username -eq $Username} | % {

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
