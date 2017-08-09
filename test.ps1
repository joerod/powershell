$urls = @{
    "http://64.52.85.212/nextcloud/index.php/s/NOpoQiFrr9RPh4M/download?path=%2FStandard%20Snake%2F12%20Team%2F0.5%20PPR%2F1%20QB&files=2017-08-04%2012%20TM%200.5%20PPR%201QB%202RB%203WR%201TE%201FLX%206%20PaTD%20Snake.","C:\Users\joerod\Dropbox\Fantasy\2017\CBS\2017-08-04 12 TM 0.5 PPR 1QB 2RB 2WR 1TE 1FLX 4 PaTD Snake."
    "http://64.52.85.212/nextcloud/index.php/s/NOpoQiFrr9RPh4M/download?path=%2FStandard%20Snake%2F12%20Team%2F0%20PPR%2F1%20QB&files=2017-08-04%2012%20TM%200%20PPR%201QB%202RB%203WR%201TE%201FLX%204%20PaTD%20Snake." =,"C:\Users\joerod\Dropbox\Fantasy\2017\ESPN\2017-08-04 12 TM 0 PPR 1QB 2RB 2WR 1TE 1FLX 4 PaTD Snake"
}

Write-Output pdf,xlsx | ForEach-Object {Invoke-WebRequest -Uri ($url + $_) -OutFile ( + $_)}

    $api = "o.kHVT1FpJBxTmasHW8U4BN1HyPVRPnBVP"
    $PushURL = "https://api.pushbullet.com/v2/pushes"
    $devices = "https://api.pushbullet.com/v2/devices"