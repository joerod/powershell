#Gets Records
$zone = 'take2.t2.corp'
$Server = 'tk2nycdmc1'
#Create empty arrays
$Aarray = New-Object system.collections.arraylist
$CNAMEarray = New-Object system.collections.arraylist

foreach ($recordtype in ("A", "CNAME")){
    Switch ($recordtype){
 
        "A"{

            $record = "A"
            $array = $Aarray
        }

        "CNAME"{

            $record = "CNAME"
            $array = $CNAMEarray

        }

    }
    
    foreach ($findrecord in (Get-DnsServerResourceRecord -ComputerName $Server -ZoneName $zone -RRType $record)){
        if ($record -eq "A"){
            if ($findrecord.HostName -notmatch '[a-z]-' -and $findrecord.HostName -notlike "DomainDnsZones" -and $findrecord.HostName -notlike "@"){
                Write-Verbose "Running Ping test on $findrecord.HostName"
                if (!(Test-Connection $findrecord.HostName -count 1)){
                    $array.Add($findrecord.HostName) | Out-Null
                }

        
            }
            else {
                foreach ($Cname in $findrecord){
                    #Formats host names
                    $Cname = ($Cname.RecordData.HostNameAlias).Substring(0, ($Cname.RecordData.HostNameAlias.IndexOf('.')))  
                    Write-Verbose "Checking if there is an A record for $Cname"
                    if (!(Get-DnsServerResourceRecord -ComputerName $Server -ZoneName $Zone -RRType 'A'| ? { $_.HostName -like "$cname" })){
                        $array.Add($Cname) | Out-Null
                    }
                }
            }

        }
    }


}
