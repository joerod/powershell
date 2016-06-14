$folder_Search = New-Object System.Collections.ArrayList
$folder_find = New-Object System.Collections.ArrayList
$confluence = New-WebServiceProxy -uri https://confluence/rpc/soap-axis/confluenceservice-v2?wsdl -namespace Confluence_API
$confluence.Timeout = 1000000
$username = 'joe.rodriguez'
$password = ''
$searchfor = ""
$page_key = ''
$destination_space = ''
$title_append = ''  

$token = $confluence.login($username, $password)
$confluence.getSpaces($token)
foreach ($global:page in ($confluence.getpages($token,$searchfor))){

}
