# GCE spin up traditional vm 
$region = "us-east1"
$zone = "us-east1-b" 
$DiskSizeGB = "50"
$MemorySizeMB = "16384"

Write-Output "Allocating public IP address..."
$address = Add-GceAddress -Name $Name -Region $region
Write-Output "Creating boot disk..."
$bootDiskImage = Get-GceImage "windows-cloud" -Family "windows-2016"
$bootDisk = New-GceDisk $Name -DiskType "pd-ssd" -Image $bootDiskImage -SizeGb $DiskSizeGB  -Zone $zone 
Write-Output "Creating new Compute instance..."
Add-GceInstance $Name -Address ($address).AddressValue -BootDisk $bootDisk -CustomCpu 2 -CustomMemory $MemorySizeMB -Zone $zone -Region $region

#remove vm
get-GceInstance testvm6 -Zone $zone| Remove-GceInstance 
