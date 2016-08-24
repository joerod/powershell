$Computer = $env:COMPUTERNAME
$File = 'C:\Users\joerod\Desktop\Delete Driveway Camera Videos.xml'
[xml]$Task = Get-Content $File
#Adding 15 seconds to give time for the script to complete and the task to execute
[string]$Date =  (Get-Date).AddSeconds(15).ToString("MM/dd/yyyy hh:mm:ss")
#Adding 
$Task.Task.Actions.Exec.Arguments = $Task.task.Actions.Exec.Arguments  + " -Computer $Computer"
$Task.task.Triggers.CalendarTrigger.StartBoundary = [string](Get-Date $Date -Format s)
$Task.Save($File )

Register-ScheduledTask -Xml (Get-Content $File | Out-String) -TaskName "SN Automation SNMP Restart"
while((Get-ScheduledTask -TaskName "SN Automation SNMP Restart").state -eq 'Running'){
Start-Sleep -Seconds 1
}
Unregister-ScheduledTask -TaskName "SN Automation SNMP Restart"
