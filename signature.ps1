#set this to the location of the gam binaries
Set-Alias gam C:\gam\gam.exe

#Imports data from a csv that has coloumns listed as below. 
$salesou = Import-Csv C:\scripts\sales.csv
foreach($column in $salesou)
  {
  $field1 = $column.email
  $field2 = $column.first
  $field3 = $column.last 
  $field4 = $column.title 
  $field5 = $column.mobile
  $field6 = $column.desk 
  $field7 = $column.patch1 
  $field8 = $column.url1
  $field9 = $column.patch2
  $field10 = $column.url2
  $field11 = $column.patch3
  $field12 = $column.url3
  $field13 = $column.patch4
  $field14 = $column.url4 
  $field15 = $column.patch5
  $field16 = $column.url5
  $field17 = $column.patch6
  $field18 = $column.url6
  $field19 = $column.patch7
  $field20 = $column.url7

#prepends | o: string if user has mobile and desk number
$prepend = $null;
if(![string]::IsNullOrEmpty($field6)) { $prepend = "| o: "; }
$field6 = $prepend + $column.desk 

#sets the url link for the Patch Town if one exists
$url1 = $null
if(![string]::IsNullOrEmpty($field7)) {$url1 = "<a href=$field8 target='_blank'>$field7</a>"}
$url2 = $null
if(![string]::IsNullOrEmpty($field9)) {$url2 = "<a href=$field10 target='_blank'>$field9</a>"}
$url3 = $null
if(![string]::IsNullOrEmpty($field11)){$url3 = "<a href=$field12 target='_blank'>$field11</a>"}
$url4 = $null
if(![string]::IsNullOrEmpty($field13)){$url4 = "<a href=$field14 target='_blank'>$field13</a>"}
$url5 = $null
if(![string]::IsNullOrEmpty($field15)){$url5 = "<a href=$field16 target='_blank'>$field15</a>"}
$url6 = $null
if(![string]::IsNullOrEmpty($field17)){$url6 = "<a href=$field18 target='_blank'>$field17</a>"}
$url7 = $null
if(![string]::IsNullOrEmpty($field19)){$url7 = "<a href=$field20 target='_blank'>$field19</a>"}

#prepends | charecter to Patch Town url variable if not null
$prepend = $null;
if(![string]::IsNullOrEmpty($field7)) { $prepend = "| "; }
$link1 = $prepend +  $url1

$prepend = $null;
if(![string]::IsNullOrEmpty($field9)) { $prepend = "| "; }
$link2 = $prepend + $url2

$prepend = $null;
if(![string]::IsNullOrEmpty($field11)) { $prepend = "| "; }
$link3 = $prepend + $url3

$prepend = $null;
if(![string]::IsNullOrEmpty($field13)) { $prepend = "| "; }
$link4 = $prepend + $url4

$prepend = $null;
if(![string]::IsNullOrEmpty($field15)) { $prepend = "| "; }
$link5 = $prepend + $url5

$prepend = $null;
if(![string]::IsNullOrEmpty($field17)) { $prepend = "| "; }
$link6 = $prepend + $url6

$prepend = $null;
if(![string]::IsNullOrEmpty($field19)) { $prepend = "| "; }
$link7 = $prepend + $url7

$html = @"
$field2 $field3<br>
$field4<br>
c: $field5 $field6<br>
<img src="https://lh6.googleusercontent.com/uiHmtV8HkmcInU_D3RNeuj1P6X72RP0BtkPLdxNSVcysCYSQxRfIAxcQ5Yu1DJbGPfgZlF1mcfHkqxi66IX-KDDB30ZCflsII4u78hl4bqVJ305-cps" height="32px;" width="105px;"><br>
See what&#39;s happening right now on your Patch!<br>
$link1 $link2 $link3 $link4 $link5 $link6 $link7<br>
"@

gam user $field1 signature "$html"

}  
