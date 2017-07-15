#i'll use this script in future scripts when using the get-aduser cmdlet.  I had problems when a user has an apostrophes
#in their name

$Name = "Jermaine O'Neal"
if($Name.contains("'")){($Name.replace( "'","''"))}
