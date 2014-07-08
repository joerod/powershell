$computers = GC C:\users\joerod\Desktop\list.txt

foreach ($computer in $computers){
    
     Invoke-Command -ComputerName $computer {
    $folders = Get-ChildItem C:\Users |select -expand name
      foreach ($folder in $folders){
      if(($folder -notlike "winroot") -and ($folder -notlike "administrator")){
         Write-Output "removing $folder"
         cmd.exe /c del  "c:\Users\$folder" /f/s/q/a
         cmd.exe /c rmdir  "c:\Users\$folder" /s/q}
    }
  }
}
