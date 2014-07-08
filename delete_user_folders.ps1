<#
    .SYNOPSIS 
        This script will find user folders in C:\Users and delete them.  I've added some logic to omit folders that should not be deleted.
        WinRM is used to connect to each box and run a cmd command
        
    .EXAMPLE
     delete_user_folders.ps1
 
#>


$computers = GC C:\users\joerod\Desktop\list.txt

foreach ($computer in $computers){
    
     Invoke-Command -ComputerName $computer {
    $folders = Get-ChildItem C:\Users |select -expand name
      foreach ($folder in $folders){
      if(($folder -notlike "Public") -and ($folder -notlike "administrator") -and ($folder -notlike "Default")){
         Write-Output "removing $folder"
         cmd.exe /c del  "c:\Users\$folder" /f/s/q/a
         cmd.exe /c rmdir  "c:\Users\$folder" /s/q}
    }
  }
}
