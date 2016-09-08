#I wrote this script as a Powershell clone to the Linux "uptime" application

Function Uptime($Computer = $env:COMPUTERNAME){
    $date = Get-Date -Format HH:mm:ss
    $lastbootuptime = Get-WmiObject win32_operatingsystem -ComputerName $Computer
    $uptime = [datetime]::Now – $lastbootuptime.ConverttoDateTime($lastbootuptime.lastbootuptime)
    $usercount = (Get-WmiObject Win32_LoggedOnUser -ComputerName $Computer | Select -ExpandProperty Antecedent -Unique).count
    Write-Output ("{0} up {1} days, {2}:{3}, {4} users" -f $date, $uptime.days, $uptime.hours, $uptime.minutes, $usercount)
}

#usage
#Uptime -Computername pc001
