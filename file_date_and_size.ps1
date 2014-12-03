<#this script will get a list of files in a folder and its subfolders.  It will then look for files larger then 0kb and
older then 10 minutes.
#>


$age = 10
$array = @()
$filter = 0
$folder = 'C:\Stuff'

foreach($file in (Get-ChildItem $folder -Recurse | ? { ! $_.PSIsContainer })){
if((Get-Item $file.FullName).length -gt 0kb){
  $elapsedtime =  New-TimeSpan -Start $file.LastWriteTime -End (get-date)
    if([System.Math]::Round($elapsedtime.TotalMinutes,0) -ge $age ){
      $fileage = [System.Math]::Round($elapsedtime.TotalMinutes,0)
      $shortname = ($file.FullName).replace("$folder","")
      $array += "$shortname, Age: $fileage Min |"
      $filter = 1
    }        
   }   
}
    if($filter -eq 1){
    Write-Output "Statistic: 3"
    Write-Output "Message: Unprocessed file: $array"
    }
    else {
            Write-Output "Statistic: 0"
            Write-Output "Message: OK - No unprocessed files found"
          }
