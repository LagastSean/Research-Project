#!/usr/bin/pwsh -Command

$param1=$args[0]
$param2=$args[1]

$string1=".\"
$string2=$param1.replace('/','\')
$string3="vars.tf"

$Varspath=$string1+$string2+$string3

$CSVPath = $param2.replace('/','\')

$Content = Get-Content $Varspath

#$Content = Get-Content ".\vars.tf"

#$CSVPath = '.\Userinfo.csv'
$UserList = Import-Csv -Path $CSVPath -Delimiter ";"

$UserNameString = ""
$EmailString = ""
$IdString = ""
$AmountUsers = 0

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

$Content | ForEach-Object { $_ -replace ".+#UserName","    default = [$UserNameString] #UserName" } | ForEach-Object { $_ -replace ".+#Email","    default = [$EmailString] #Email" } | ForEach-Object { $_ -replace ".+#Id","    default = [$IdString] #Id" } | ForEach-Object { $_ -replace ".+#Amount","    default = $AmountUsers #Amount" } | Set-Content $Varspath