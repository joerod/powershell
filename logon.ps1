(Get-date -UFormat "%a %m/%d/%Y,%H:%M:%S"),$env:COMPUTERNAME,$env:USERNAME,$env:SESSIONNAME,$env:logonserver -join "," | Out-File "\\Path\to\Share\Logon.log"
