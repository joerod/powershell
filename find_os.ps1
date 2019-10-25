#this script takes a list of computers either IP or Name and shows what OS they are running. 

Param(
  [Parameter(mandatory)]
  [array[]]$Machine
)

foreach($x in $machine){
  (Get-WmiObject Win32_OperatingSystem -computer $x).caption | foreach{
    [PSCustomObject]@{
      ComputerName = $x -join ''
      "OS Version" = $_.caption -join ''
    }
  }  
} 
