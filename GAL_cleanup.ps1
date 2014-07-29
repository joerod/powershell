<#
    .SYNOPSIS 
        This script looks for accounts in AD that are disabled, then checkes Exchange to see if the account is still visable
        in the GAL.  

     .SYNTAX
        Gal_cleanup.ps1 [-Remove] 

     .EXAMPLE
         -------------------------- EXAMPLE 1 --------------------------
        PS C:\>create_admin_account.ps1 

        This will show all accounts that are disabled in AD but still visable in the GAL.

         -------------------------- EXAMPLE 2 --------------------------
        PS C:\>create_admin_account.ps1 -remove

        This will remove all accounts that are disabled in AD but still visable in the GAL.

  
     
#>
[CmdletBinding()]
param([switch] $Remove)

function GAL_Cleanup{

  foreach($user in (Get-ADUser -Properties * -Filter {Enabled -eq $false})){
  try{
  if((get-Mailbox $($user.SamAccountName) -ErrorAction Stop | select -expand HiddenFromAddressListsEnabled) -eq $false){

  
New-Object -TypeName PSCustomObject -Property @{
    SAMAccoutName = $user.samaccountname
    Name = $user.name
   
     } 
  
  if($remove){
  Set-Mailbox $user.SamAccountName -HiddenFromAddressListsEnabled $true
  Write-Output "$($user.SamAccountName) has been removed from the GAL"
  }
    }
  }

 catch {
 Write-Verbose "There is no mailbox for $($user.DisplayName)" 

 }

 }
}

GAL_Cleanup
