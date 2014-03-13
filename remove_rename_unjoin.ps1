<#This script will remove some software, in this case SEP, change the local admin account name from "root" to "administrator", 
change the local administrators password, and finally unjoin the machine from the domain.
#>

$cred = Get-Credential

foreach($computer in (get-content c:\list.txt)){

#test if computer is alive (pingable)
if (-not (Test-Connection -computername $computer -count 1 -Quiet -ErrorAction SilentlyContinue)) {  
       Write-Warning "$computer is Unavalible" 
       $computer | Out-File C:\Users\joerod\Desktop\bad_desktop.log -Append
        }

         else {
      Write-Output "Added $computer to working list...." 
      $computer |Out-File C:\Users\joerod\Desktop\good_desktop.log -Append

    #removes SEP
    Write-Output "Starting SEP removal..."
    $myses = New-PSSession -ComputerName $computer 
    Invoke-Command -Session $myses -ScriptBlock {

    $find_sep = gwmi win32_product -filter "Name LIKE '%Endpoint Protection%'" | select -ExpandProperty IdentifyingNumber
    foreach($i in $find_sep){
    msiexec.exe /x $i /qn /passive /l*v! c:\uninst.log 
     } 
    } -ErrorVariable $removeapp_error

    #wait 2.5 minute for SEP to uninstall
    Write-Output "Waiting for SEP to uninstall"
    Start-Sleep -s 150 

        Invoke-Command -ComputerName $computer -Verbose -ScriptBlock {
    
        #rename local admin account to Administrator
        Write-Output "Renaming Local Admin Account..."
        $newname = "Administrator"
        $user = Get-WMIObject Win32_UserAccount -Filter "Name='Root'"
        $user.Rename($newName) |Out-Null

        #resets local admin password
        Write-Output "Changing Local Password..."
        $newpassword = "ChangeMe!"
        $user = [ADSI]"WinNT://./$newName"
        $user.SetPassword("$newpassword")

   
 } -ErrorVariable $tasks_error


   $session = $computer |New-PSSession -Credential $cred
   Invoke-Command -Session $session -Verbose -ScriptBlock { param($cred) 
        Write-Output "Unjoining from Domain..."
        Remove-Computer -UnjoinDomainCredential $cred -Passthru -force -Restart
        } -ArgumentList $cred -ErrorVariable $tasks_error

 }
}

$removeapp_error | Out-File C:\Users\joerod\Desktop\desktop.log -Append
$tasks_error | Out-File C:\Users\joerod\Desktop\desktop.log -Append
