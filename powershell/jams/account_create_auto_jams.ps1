####################
# Account Creation #
####################


###################################
# Function / Variable Declaration #
###################################

$PSEmailServer = "<<EXCHANGE_SERVER>>"
$SQLServer = "<<SQL_SERVER>>"
$Database = "ultipro"

$date = get-date -UFormat %m%d%Y
$LOGFILE = "\\backroom\globalaccess$\AccountManagement\Logs\${date}_create.log"
$ErrorActionPreference = "SilentlyContinue"
$pass = ConvertTo-SecureString -AsPlainText "2%Milk" -Force
$skipped_users = @()
$disabled_users = @()

function exchange{
#$cred = Get-Credential zumiez.com\$env:username
$session = New-PSSession -ConfigurationName Microsoft.Exchange -connectionuri https://mail.zumiez.com/powershell -Credential $env:username
Import-PSSession $session
}

Import-Module SqlPs

################################
# Initiate Exchange Connection #
################################

$exchange_check = Get-PSSession | Where-Object {$_.ConfigurationName -eq "Microsoft.Exchange"}
write-host "debug 1"
if(!$exchange_check)
{    Write-Host "Exchange Not Connected"
     Write-Host "Connecting to Exchange..."
     #exchange
}
     else {Write-Host "Already Connected to Exchange"}
write-host "debug 2"

############################
# Import Accounts from DB  #
############################



$SQLQuery = @"
SELECT *
FROM hr_employees_test
WHERE active = 'True'
"@

$input = Invoke-Sqlcmd -Query $SQLQuery -ServerInstance $SQLServer -Database $Database
#Invoke-Sqlcmd -Query $SQLQuery -ServerInstance $SQLServer -Database $Database
c:

$SQLServer
$Database
$SQLQuery
$input
$input.count

write-host "debug 3"

#################################
# Start Loop - Account Creation #
#################################
for ($i=0; $i -lt $input.Count; $i++)
{
    $first_name = $input[$i].first_name
    $last_name = $input[$i].last_name
    $salescode = $input[$i].employee_number
    $dept = $input[$i].org_level1
    $phone = "0000"

    $last_initial = $last_name.Substring(0,1)
    $user = $first_name+$last_initial
    $user = $user.ToLower()

    write-host $user
write-host "debug 4"


############################

# Start If - Employee Check
    if($dept -lt 600)
         { $skipped_users += @("$first_name $last_name") }
    else {
           $instance = Get-ADUser ${dept}_template
           $template = Get-ADUser ${dept}_template -Properties *
write-host "debug 5"
####################
# Ceate AD Account #
####################
           $Error.clear()
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
               -Enabled:$true `
							 -WhatIf

write-host "debug 6"
           $accountExists = $null
           Write-Host ""
           Write-Host "Registering Account"
           sleep -Seconds 5
           do {
               sleep -Seconds 1
               $accountExists = Get-ADUser $user -ErrorAction SilentlyContinue
               Write-Host "." -NoNewline
              } while (!$accountExists)

           Set-ADUser -Identity $user -EmployeeID $salescode -Whatif
write-host "debug 7"
           $setipphone = Get-ADUser $user -Properties ipphone
           $setphone = Get-ADUser $user -Properties telephoneNumber
           $setipphone.ipphone = $phone
           $setphone.telephoneNumber = $phone
           Set-ADUser -Instance $setipphone -Whatif
           Set-ADUser -Instance $setphone -Whatif
              
           Write-Host ""

           ForEach ($x in $template.MemberOf)
           {    $group = ($x -split ",")[0].Substring(3)
                if ($group -like "*DG*")
                {    $group = $group.Substring(5)
                }
                Write-Host $group
                Add-ADGroupMember $group $user -Whatif
           }

           Get-ADUser -Identity $user | Move-ADObject -TargetPath 'OU=ScriptTesting,OU=IT,DC=zumiez,DC=com' -Whatif
              
                           
           # Create Mailbox
           Enable-Mailbox -Identity $user@zumiez.com -Database $dept -Whatif
write-host "debug 8"
##################
# Error Checking #
##################

           # Start If - Error Check
           if($Error)
           { 
           $date = Get-Date -Format g
           Add-Content -Path $LOGFILE "$date : FAILED - $user : $first_name $last_name : $salescode"
           Add-Content -Path $LOGFILE $Error
           Send-MailMessage -from "AccountMgmt <s-accountmanagement@zumiez.com>" -to "OTRS <OTRS@zumiez.com>" -Subject "Account Creation for ${user}: Failed!" -body "For details, check: $LOGFILE"
           Send-MailMessage -from "AccountMgmt <s-accountmanagement@zumiez.com>" -to "John <johna@zumiez.com>" -Subject "Account Creation for ${user}: Failed!" -body "For details, check: $LOGFILE"
           }

           else 
           { 
           $date = Get-Date -Format g 
           Add-Content -Path $LOGFILE "$date : SUCCESS - $user : $first_name $last_name : $salescode"
           Send-MailMessage -from "AccountMgmt <s-accountmanagement@zumiez.com>" -to "OTRS <OTRS@zumiez.com>" -Subject "Account Creation for ${user}: Succeeded!" -body "Success!"
           Send-MailMessage -from "AccountMgmt <s-accountmanagement@zumiez.com>" -to "John <johna@zumiez.com>" -Subject "Account Creation for ${user}: Succeeded!" -body "Success!"
           } # End If - Error Check

write-host "debug 9"
        } # End If - Employee Check
} # End Loop - Account Creation

write-host "debug 10"
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

