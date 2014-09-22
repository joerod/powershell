<# 
I wrote this script to install a VCM client on a number of servers.  We do not have winrm enabled on any of our servers so I
used the Invoke-WmiMethod cmdlet to install the application.  

This script will copy the nessicary files to the destination server then install, it will also provide logs for installation and
connection errors.
#>

$DriveLetter = 'c'
$path = 'Software'
$logpath = 'C:\Script_logs'

#creates folder on local machine to save logs to
   if(-not (Test-Path $logpath -PathType Container)){
      New-Item -Path $logpath -type directory -Force |Out-Null
    }

#begin main script
foreach ($computer in (gc C:\Users\joerod\Desktop\hostlist.txt)){
try{
    if(Test-Path \\$Computer\$DriveLetter$\$path -ea Stop){
        Write-Output "Trying to install application on $computer..."
        
    }

    else{
        New-Item -Path \\$Computer\$DriveLetter$\$Path -type directory -Force -ea Stop |Out-Null
    }
    Write-output "Copying files"
    Copy-Item -Path C:\Users\joerod\Desktop\vcmagent\* -Destination \\$Computer\$DriveLetter$\$Path

  $args = "cmd /c c:\software\CMAgentInstall.exe /s INSTALLPATH=%Systemroot%\CMAgent PORT=26542 CERT=C:\Software\VMware_VCM_Enterprise_Certificate_E5BC8577-798A-4721-BB5A-357A45C4378A.pem"
  $result = Invoke-WmiMethod -ComputerName $computer -Class Win32_Process -Name Create -ArgumentList $args
 if ($result.ReturnValue -ne 0)
        {
           $exception = New-Object System.ComponentModel.Win32Exception([int]$result.ReturnValue)
           $msg_failinstall = "Error launching installer on computer ${computer}: $($exception.Message)"
            Write-Warning $msg_install
            $msg_failinstall |Out-File $logpath\application_install_$(get-date -f MM-dd-yyyy).log -Append
           
        }
    else {
            $msg_successinstall = "Application has installed successfully on $computer"
            Write-Output $msg_successinstall
            $msg_successinstall |Out-File $logpath\application_install_$(get-date -f MM-dd-yyyy).log -Append

    }

}
    catch{
    $msg_connect = "Can't connect to $computer"
    Write-Warning $msg_connect
    $msg_connect |Out-File $logpath\connection_install_$(get-date -f MM-dd-yyyy).log -Append
    }
}
