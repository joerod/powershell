  
<#This script will resize a esx vmware host hdd then extend the hdd on the machine itself.  
  Prerequisits are Windows 7 and above and Windows 2008 and above, WinRM must also be enabled on the host machines. 
#>
Function VMHDDResize {
  Param(
    [Parameter(mandatory)]
    [string]$ComputerName,
    [Parameter(mandatory)]
    [int]$NewSize
  )
  
  $VMHDD = Get-HardDisk -vm $ComputerName | where-object {$_.Name -eq "hard disk 1"} 
  
  Set-HardDisk -harddisk $VMHDD -CapacityGB (([int]$vmhdd.CapacityGB) + ([int]$newsize)) -Confirm:$false
  
  Invoke-Command -ComputerName $ComputerName -ScriptBlock {"rescan","select volume 2","extend" | diskpart}
}
