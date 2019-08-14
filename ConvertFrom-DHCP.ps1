<#
.SYNOPSIS  
    Converts a windoes DHCP address to static
.DESCRIPTION  
    Using only PowerShell convert a number to CIDR notation
.EXAMPLE  
    Get-NetIPConfiguration -InterfaceAlias 'vEthernet (external)' | ConvertFrom-DHCP 
.PARAMETER InterfaceAlias  
   The alias of the interface that is to be set to static.
#>

Function ConvertFrom-DHCP { 
  [CmdletBinding(SupportsShouldProcess, ConfirmImpact='Medium')]

  param(
    [parameter(ValueFromPipelineByPropertyName)]
    [string]$InterfaceAlias
  )
  $interface = Get-NetIPConfiguration -InterfaceAlias $InterfaceAlias
  #Get ipv4 address
  $ipaddress = $interface.ipv4address.ipv4address
  #get default gateway
  $ipgateway = $interface.ipv4defaultgateway.nexthop
  #Getting the subnet mask
  $mask = ((Get-NetIPAddress -InterfaceAlias $interface.InterfaceAlias).where{$_.AddressFamily -eq 'IPv4'}).PrefixLength
  $cidr = (0..3|%{(,0*($_*8+1)+('Ààðøüþÿ'|% t*y|%{+$_})+,255*(24-$_*8))[$mask]})-join'.'
  #Output
  $new_ip_splat = @{
    interfacealias = $interfacealias
    ipaddress      = $ipaddress
    prefixlength   = $cidr
    defaultgateway = $ipgateway
  }

  if ($PSCmdlet.ShouldProcess(($new_ip_splat.GetEnumerator() | ForEach-Object {"{0}`t{1}" -f $_.Name,($_.Value -join ", ")}))) {
    Remove-NetIPAddress -InterfaceAlias $new_ip_splat.interfacealias -AddressFamily ipv4
    New-NetIPAddress @new_ip_splat
  }
  else{
    exit
  }
}
