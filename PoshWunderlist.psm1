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
    foreach($list in (Get-Wunderlist)){
        if ($list.title -like "*$Title*"){
        $list
        }  
    }
}
#Find-Wunderlist -Title Groceries

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

#Make-Wunderlist -Title "Groceries"

Function Remove-Wunderlist{
    Param (
        [int[]] $ListD,
        [string] $Revision
    )

    Invoke-RestMethod -Uri ("https://a.wunderlist.com/api/v1/lists/$ListID" + "?revision=$Revision") -Method Delete -Headers $headers

}

#get all tasks in list
Function Get-AllWunderlistTask{
    Param (
        [int] $TaskID,
        [string] $ShowCompleted = $false
    )

    Invoke-RestMethod -Uri "https://a.wunderlist.com/api/v1/tasks?list_id=$TaskID&completed=$ShowCompleted" -Method Get -Headers $headers -ContentType 'application/json'

}
#Get-WunderlistTask -ListID 288253803
#Get-WunderlistTask -ListID (Find-Wunderlist -Title Groceries).id

#Create a task
Function Add-WunderlistTask{

    Param (
        [int] $TaskID,
        [String] $TaskName
    )

    $body = @{
        list_id = $TaskID
        title = $TaskName
    }
 
    Invoke-RestMethod -Uri "https://a.wunderlist.com/api/v1/tasks" -Method Post -Headers $headers -Body (ConvertTo-Json $body) -ContentType 'application/json'
}

#Add-WunderlistTask -ListID 251331943 -TaskName "Function test"


#Updates a task
Function Update-WunderlistTask {
    Param (
        [Parameter(Mandatory = $true)]$TaskID, 
        [Parameter(Mandatory = $true)][int] $Revision,
        [int]$ListID,
        [string]$Title,
        [int]$AssigneeID,
        [bool]$Completed,
        [string]$RecurrenceType,
        [int]$RecurrenceCount,
        [string]$DueDate,
        [bool]$Starred,
        [array]$Remove
    )
    #creats JSON body. Only adds parameters that are used.
    $body = @{}
    $body.add("revision",$Revision)
    if($ListID){$body.add("list_id",$ListID)}
    if($Title){$body.add("title",$Title)}
    if($AssigneeID){$body.add("assignee_id",$AssigneeID)}
    if($Completed){$body.add("completed",$Completed)}
    if($RecurrenceType){$body.add("recurrence_type",$RecurrenceType)}
    if($RecurrenceCount){$body.add("recurrence_count",$RecurrenceCount)}
    if($DueDate){$body.add("due_date",$DueDate)}
    if($Starred){$body.add("starred",$Starred)}
    if($Remove){$body.add("remove",$Remove)}

    Invoke-RestMethod -Uri "a.wunderlist.com/api/v1/tasks/$TaskID" -Method Patch -Headers $headers -Body (ConvertTo-Json $body) -ContentType 'application/json'
}

#Update-WunderlistTask -TaskID 2485757789 -Completed:$true -Revision 3
