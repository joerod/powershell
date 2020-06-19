#Requires -Version 5.1
#this script takes a list of computers either IP or Name and shows what OS they are running. 
function Find-OS {
  Param(
    [array[]]$ComputerName = $env:COMPUTERNAME
  )

  foreach($x in $ComputerName){

    (Get-WmiObject Win32_OperatingSystem -computer $x).caption | foreach{
      [PSCustomObject]@{
        ComputerName = $x -join ''
        "OS Version" = $_.caption -join ''
      }
    }  
  } 
}
