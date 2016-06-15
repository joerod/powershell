#Joe Rodriguez
#joerod@gmail.com
#version 1.0

Function Get-LocalGroupRights {
 Param (
        [Parameter(Mandatory = $true,Position=0)][string] $ComputerName,
        [Parameter(Position=1)][string] $Group = 'Administrators'
        
    )
$GroupInfo = [ADSI] "WinNT://$ComputerName/$Group,group"
$Members = $GroupInfo.psbase.Invoke("Members")
$Members | %{ $_.GetType().InvokeMember("Name", 'GetProperty', $null, $_, $null) }
}

#Get-LocalGroupRights -ComputerName Computer001

Function Add-LocalGroupRights {
 Param (
        [Parameter(Mandatory = $true,Position=0,ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true)][string] $ComputerName,
        [Parameter(Mandatory = $true,Position=1,ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true)][string] $Name,
        [Parameter(Mandatory = $true, Position = 2)][ValidateSet("User", "Group")] $Type,
        [Parameter(Position = 3)] $Group = 'Administrators'
    )
$GroupInfo = [ADSI] "WinNT://$ComputerName/$Group,group"
$ToAdd = [ADSI] "WinNT://AD.JOEROD.COM/$Name,$Type"
$GroupInfo.Add($ToAdd.Path)
}

#Add-LocalGroupRights -ComputerName Computer001 -Name joerod -Type User

Function Remove-LocalGroupRights {
 Param (
        [Parameter(Mandatory = $true,Position=0,ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true)][string] $ComputerName,
        [Parameter(Mandatory = $true,Position=1,ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true)][string] $Name,
        [Parameter(Mandatory = $true, Position = 2)][ValidateSet("User", "Group")] $Type,
        [Parameter(Position = 3)] $Group = 'Administrators'
    )
$GroupInfo = [ADSI] "WinNT://$ComputerName/$Group,group"
$ToRemove = [ADSI] "WinNT://AD.JOEROD.COM/$Name,$Type"
$GroupInfo.Remove($ToRemove.Path)
}

#Remove-LocalGroupRights -ComputerName Computer001 -Name joerod -Type User
