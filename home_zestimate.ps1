#I wrote this script to programaticly find the 'Zestimate' of a property using the Zillow API
#Usage Find-HousePrice -Address '123 Sesame St.' -Citystatezip 11237
#You must register on the Zillow site for a ZWSID for this scirpt to work

Function Find-HousePrice($Address, $CityStateZip){
    $address = [System.Web.HttpUtility]::UrlEncode($address)
    $citystatezip = [System.Web.HttpUtility]::UrlEncode($citystatezip)

    $ZWSID = ""
    $result = Invoke-RestMethod ("http://www.zillow.com/webservice/GetSearchResults.htm?zws-id=" + $ZWSID + "&address=$address&citystatezip=$citystatezip") -Method Get
    "{0:C0}" -f [int] $result.searchresults.response.results.result.zestimate.amount.'#text'
}

Find-HousePrice -Address '123 Sesame St' -CityStateZip 11211
