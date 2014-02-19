<#This script will resize a esx vmware host hdd then extend the hdd on the machine itself.  
  Prerequisits are Windows 7 and above and Windows 2008 and above, WinRM must also be enabled on the host machines. 
#>

Param(
[Parameter(Position=0,mandatory=$true)]
[string]$computername,
[Parameter(Position=1,mandatory=$true)]
[int]$newsize
)

$VMHDD = Get-HardDisk -vm $computername | ? {$_.Name -eq "hard disk 1"} 

Set-HardDisk -harddisk $VMHDD -CapacityGB (([int]$vmhdd.CapacityGB) + ([int]$newsize)) -Confirm:$false

Invoke-Command -ComputerName $computername -ScriptBlock {"rescan","select volume 2","extend" | diskpart}
