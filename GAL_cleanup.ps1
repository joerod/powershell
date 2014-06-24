<#
    .SYNOPSIS 
        This script looks for accounts in AD that are disabled, then checkes Exchange to see if the account is still visable
        in the GAL.  If you'd like to remove the user from the GAL uncomment line 15
     
#>

$disabled = Get-ADUser -Properties * -Filter {Enabled -eq $false}
  foreach($user in $disabled){
  try{
  if((get-Mailbox $($user.SamAccountName) -ErrorAction Stop | select -expand HiddenFromAddressListsEnabled) -eq $false){


  Write-Output $user.DisplayName
  
  
  #Set-Mailbox $user.SamAccountName -HiddenFromAddressListsEnabled $true
    }
  }

 catch {
 Write-Warning "There is no mailbox for $($user.DisplayName)"

 }

}
