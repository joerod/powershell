#this script takes a list of computers either IP or Name and shows what OS they are running. 

Param(
[Parameter(Position=0,mandatory=$true)]
[array[]]$Machine
)

foreach($x in $machine){

(Get-WmiObject Win32_OperatingSystem -computer $x).caption | %{

New-Object -TypeName PSCustomObject -Property @{
    ComputerName = $x -join ''
    "OS Version" = $_.caption -join ''
   }
    }  
  } 
