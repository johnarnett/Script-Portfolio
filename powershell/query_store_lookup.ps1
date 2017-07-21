#Query ODBC DSN for store infor (description, address, phone, etc)

$Store = Read-Host "Enter 3-digit Store number: "
$SQLConn=New-Object System.Data.Odbc.OdbcConnection
$SQLCmd=New-Object System.Data.Odbc.OdbcCommand
$SQLQuery="SELECT * FROM stores WHERE st_id = '$Store'"

#$SQLConn.ConnectionString="Driver={IBM INFORMIX ODBC DRIVER};Host=$SQLHostname;Server=$SQLServer;
#Service=1910;Protocol=olsoctcp;Database=$SQLDBName;Uid=informix;Pwd=UniteK;"

$SQLConn.ConnectionString="Dsn=Apropos"

$SQLConn.Open()

$SQLCmd.CommandText = $SQLQuery
$SQLCmd.Connection = $SQLConn

$SQLAdapter = New-Object System.Data.Odbc.OdbcDataAdapter
$SQLAdapter.SelectCommand = $SQLCmd

$DataSet = New-Object System.Data.DataSet
$SQLAdapter.Fill($DataSet) | Out-Null

$SQLConn.Close()

$Info = $DataSet.Tables[0]

Write-Host ""
Write-Host "Store Info:"
Write-Host ""
$Info.st_id
$Info.st_desc
$Info.st_shp_add1
$Info.st_shp_add2
$Info.st_shp_city
$Info.st_shp_st
$Info.st_shp_zip
$Info.st_phone

if ($Store.length -ne 3) {Write-host "Store Variable is not 3!"}
    elseif ($Store.GetType().Name -eq "String"){write-host "Letters found!"}

$Store.GetType().Name