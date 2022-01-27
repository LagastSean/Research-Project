#!/usr/bin/pwsh -Command

$param1=$args[0]
$param2=$args[1]

$string1=".\"
$string2="$param1\"
$string3="vars.tf"

$Varspath=$string1+$string2+$string3

$CSVPath = $param2.replace('/','\')

$Content = Get-Content $Varspath

$UserList = Import-Csv -Path $CSVPath -Delimiter ";"

$UserNameString = ""
$EmailString = ""
$IdString = ""
$AmountUsers = 0
$Environment = ""

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
$Environment = $param1

$Content | ForEach-Object { $_ -replace ".+#UserName","    default = [$UserNameString] #UserName" } | ForEach-Object { $_ -replace ".+#Email","    default = [$EmailString] #Email" } | ForEach-Object { $_ -replace ".+#Id","    default = [$IdString] #Id" } | ForEach-Object { $_ -replace ".+#Amount","    default = $AmountUsers #Amount" } | ForEach-Object { $_ -replace ".+#Environment","    default = `"$Environment`" #Environment" } | Set-Content $Varspath