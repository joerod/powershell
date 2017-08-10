<#
.SYNOPSIS
 This script sends push notifications via the PushBullet API

.DESCRIPTION
This function can be used to send push notifications.  This script will likely grow to do more functions via the Pushbullet API. 
You must have a Pushbullet API key in order for this function to work.  The link to create an access token is the following
https://www.pushbullet.com/#settings/account

.PARAMETER APIKey
This parameter is required in order to connect to the Pushbullet API.  

.PARAMETER Message
The message you wish to send to the PushBullet device

.PARAMETER Device
Specifiy which device you'd like to send to by using the device_iden string.  If this isnt specified the push gets sent to all devices.

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
    [Parameter(Mandatory=$false)]$Device,
    [Parameter(Mandatory=$false)]$Url = "https://api.pushbullet.com/v2/pushes"
)
   $Body =  @{
     type = "note"
     title = $Message
     device_iden = $Device
    }
     $result = Invoke-WebRequest -Uri $URL -Method Post -Body $Body -Headers @{"Access-Token" = $APIKey}    
    if($result.StatusCode -eq '200'){
        Write-Output "Message Sucessfully Sent"
    }
 }   

 #Send-PushBulletMessage -APIKey "" -Message "test" -Device ""

Function  Get-PushBulletDevices {
param(
    [Parameter(Mandatory=$true)]$APIKey,
    [Parameter(Mandatory=$false)]$Url = "https://api.pushbullet.com/v2/devices"
)

(Invoke-RestMethod -Uri $URL -Method Get -Headers @{"Access-Token" = $APIKey}).devices  
 }

 #Get-PushBulletDevices -APIKey ""

Function  Get-WhoAmI {
param(
    [Parameter(Mandatory=$true)]$APIKey,
    [Parameter(Mandatory=$false)]$Url = "https://api.pushbullet.com/v2/users/me"
)

Invoke-RestMethod -Uri $URL -Method Get -Headers @{"Access-Token" = $APIKey}
  }

#Get-WhoAmI -APIKey ""

