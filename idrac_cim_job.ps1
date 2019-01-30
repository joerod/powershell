# reboot_type:
#    - 1 = PowerCycle, 2 = Graceful Reboot without forced shutdown, 3 = Graceful reboot with forced shutdown

$properties = @{SystemCreationClassName="DCIM_ComputerSystem"
                CreationClassName="DCIM_JobService"
                SystemName="IDRAC:ID"
                Name="SoftwareUpdate"
              }
$instance = New-CimInstance -ClassName DCIM_SoftwareInstallationService -Namespace root/dcim -ClientOnly -Key @($properties.keys) -Property $properties
    
$Parameters = @{
    RebootJobType = 2
}

Invoke-CimMethod -InputObject $instance -MethodName CreateRebootJob -CimSession $iDRACSession -Arguments $Parameters
