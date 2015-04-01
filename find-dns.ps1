<#
    .SYNOPSIS 
      Searches DNS for records based on user input.  The -DeleteRecord switch will remove the record.
    .EXAMPLE
     Find-DNS -Search Test
     This command finds records in DNS named "Test"
     .EXAMPLE
     Find-DNS -Search Test -DeleteRecord
     This command finds records in DNS named "Test" and deletes the record.  If an A recored is selected the PTR record is also removed
     .EXAMPLE
     Find-DNS -Search Test -Server DNSServer01 -Zone contoso.root
     This will search for DNS record Test on a specified DNS server and a specified Zone on that server.  
  #>

function Find-DNS {

param(
    [Parameter(Position=1)]
    [string]
    $Zone = "Contoso.local",

    [Parameter(Position=2)]
    [string]
    $Server = "DNS_Server",

    [Parameter(Position=0, Mandatory=$True)]
    [string]
    $Search,

    [switch]$DeleteRecord
    )

# Script requires Powershell 4 or greater.
$version = (Get-Host).Version.major
if($version -lt 4){
 Write-Output "You need to upgrade your powershell version in order to run this script."
 Write-Output "Your current verion is $version you need verion 4 or higher"  
 exit
}

$arecord = Get-DnsServerResourceRecord -ComputerName $Server -ZoneName $Zone | ? {$_.HostName -like "*$search*"}
$arecord
 if($arecord -eq $null){
   Write-Output "Record for $search cannot be found"
 }
  else{
  $status = 1
  }


if($DeleteRecord -and $status -eq 1){

$arecord[1] | %{
  Remove-DnsServerResourceRecord -ComputerName $Server -ZoneName $Zone -RRType $_.RecordType -Name $_.hostname -RecordData $_.RecordData.ipv4address.IPAddressToString -Force
   } 
   Write-Host "$arecord[1] has been removed" -backgroundcolor Red
  }

}
Find-DNS
