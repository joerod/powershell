if($PSVersionTable.PSEdition -eq "Core"){
  Install-Module WindowsCompatibility -Scope CurrentUser
  Import-WinModule Microsoft.PowerShell.Management
}

Import-Module -Name posh-git -Scope CurrentUser

#sets custom shell 
 function prompt {
    $userinfo = (($env:USERNAME).tolower() + "@" + ($env:COMPUTERNAME).tolower())
    $date = Get-Date -Format u
    $prompt = "PS " 
    $prompt += Write-Prompt " $userinfo | " -ForegroundColor Green
    $prompt += & $GitPromptScriptBlock 
    $prompt += Write-Prompt " | $date "-ForegroundColor Magenta
    if ($prompt) {$prompt} else {" "}
}
