#i'll use this script in future scripts when using the get-aduser cmdlet.  I had problems when a user has an apostrophes
#in their name

a = "Jermaine O'Neal"
if($a.contains("'")){

($a.replace( "'","''"))
}
