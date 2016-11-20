$headers = @{}
$headers.Add("X-Access-Token", "")
$headers.Add("X-Client-ID", "")

#get list of all lists
Function Get-Wunderlist{
    Invoke-RestMethod -Uri "https://a.wunderlist.com/api/v1/lists" -Method Get -Headers $headers
}

Get-Wunderlist

#create a list
Function Make-Wunderlist{
    Param (
        [string]$Title
    )

    $body = @{
        "title" = $Title
    }
    Invoke-RestMethod -Uri "https://a.wunderlist.com/api/v1/lists" -Method Post -Headers $headers -Body (ConvertTo-Json $body) -ContentType 'application/json'
}

#Make-Wunderlist -Title "Testing Again"

#get specific task
Function Get-WunderlistTask{
    Param (
        [int] $ListID,
        [string] $Completed = 'False'
    )

    Invoke-RestMethod -Uri "https://a.wunderlist.com/api/v1/tasks?list_id=$ListID&completed=$Completed" -Method Get -Headers $headers -ContentType 'application/json'

}

#Get-WunderlistTask -ListID '251331943'

#Create a task
Function Add-WunderlistTask{

    Param (
        [int] $ListID,
        [String] $TaskName
    )


    $body = @{
        list_id = $ListID
        title = $TaskName
    }
 
    Invoke-RestMethod -Uri "https://a.wunderlist.com/api/v1/tasks" -Method Post -Headers $headers -Body (ConvertTo-Json $body) -ContentType 'application/json'
}

#Add-WunderlistTask -ListID 251331943 -TaskName "Function test"

Function Remove-Wunderlist {
   Param (
        [int]$ListID,
        [string]$Revision
    )

Invoke-RestMethod -Uri ("https://a.wunderlist.com/api/v1/lists/$ListID" + "?revision=$Revision") -Method Delete -Headers $headers

}

#Remove-Wunderlist -ListID 277820327 -Revision 1
