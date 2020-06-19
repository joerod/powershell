Function Remove-ItemByDate {
  <#
.SYNOPSIS
Removes a file or folder older than a specified date

.DESCRIPTION
Takes any strings for the file name or extension.

.PARAMETER Item
The file or folder to be compared to

.PARAMETER Date
The date the the file or folder must be younger than

.EXAMPLE

Remove-ItemByDate -Item D:\JoeRod\joerod\Desktop\movies -Date (Get-Date).AddMonths(-2)
#>
  [CmdletBinding(SupportsShouldProcess=$True)]
  param(
  [string]$Item,
  [datetime]$Date
  )


  if((Get-item $item).psiscontainer) {
    $args.Recurse = $true
  }
  else {
    $args.Recurse = $false
  }


  foreach($item_object in (Get-ChildItem $Item @args)){
    if($item_object.CreationTime -lt $Date){
      If ($PSCmdlet.ShouldProcess("Removing $($item_object.FullName)")) {
        Remove-item $($item_object.FullName) -Force -Confirm:$false @args
        Write-Verbose "Removed $($item_object.FullName)"
      }
    }
  }
}
