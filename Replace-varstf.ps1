#!/usr/bin/pwsh -Command

#Variables send by the Setup script
$usedEnvironment=$args[0]
$csv=$args[1]

#Creating correct path to vars.tf file
$string1=".\"
$string2="$usedEnvironment\"
$string3="vars.tf"
$Varspath=$string1+$string2+$string3

#Replacing / syntax by \
$CSVPath = $csv.replace('/','\')

#Importing csv file
$UserList = Import-Csv -Path $CSVPath -Delimiter ";"

#Getting the content of the Varspath
$Content = Get-Content $Varspath

#Initiating variables for later use
$UserNameString = ""
$EmailString = ""
$IdString = ""
$AmountUsers = 0
$Environment = ""

#Looping through the csv file
Foreach ($User in $UserList) 
{
    $AmountUsers = ($AmountUsers + 1)
    $UserName = $User.UserName
	$Email = $User.Email
	$Id = $User.Id
	
	$UserNameString = "$UserNameString" + "`"$UserName`","
    $EmailString = "$EmailString" + "`"$Email`","
    $IdString = "$IdString" + "`"$Id`","
}

$UserNameString = $UserNameString.TrimEnd(',')
$EmailString = $EmailString.TrimEnd(',')
$IdString = $IdString.TrimEnd(',')
$Environment = $usedEnvironment

$Content | ForEach-Object { $_ -replace ".+#UserName","    default = [$UserNameString] #UserName" } | ForEach-Object { $_ -replace ".+#Email","    default = [$EmailString] #Email" } | ForEach-Object { $_ -replace ".+#Id","    default = [$IdString] #Id" } | ForEach-Object { $_ -replace ".+#Amount","    default = $AmountUsers #Amount" } | ForEach-Object { $_ -replace ".+#Environment","    default = `"$Environment`" #Environment" } | Set-Content $Varspath