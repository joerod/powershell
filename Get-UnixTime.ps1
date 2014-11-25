#this script will give you the same output as dir or ls but give unix time instead of standard time.

[CmdletBinding()]
   	Param(
       	[Parameter(Mandatory)]
        [string]$path
      )

Function Get-UnixTime{
 
ls -Path $path  | % {
[PSCustomObject][ordered]@{
    Mode = $_.mode 
    LastWriteTime = [System.Math]::Round((date $_.LastAccessTime -UFormat %s),0)
    Length = $_.Length
    Name = $_.Name
    } 
   } |Format-Table -AutoSize

}

Get-UnixTime
