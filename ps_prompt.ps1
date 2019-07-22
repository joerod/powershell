Install-Module -Name posh-git -Scope CurrentUser

 function prompt {
    $prompt = Write-Prompt ("PS {0}.{1} | " -f $PSVersionTable.PSVersion.Major,$PSVersionTable.PSVersion.Minor)
    $prompt += Write-Prompt "$([math]::round((((Get-History)[-1].EndExecutionTime - (Get-History)[-1].StartExecutionTime).TotalSeconds),3)) | "
    $prompt += & $GitPromptScriptBlock 
    if ($prompt) {$prompt} else {" "}
}
