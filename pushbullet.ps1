<#
.SYNOPSIS
 This script sends push notifications via the PushBullet API

.DESCRIPTION
This function can be used to send push notifications.  This script will likely grow to do more functions via the Pushbullet API. 
You must have a Pushbullet API key in order for this function to work.  The link to create an access token is the following
https://www.pushbullet.com/#settings/account

.PARAMETER APIKey
This parameter is required and is needed in order to connect to the Pushbullet API.  

.PARAMETER Message
The message you wish to send to the PushBullet device

.PARAMETER Url
PushBullet API URL.  This parameter is set to https://api.pushbullet.com/v2/pushes

.EXAMPLE
 Send-PushBulletMessage -APIKey "*****" -Message "Str8 from PowerShell" 

.NOTES
General notes
#>

Function Send-PushBulletMessage {
param(
    [Parameter(Mandatory=$true)]$APIKey,
    [Parameter(Mandatory=$true)]$Message,
    [Parameter(Mandatory=$false)]$Url = "https://api.pushbullet.com/v2/pushes"
)

    $cred = New-Object System.Management.Automation.PSCredential ($api,(ConvertTo-SecureString $api -AsPlainText -Force))

    $body = @{
                type = "note"
                title = $Message
                }

    $result = Invoke-WebRequest -Uri $PushURL -Credential $cred -Method Post -Body $body -ErrorAction SilentlyContinue           
    if($result.StatusCode -eq '200'){
        Write-Output "Message Sucessfully Sent"
    }

 }   