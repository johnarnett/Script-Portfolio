Import-Module activedirectory 

############################
#   Auto-Disable Account   #
############################
$date = Get-Date -UFormat %m%d%Y
$LOGFILE = "\\backroom\globalaccess$\AccountManagement\Logs\${date}_disabled.log"
#$ErrorActionPreference = "SilentlyContinue"
$PSEmailServer = "smtp-relay.zumiez.com"

################################
# Initiate Exchange Connection #
################################

# THIS WHOLE SECTION IS COMMENTED OUT!
<#
function exchange{
#$cred = Get-Credential zumiez.com\$env:username
$session = New-PSSession -ConfigurationName Microsoft.Exchange -connectionuri https://zmvvexcas01.zumiez.com/powershell
Import-PSSession $session
}

$exchange_check = Get-PSSession | Where-Object {$_.ConfigurationName -eq "Microsoft.Exchange"}

if(!$exchange_check)
{    Write-Host "Exchange Not Connected"
     Write-Host "Connecting to Exchange..."
     exchange
}
     else {Write-Host "Already Connected to Exchange"}

#>


############################
# Import Accounts from DB  #
############################

#$SQLServer = "zmvxdevsql12-dd"
$SQLServer = "<<SQL_SERVER>>"
$Database = "<<DB_NAME>>"

$SQLQuery = @"
SELECT *
FROM new_terminations
"@

# Force an array/enumerable
$terms = @()
$terms += Invoke-Sqlcmd -Query $SQLQuery -ServerInstance $SQLServer -Database $Database
c: # Break out of the SQL command context

Write-Host "Pending terminations: $($terms.Count)"

# Check for null array
if($terms.Count -eq 0)
{
    $date = Get-Date -Format g 
    Add-Content -Path $LOGFILE "$date : No user data to be processed"
    exit
}

# Start Loop - Account Disable
for ($i=0; $i -lt $terms.Count; $i++)
{
    $salescode = $terms[$i].employee_number
    Write-Host "Salescode: $salescode"
   
    # Find and disable the account
    $user = (Get-ADUser -Filter {EmployeeID -eq $salescode}).samaccountname
    $Error.clear()

    if ( !$user ) {
      Write-Error "AD Account not found for $salescode" -ErrorVariable Err -ErrorAction SilentlyContinue
    } else {
      Set-ADUser -Identity $user -Enabled:$false -ErrorVariable Err -ErrorAction SilentlyContinue
      Get-ADUser -Identity $user | Move-ADObject -TargetPath 'OU=Disabled Accounts,DC=zumiez,DC=com'
    }

# <<Update 05122015 - Added SQL Update>>
# Update SQL table to mark users as Deleted

    $UpdateQuery = @"
UPDATE hr_ad_accounts
SET deleted = 1
WHERE username = '$user'
"@

    $update = Invoke-Sqlcmd -Query $UpdateQuery -ServerInstance $SQLServer -Database $Database
    c:
    $update


# Start If - Error Check
    if($Err)
    {
    $date = Get-Date -Format g 
    Add-Content -Path $LOGFILE "$date : FAILED - $user : $first_name $last_name : $salescode"
    Add-Content -Path $LOGFILE $Error
    Send-MailMessage -from "AccountMgmt <s-accountmanagement@zumiez.com>" -to "OTRS <OTRS@zumiez.com>" -Subject "Separation TAF for ${user}: Failed!" -body "$Error[1]"
    Send-MailMessage -from "AccountMgmt <s-accountmanagement@zumiez.com>" -to "John <johna@zumiez.com>" -Subject "Separation TAF for ${user}: Failed!" -body "$Error[1]"
    }
    else 
    {
    $date = Get-Date -Format g
		$email_body = "Account has been disabled and moved to the disabled users OU in Active Directory. Please proceed with the standard separation process outlined here: http://wiki.zumiez.com/index.php/Zumiez_IT_SOP#Account_Deletion" 
    Add-Content -Path $LOGFILE "$date : SUCCESS - $user : $first_name $last_name : $salescode"
    Send-MailMessage -from "AccountMgmt <s-accountmanagement@zumiez.com>" -to "OTRS <OTRS@zumiez.com>" -Subject "Separation TAF for ${user}: Succeeded!" -body $email_body
    Send-MailMessage -from "AccountMgmt <s-accountmanagement@zumiez.com>" -to "John <johna@zumiez.com>" -Subject "Separation TAF for ${user}: Succeeded!" -body $email_body    
    
    } # End If - Error Check
} # End Loop - Account Disable
