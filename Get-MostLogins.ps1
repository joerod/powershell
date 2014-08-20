function Get-MostLogins {
<#
    .SYNOPSIS 
        Finds all domain machines a user has logged into by using the users 'real' name
    
    .DESCRIPTION
        This script uses my user login script log and finds 
        what machine the user logs into most.  In my environment users log into several machines, this makes finding their primary
        machine much easier.  I will use this script in subsequent scripts to auto find the users primary machine and preform an 
        action.

        I've added the ablity to choose either a file that contains a list of users to find most logins or one user
        I've also added a fix for users with apostrophe's in their name

    .PARAMETER Name
        Searches a single user by their 'real' name
     
    .PARAMETER File
        Takes a text file with a list of users 'real' names and queries them with this script.  You must specify full path to file
    
    .PARAMETER Full
        Lists all the machines a user has logged into
    
    .EXAMPLE
        Get-MostLogins -Name "Joe Rodriguez"
        This command will show what machine Joe Rodriguez logged into the most

    .EXAMPLE
         Get-MostLogins -File c:\users\joerod\desktop\users.txt
         This command will show what machine all the users in the text file users.txt logged into the most
    
    .EXAMPLE
        Get-MostLogins -Name "Joe Rodriguez" -Full
        This command will show all machines Joe Rodriguez logged into

  #>


[CmdletBinding(DefaultParameterSetName="Name")]
param(
    [Parameter(Position=0, ParameterSetName="File")]
    [string]
    $File,

    [Parameter(Position=0, ParameterSetName="Name")]
    [string]
    $Name,

    [switch]$Full
    )

if ($psCmdlet.ParameterSetName -eq "File") {
foreach($name in gc $file){
  #if name has an apostrophe
  if($name.Contains("'")){
      $name = ($name.replace("'","''"))
   }

try{
   
    foreach($user in (Get-ADUser -Properties * -Filter "Name -like '$Name*'" -ErrorAction Stop | ? {$_.Enabled -contains "True"})){
    $array = Import-Csv \\Path\to\Share\Logon.log | ? {$_.username -eq $user.samaccountname} | % {

    New-Object -TypeName PSCustomObject -Property @{
        Name = $user.name
        SAMAccoutName = $user.samaccountname
        ComputerName = $_.computername     
         } 
        }
             if($full){
             $array
             }

             else{
            $array | sort | group ComputerName | sort Count | select -ExpandProperty Group | select -last 1
                 }
               }
            }

catch{
Write-Warning "Cannot find $name"

  }
 }
}

else {

  #if name has an apostrophe
  if($name.Contains("'")){
      $name = ($name.replace("'","''"))
   }

try{
  
    foreach($user in (Get-ADUser -Properties * -Filter "Name -like '$Name*'"  | ? {$_.Enabled -contains "True"})){
    $array = Import-Csv \\Path\to\Share\Logon.log | ? {$_.username -eq $user.samaccountname} | % {

    New-Object -TypeName PSCustomObject -Property @{
        Name = $user.name
        SAMAccoutName = $user.samaccountname
        ComputerName = $_.computername 
         } 
        }
             if($full){
             $array
             }

             else{
            $array | sort | group ComputerName | sort Count | select -ExpandProperty Group | select -last 1
                  }
              }
            }
catch{
Write-Warning "Cannot find $name"

    }
  }
 }
