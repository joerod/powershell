# this script will find any pingable machine in a specified range and then list the DNS name of that IP

$ping = New-Object System.Net.NetworkInformation.Ping 
$i = 0 
1..255 | foreach { $ip = "192.168.1.$_"  
$Res = $ping.send($ip) 
 
if ($Res.Status -eq "Success") 
{ 
 
$result = $ip + " = Success" 

Write-Host $result 
$ErrorActionPreference = "Stop"
try{
nslookup $ip | findstr Name:

}
catch [System.Management.Automation.RemoteException]{
Write-Warning "$ip - Can't find DNS record"
}
 
$i++ 
 
} 
 
 
}  
$Hosts = [string]$i + " Hosts is pingable" 
Write-Host $Hosts 

#$error[0].Exception.GetType().FullName use to find the exact error powershell throws
