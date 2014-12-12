param(
    [CmdletBinding()] 
    [Parameter(ValueFromPipeline=$true,
               ValueFromPipelineByPropertyName=$true)]
    [string[]]$ComputerName = 'localhost'
)

process {
    foreach ($Computer in $ComputerName) {
        quser /server:$Computer | Select-Object -Skip 1 | % {
            $CurrentLine = $_.Trim() -Replace '\s+',' ' -Split '\s'
            $HashProps = @{
                UserName = $CurrentLine[0]
                ComputerName = $Computer
            }

            # If session is disconnected different fields will be selected
            if ($CurrentLine[2] -eq 'Disc') {
                    $HashProps.SessionName = $null
                    $HashProps.Id = $CurrentLine[1]
                    $HashProps.State = $CurrentLine[2]
                    $HashProps.IdleTime = $CurrentLine[3]
                    $HashProps.LogonTime = $CurrentLine[4..6] -join ' '
            } else {
                    $HashProps.SessionName = $CurrentLine[1]
                    $HashProps.Id = $CurrentLine[2]
                    $HashProps.State = $CurrentLine[3]
                    $HashProps.IdleTime = $CurrentLine[4]
                    $HashProps.LogonTime = $CurrentLine[5..7] -join ' '
            }

            New-Object -TypeName PSCustomObject -Property $HashProps |
            Select-Object -Property UserName,ComputerName,SessionName,Id,State,IdleTime,LogonTime
        }
    }




$session  = Read-host 'Would you like to log off a session?  Enter No or enter Session ID '
 if($session -eq 'No'){
 Write-output "Goodbye"
 }

 else{
 LOGOFF $session /server:$ComputerName
  }
 }
