#You must specify an Access Token and Client ID for this script to work.  Get this here https://developer.wunderlist.com/apps/new
Function  Get-WunderlistCredential {
    Param (
        [string] $AccessToken,
        [string] $ClientID
    )

    $auth = @{}
    $auth.Add("X-Access-Token", "$AccessToken")
    $auth.Add("X-Client-ID", "$ClientID")
    return $auth
}

$headers = Get-WunderlistCredential -AccessToken xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx -ClientID xxxxxxxxxxxxxxxxxxxx


#get list of all lists
Function Get-Wunderlist{
    Invoke-RestMethod -Uri "https://a.wunderlist.com/api/v1/lists" -Method Get -Headers $headers -ContentType 'application/json'
}

#Get-Wunderlist

#Finds a Wunderlist with a title like $Title, min 3 characters max 30

Function Find-Wunderlist{
    Param (
        [ValidateLength(3, 30)]
        [string] $Title
    )
    Foreach($list in (Get-Wunderlist)){

        if ($list.title -like $Title){
            return $list
            break
        }
    }
}

Find-Wunderlist -Title 'Testing Again1'
#create a list
Function Make-Wunderlist{
    Param (
        [string] $Title
    )

    $body = @{
        "title" = $Title
    }
    Invoke-RestMethod -Uri "https://a.wunderlist.com/api/v1/lists" -Method Post -Headers $headers -Body (ConvertTo-Json $body) -ContentType 'application/json'
}

#Make-Wunderlist -Title "Testing Again1"

#get specific task
Function Get-WunderlistTask{
    Param (
        [string] $ListID,
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

Function Remove-Wunderlist{
    Param (
        [int[]] $ListID,
        [string] $Revision
    )

    Invoke-RestMethod -Uri ("https://a.wunderlist.com/api/v1/lists/$ListID" + "?revision=$Revision") -Method Delete -Headers $headers

}

#Remove-Wunderlist -ListID 279736834 -Revision 1
