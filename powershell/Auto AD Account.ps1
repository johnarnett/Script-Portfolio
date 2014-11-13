# Automatically creates / disables Active Directory accounts.
# Requires pipe-delimited input file


###################################
# Function / Variable Declaration #
###################################


function exchange{
$cred = Get-Credential domain.com\<username>
$session = New-PSSession -ConfigurationName Microsoft.Exchange -connectionuri http://<exchange_server>/powershell -Credential $cred
Import-PSSession $session
}


$ErrorActionPreference = "SilentlyContinue"
$pass = aConvertTo-SecureString -AsPlainText "<password>" -Force
$skipped_users = @()
$disabled_users = @()


################################
# Initiate Exchange Connection #
################################


$exchange_check = Get-PSSession | Where-Object {$_.ConfigurationName -eq "Microsoft.Exchange"}


if(!$exchange_check)
{ Write-Host "Exchange Not Connected"
Write-Host "Connecting to Exchange..."
exchange
}
else {Write-Host "Already Connected to Exchange"}



############################
# Import Accounts from CSV #
############################


$import = Import-Csv C:\path\to\input\file.csv -Header H0, H1, H2, H3, H4, H5, H6 -Delimiter "|"


# Start Loop - Account Creation
$import | ForEach-Object {
$user = $_.H0
$first_name = $_.H1
$last_name = $_.H2
$salescode = $_.H3
$dept = $_.H4
$phone = $_.H5
$active = $_.H6


# Start If - Employee Check
if($dept -lt 600)
{ $skipped_users += @("$first_name $last_name") }
elseif($active -eq "D")
{ Set-ADUser -Identity $user -Enabled:$false
$disabled_users += @("$first_name $last_name") }
else {


$instance = Get-ADUser ${dept}_template
$template = Get-ADUser ${dept}_template -Properties *


####################
# Ceate AD Account #
####################
Write-Host ""
Write-Host "Creating Account for user: " $first_name $last_name

New-ADUser -SamAccountName $user `
-Instance $instance `
-Name "$first_name $last_name" `
-GivenName $first_name `
-Surname $last_name `
-UserPrincipalName $user@zumiez.com `
-EmployeeID $sales_code `
-DisplayName "$first_name $last_name" `
-Office $template.Office `
-Department $template.Department `
-Company $template.Company `
-HomeDrive "T" `
-HomeDirectory "\\backroom\userhomedirs$\$user" `
-AccountPassword $pass -PassThru `
-Enabled:$true


$accountExists = $null
Write-Host ""
Write-Host "Registering Account"
do {
sleep -Seconds 1
$accountExists = Get-ADUser $user -ErrorAction SilentlyContinue
Write-Host "." -NoNewline
} while (!$accountExists)



$setipphone = Get-ADUser $user -Properties ipphone
$setphone = Get-ADUser $user -Properties telephoneNumber
$setipphone.ipphone = $phone
$setphone.telephoneNumber = $phone
Set-ADUser -Instance $setipphone
Set-ADUser -Instance $setphone

Write-Host ""


ForEach ($i in $template.MemberOf)
{ $group = ($i -split ",")[0].Substring(3)
if ($group -like "*DG*")
{ $group = $group.Substring(5)
}
Write-Host $group
Add-ADGroupMember $group $user
}



##################
# Create Mailbox #
##################

#Enable-Mailbox -Identity $user@zumiez.com -Database $template.Department




} # End If - Employee Check
} # End Loop - Account Creation



###################
# List Exceptions #
###################


Write-Host ""


if ($skipped_users)
{ Write-Host "Accounts were not created for the following users:"
$skipped_users
}



if ($disabled_users)
{ Write-Host "Accounts were disabled for the following users:"
$disabled_users
}