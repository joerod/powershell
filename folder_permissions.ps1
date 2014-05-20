#This script will find a specified folder on a remote machine and give modify rights to "Authenticated Users"

Invoke-Command -ComputerName machine {
function find-path{
$folderName = "Outlook"
Get-ChildItem -Recurse -Force "C:\Program Files (x86)" -ErrorAction SilentlyContinue | 
 Where-Object { ($_.PSIsContainer -eq $true) -and  ( $_.Name -like "*$folderName*") } |
 Select-Object -expand FullName
 }


    foreach($folder in find-path){
    $acl = Get-Acl $folder
    $myGroup = "NT AUTHORITY\Authenticated Users" 
    $rule = New-Object System.Security.AccessControl.FileSystemAccessRule("$myGroup", "Write", "ContainerInherit, ObjectInherit", "None", "Allow")
    $acl.AddAccessRule($rule)
    $rule = New-Object System.Security.AccessControl.FileSystemAccessRule("$myGroup", "Read", "ContainerInherit, ObjectInherit", "None", "Allow")
    $acl.AddAccessRule($rule)
    $rule = New-Object System.Security.AccessControl.FileSystemAccessRule("$myGroup", "ReadAndExecute", "ContainerInherit, ObjectInherit", "None", "Allow")
    $acl.AddAccessRule($rule)
    $rule = New-Object System.Security.AccessControl.FileSystemAccessRule("$myGroup", "ListDirectory", "ContainerInherit, ObjectInherit", "None", "Allow")
    $acl.AddAccessRule($rule)
    $rule = New-Object System.Security.AccessControl.FileSystemAccessRule("$myGroup", "Modify", "ContainerInherit, ObjectInherit", "None", "Allow")
    $acl.AddAccessRule($rule)
    Set-Acl $folder $acl
      } 

}
