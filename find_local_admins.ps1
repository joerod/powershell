#this script will find all machines in an OU then show who is all users in the local administrators group.

Function Get-Complist{
Get-ADObject -Filter { ObjectClass -eq "computer" } -SearchBase "OU=Workstations,DC=Contoso,DC=LOCAL"|
  Select-Object -expandproperty Name |Sort
}


Function find_local_admin{
foreach($i in Get-Complist){
    #test if machine is on the network
    if (!(Test-Connection -computername $i -count 1 -Quiet -ErrorAction SilentlyContinue)) {
        Write-Warning "$i is Unavailable (Not Pingable)`r"
        Continue
    }
    try{
    invoke-command {
      
        $members = net localgroup administrators |?{$_ -AND $_ -notmatch "command completed successfully"} | select -skip 4
        $Results = @()
        ForEach($member in $members){
             New-Object PSObject -Property @{
                Computername = $env:COMPUTERNAME
                Users=$member
            }
        }
    } -computer $i -HideComputerName  | Select * -ExcludeProperty RunspaceID
   }
   catch{
   Write-Warning "$i - Cannot WinRM"
  }
 } 
}
find_local_admin  | select * -ExcludeProperty PSComputerName,PSShowComputerName  |Export-Csv C:\Users\joerod\Desktop\admins.csv -NoTypeInformation -Append
