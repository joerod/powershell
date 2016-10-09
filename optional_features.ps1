Param(
[Parameter(Position=0,mandatory=$true)]
[string]$Hostname = $env:COMPUTERNAME
)

 gwmi win32_OptionalFeature -computername $Hostname `
 | Where-Object {$_.installstate -eq 1} | Select-Object Caption |Sort caption
 
