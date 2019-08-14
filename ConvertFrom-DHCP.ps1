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
  $dns = (Get-DnsClientServerAddress -InterfaceAlias $InterfaceAlias -AddressFamily IPv4).ServerAddresses
  #Output
  $new_ip_splat = @{
    interfacealias = $interfacealias
    ipaddress      = $interface.ipv4address.ipv4address
    defaultgateway = $interface.ipv4defaultgateway.nexthop
    PrefixLength   = $((Get-NetIPAddress -InterfaceAlias $interface.InterfaceAlias -AddressFamily IPv4).PrefixLength)
  }

  if ($PSCmdlet.ShouldProcess(($new_ip_splat.GetEnumerator() | ForEach-Object {"{0}`t{1}" -f $_.Name,($_.Value -join ", ")}))) {
    Remove-NetIPAddress -InterfaceAlias $interfacealias -AddressFamily ipv4
    New-NetIPAddress @new_ip_splat
    Set-DnsClientServerAddress -InterfaceAlias $interfacealias -ServerAddresses $dns
  }
  else{
    exit
  }
  
}
