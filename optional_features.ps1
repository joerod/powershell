write-host -foregroundcolor yellow "This will find the ""Optional Features"" running on a remote host"
$hN = Read-Host 'Enter host name'
 gwmi win32_OptionalFeature -credential -computername $hn `
 | Select-Object -Property caption, installstate | Where-Object {$_.installstate -eq 1} | sort-object caption
 
