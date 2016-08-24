$Computer = $env:COMPUTERNAME
$File = 'C:\Users\joerod\Desktop\Delete Driveway Camera Videos.xml'
[xml]$Task = Get-Content $File
#Adding 15 seconds to give time for the script to complete and the task to execute
[string]$Date =  (Get-Date).AddSeconds(15).ToString("MM/dd/yyyy hh:mm:ss")
#Adding 
$Task.Task.Actions.Exec.Arguments = $Task.task.Actions.Exec.Arguments  + " -Computer $Computer"
$Task.task.Triggers.CalendarTrigger.StartBoundary = [string](Get-Date $Date -Format s)
$Task.Save($File )

#https://www.petri.com/import-scheduled-tasks-powershell
