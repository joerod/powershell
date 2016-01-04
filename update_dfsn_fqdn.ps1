foreach ($dfsn in (Get-DfsnFolder -Path '\\contoso.corp\Network\*' | Get-DfsnFolderTarget | ? { $_.targetpath -notlike "*contoso.corp*" -and $_.targetpath -notlike "*10.*" -and $_.state -like "online" } | select Path, TargetPath)){
    #Formats and adds the FQDN to DFSN Path
    $new_targetpath = $dfsn.targetpath.Replace(([regex]::match("$($dfsn.targetpath)", '[^\\]+’).value), (([regex]::match("$($dfsn.targetpath)", '[^\\]+’).value) + (".contoso.corp")))
    New-DfsnFolderTarget -Path $dfsn.path -TargetPath $new_targetpath -Confirm:$false 
    #Removes old dfs share
    Remove-DfsnFolderTarget -Path $dfsn.path -TargetPath $dfsn.targetpath -Confirm:$false
}
