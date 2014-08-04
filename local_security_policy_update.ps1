<#   .SYNOPSIS 
        This script will remote into a machine and update the Local Security Policy, it will then change the permissions on
        a specified folder.  The csv must have 2 coloumns one with SAMaccountName and the other with the users machines name.
        
#>        

foreach($user in (Import-Csv C:\users\joeord\Desktop\user_machines.csv)){


$sid = (get-aduser $user.user -Properties sid).sid.value



Invoke-Command $user.machine -ArgumentList $sid $user{
param($sid,
$user
)

#sets local policy settings

secedit /export /cfg c:\file1.inf


 Get-Content C:\file1.inf | 
% {$_ -replace "SeCreateGlobalPrivilege.*", "SeCreateGlobalPrivilege = *S-1-5-19,*S-1-5-20,*$($sid),*S-1-5-32-544,*S-1-5-6"} | 
Set-Content C:\file2.inf


secedit /import /cfg C:\file2.inf /db C:\file2.sdb
secedit /configure /db C:\file2.sdb
Remove-Item C:\file2.sdb
Remove-Item C:\file1.inf
Remove-Item C:\file2.inf

#looks for and sets folder permissions for folder you would like

function find-path{
$fileName = "FolderName"
Get-ChildItem  -Force "c:\" -ErrorAction SilentlyContinue | 
 ? { ($_.PSIsContainer -eq $true) -and  ( $_.Name -like "*$fileName*") } |
 Select-Object -expand FullName
 }

     foreach($folder in find-path){
    Write-Output "Setting permissions on $env:COMPUTERNAME for FolderName on $folder"
    $acl = Get-Acl $folder
    $myGroup = "CORPORATE\$($user.user)" 
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

}
