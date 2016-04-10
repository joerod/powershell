<#I wrote this script with the intent of using it with my Raspberry Pi magic mirror
this will get the travel details for me and my wife every morning. My wife drives to work
so I'm using google maps API for driving.  I take the subway so I'm using maps for transit. 
Just thinking it would be pretty cool to have this script running on Win10 core on the Pi for my magic mirror. 
#>

$key = ""
#Use Lat/Long coordinates here
$home_addy = ""
$dani_work = ""
$joe_work = ""
$momdad_addy = ""

###Danielle Driving to work Directions###
###Gets EPOC time for departure###
$DateTime = Get-Date -Hour 21 -Minute 30 -Second 00 -Millisecond 00
$Epoc = ([DateTimeOffset] $DateTime).ToUnixTimeSeconds()

$result = Invoke-RestMethod -Uri "https://maps.googleapis.com/maps/api/directions/json?origin=$home_addy&destination=$dani_work&departure_time=$Epoc&key=$key" -Method Get
$result.routes.legs.steps.html_instructions
##########################################

###Joe Subway directions###
###Gets EPOC time for departure###
$DateTime = Get-Date -Hour 20 -Minute 30 -Second 00 -Millisecond 00
$Epoc = ([DateTimeOffset] $DateTime).ToUnixTimeSeconds()

$result = (Invoke-RestMethod -Uri "https://maps.googleapis.com/maps/api/directions/json?origin=$momdad_addy&destination=$joe_work&departure_time=$Epoc&mode=transit&key=$key" -Method Get).routes.legs.steps
#lets me know what is the last train on my route so my print is "leave" or "transfer"
$stops = ($result | ? { $_.travel_mode -eq "TRANSIT" })[-1].end_location
$result | % { if ($_.travel_mode -eq "TRANSIT"){
        Write-Host "Subway" -ForegroundColor Yellow
        Write-Output ("Enter at station: {0}" -f $_.transit_details.departure_stop.name)
        $_.html_instructions
        Write-Output ("Number of stops: {0}" -f $_.transit_details.num_stops)
        if ($stops -ne $_.end_location){
            $status = "Transfer"
        }
        else {
            $status = "Leave"
        }
        Write-Output ("$status at station: {0}" -f $_.transit_details.arrival_stop.name)
    }
    

    else {
        Write-Host "Walking" -ForegroundColor Yellow
        $_.steps.html_instructions
    }
}


