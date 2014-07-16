#set this to the location of the gam binaries
Set-Alias gam C:\gam\gam.exe

#Imports data from csv, mandatory column 1 (email) address

foreach($i in (Import-Csv C:\scripts\users.csv){

$suspended = gam info user $($i.email) | Select-String -pattern "Account Suspended: false"

if ($suspended -eq $null) {
  $($i.email) | Out-File -FilePath C:\scripts\not_suspended.txt -append -Encoding utf8
  }
    }
