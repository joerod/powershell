if($PSVersionTable.PSEdition -eq "Core"){
  Install-Module WindowsCompatibility -Scope CurrentUser
  Import-WinModule Microsoft.PowerShell.Management
}

Install-Module -Name posh-git -Scope CurrentUser

 function prompt {
    $userinfo = (($env:USERNAME).tolower() + "@" + ($env:COMPUTERNAME).tolower())
    $date = Get-Date -Format u
    $prompt = Write-Prompt ("PS {0}.{1}" -f $PSVersionTable.PSVersion.Major,$PSVersionTable.PSVersion.Minor)
    $prompt += Write-Prompt " $userinfo | " -ForegroundColor Green
    $prompt += & $GitPromptScriptBlock 
    $prompt += Write-Prompt " | $date "-ForegroundColor Magenta
    if ($prompt) {$prompt} else {" "}
}
