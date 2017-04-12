#Was thinking about PowerShell questions to ask on an interview and I came up with these. 

#How do i know if a number is negative or positive
Function Get-NegativeOrPositive([int]$Number){
 if($Number -gt 0){Write-Output "Postive"} else{Write-Output "Negative"}
 }

 #Get-NegativeOrPositive -Number '-1'
#How do i know if a number is even or odd
 Function Get-EvenOrOdd([int]$Number){
 if($Number%2 -eq 0){Write-Output "Even"} else{Write-Output "Odd"}
 }

 # Get-EvenOrOdd -Number '-2'
