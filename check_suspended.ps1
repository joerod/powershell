#set this to the location of the gam binaries
Set-Alias gam C:\gam\gam.exe

#Imports data from csv, mandatory column 1 (email) address
$user = Import-Csv C:\scripts\users.csv
foreach($i in $user){

$user_info = gam info user $($i.email)
$suspended = $user_info | Select-String -pattern "Account Suspended: false"

if ($suspended -eq $null) {
  $($i.email) | Out-File -FilePath C:\scripts\not_suspended.txt -append -Encoding utf8
  }
    }
