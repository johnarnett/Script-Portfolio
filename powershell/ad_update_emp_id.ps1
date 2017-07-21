# Update Employee ID where missing in Active Directory

$skipped_users = @()

# Dump list of active users from AD where Employee ID is missing
$users = Get-ADUser -Filter * -Properties samaccountname,employeeid | where { $_.employeeid -eq $null } | where { $_.DistinguishedName -like "*OU=Zumiez Users*" } | where {$_.Name -NotLike "*C -*"} | where {$_.Name -notlike "*T -*"} | select -Property Samaccountname -ExpandProperty Samaccountname
$users >> C:\home\johna\tmp\emp_list.log

# Start user loop
$users | foreach {

# Grab Employee ID from OBDC connection to remote database
$SQLConn=New-Object System.Data.Odbc.OdbcConnection
$SQLCmd=New-Object System.Data.Odbc.OdbcCommand
$SQLQuery="SELECT * FROM users WHERE user_id = '$_'"
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

# Update Employee ID in AD
if($Info -ne $null)
{ 
Get-ADUser -Identity $_
$Info.apropos_user
Set-ADUser -Identity $_ -EmployeeID $Info.apropos_user
}

else
{
$skipped_users += $_
}

#End user loop
}

# Log failed users to file
$skipped_users >> C:\home\johna\tmp\emp_list_no_salescode.log
