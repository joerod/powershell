#This script uses will give you some information of your ISP
Invoke-RestMethod -Uri http://ip-api.com/json/$((Invoke-RestMethod -Uri 'https://api.ipify.org?format=json').ip)
