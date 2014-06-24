<#
    .SYNOPSIS 
        This script uses my user login script log and finds 
        what machine the user logs into most.  In my environment users log into several machines, this makes finding their primary
        machine much easier.  I will use this script in subsequent scripts to auto find the users primary machine and preform an 
        action.

        I've added the ablity to choose either a file that contains a list of users to find most logins or one user
        I've also added a fix for users with apostrophes in their name

    .EXAMPLE
     most_logins.ps1 -Name "Joe Rodriguez"
     This command will show what machine the single user Joe Rodriguez logged into the most

    .EXAMPLE
     most_logins.ps1 -File c:\users\joerod\desktop\users.txt
     This command will show what machine all the users in the text file users.txt logged into the most.  Add one name per
     line of text eg.
     
     john doe
     jane doe
     steve smith

  #>

[CmdletBinding(DefaultParameterSetName="Name")]
param(
    [Parameter(Position=0, ParameterSetName="File")]
    [string]
    $File,

    [Parameter(Position=0, ParameterSetName="Name")]
    [string]
    $Name
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

$array | sort | group ComputerName | sort Count | select -ExpandProperty Group | select -last 1

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
    foreach($user in (Get-ADUser -Properties * -Filter "Name -like '$Name*'" -ErrorAction Stop | ? {$_.Enabled -contains "True"})){
    $array = Import-Csv \\Path\to\Share\Logon.log | ? {$_.username -eq $user.samaccountname} | % {

    New-Object -TypeName PSCustomObject -Property @{
        Name = $user.name
        SAMAccoutName = $user.samaccountname
        ComputerName = $_.computername 
         } 
        }

$array | sort | group ComputerName | sort Count | select -ExpandProperty Group | select -last 1
  }
}
catch{
Write-Warning "Cannot find $name"
   }
 }
