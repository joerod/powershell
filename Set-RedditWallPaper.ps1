Function Set-RedditWallPaper {
    Param
    (
        [parameter(Mandatory=$true,
        ValueFromPipeline=$true)]
        [String[]]
        $Subreddit,
        [parameter(ValueFromPipeline=$true)]
        [String]
        $ImageLocation = [environment]::getfolderpath("mypictures"),
        [parameter(ValueFromPipeline=$true)]
        [String]
        $ImageName = 'picture_of_the_day.jpg',
        [parameter(Mandatory=$true)]
        [String]
        $TokenLocation 
    )
    
    Function Set-WallPaper($Value){
$setwallpapersrc = @"
using System.Runtime.InteropServices;
public class wallpaper
{
public const int SetDesktopWallpaper = 20;
public const int UpdateIniFile = 0x01;
public const int SendWinIniChange = 0x02;
[DllImport("user32.dll", SetLastError = true, CharSet = CharSet.Auto)]
private static extern int SystemParametersInfo (int uAction, int uParam, string lpvParam, int fuWinIni);
public static void SetWallpaper ( string path )
{
SystemParametersInfo( SetDesktopWallpaper, 0, path, UpdateIniFile | SendWinIniChange );
}
}
"@
    Add-Type -TypeDefinition $setwallpapersrc
    [wallpaper]::SetWallpaper($Value) 
    }
    #ensure PSRAW module is installed
    if(!(Get-Module PSRAW)){
        Install-Module PSRAW
    }
    else {
        Import-Module PSRAW
    }
    #Import your PSRAW xml token file
    Import-RedditOAuthToken $TokenLocation
    Foreach($reddit in $Subreddit){
        #randomly select an image from the subreddit top 
        Write-Verbose "Retriving top scoring images from Subreddit"
        $result = Get-Random -InputObject ((Invoke-RedditRequest -uri $reddit).Response | ConvertFrom-Json).data.children.data
        #pulls the image data
        Write-Verbose "Finding jpg images"
        [string]$picurl = $result.url | Select-String -Pattern "jpg"
        #saves image locally
        Invoke-RestMethod -uri $picurl.Trim() -OutFile (Join-Path $ImageLocation $ImageName )
        Write-Verbose "Changing desktop image to: $($result.title)"
        #sets wallpaper
        Set-WallPaper -value (Join-Path $ImageLocation $ImageName )
    }
}

#Set-RedditWallPaper -Subreddit "https://oauth.reddit.com/r/EarthPorn/top"  -TokenLocation "C:\Users\joerod\Documents\psrawtoken.xml" -Verbose
