#Wrote this as my first attempt at GUI POSH. This script accepts an Active Directory Users by SamAccontName and returns
#a users Real Name as listed in AD.  The end result is a pop-up window with the users real name.

Function Get-RealName($SAMAccountName){
    try {
        (Get-ADUser $SAMAccountName -ErrorAction Stop).Name
    }
    catch {
        Write-Output "Cannot find $SAMAccountName"
    }
}

Add-Type -AssemblyName System.Windows.Forms

$GetActiveDirectoryUser = New-Object system.Windows.Forms.Form
$GetActiveDirectoryUser.Text = "GetActiveDirectoryUser"
$GetActiveDirectoryUser.TopMost = $true
$GetActiveDirectoryUser.Width = 450
$GetActiveDirectoryUser.Height = 150
$GetActiveDirectoryUser.Icon = [system.drawing.icon]::ExtractAssociatedIcon($PSHOME + "\powershell.exe")


$textBox1_SAMAccountName = New-Object system.windows.Forms.TextBox
$textBox1_SAMAccountName.Width = 165
$textBox1_SAMAccountName.Height = 20
$textBox1_SAMAccountName.location = new-object system.drawing.point(137, 26)
$textBox1_SAMAccountName.Font = "Microsoft Sans Serif,10"
$GetActiveDirectoryUser.controls.Add($textBox1_SAMAccountName)


$button1_SAMAccountName = New-Object System.Windows.Forms.Button
$button1_SAMAccountName.Text = "Real Name"
$button1_SAMAccountName.Width = 100
$button1_SAMAccountName.Height = 30
$button1_SAMAccountName.Add_Click({
        $wshell = New-Object -ComObject Wscript.Shell
        $wshell.Popup((Get-RealName -SamAccountName $textBox1_SAMAccountName.text), 0, "Real Name", 0x0)
    })
$button1_SAMAccountName.location = new-object system.drawing.point(314, 23)
$button1_SAMAccountName.Font = "Microsoft Sans Serif,10"
$GetActiveDirectoryUser.controls.Add($button1_SAMAccountName)


$label1_SAMAccountName = New-Object system.windows.Forms.Label
$label1_SAMAccountName.Text = "SAMAccountName"
$label1_SAMAccountName.AutoSize = $true
$label1_SAMAccountName.Width = 25
$label1_SAMAccountName.Height = 10
$label1_SAMAccountName.location = new-object system.drawing.point(13, 27)
$label1_SAMAccountName.Font = "Microsoft Sans Serif,10"
$GetActiveDirectoryUser.controls.Add($label1_SAMAccountName)


[void] $GetActiveDirectoryUser.ShowDialog()
$GetActiveDirectoryUser.Dispose()
