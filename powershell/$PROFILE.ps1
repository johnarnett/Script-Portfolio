######################
# Powershell Profile #
######################

# This file defines user-specific settings when Powershell starts


set-location c:\home\johna

#############
# Functions #
#############

function home {Set-Location C:\home\johna}
function scripts {Set-Location C:\home\johna\scripts}

function pkill {
param($x)
Get-Process -name $x | Stop-Process
}

function google {
$x = $args -split ";"
$base = "https://www.google.com/search?q="
$search = $x[0]
for ($i=1; $i -lt $x.count; $i++)
{$search = $search+"+"+$x[$i]}
ch $base+$search
}


################
# AD Functions #
################

function info { # Display Account Info of User
param($x)
Get-ADUser -Identity $x -Properties * | Format-List -Property Name,Title,Department,Office,MobilePhone,OfficePhone,SamAccountName,EmployeeID,LogonCount,PasswordExpired, LockedOut,BadLogonCount,LastBadPasswordAttempt
}

function search { # Search Users by userid
param($x)
Get-ADUser -filter * | Where-Object {$_.samaccountname -like "*$x*"} | Format-List -Property SamAccountName
}

function search.full { # Search Users by Name
param($x)
Get-ADUser -filter * -Properties * | Where-Object {$_.name -like "*$x*"} | Format-List -Property Name,Title,Department,Office,OfficePhone,SamAccountName,EmployeeID,LogonCount,PasswordExpired, LockedOut,BadLogonCount,LastBadPasswordAttempt
}

function locked { # Search for All Locked-Out Users
Search-ADAccount -lockedout | Format-List -Property SamAccountName
}

function confirm{ # Display Locked Out Status of User
param($x)
Get-ADUser -Identity $x -Properties * | Format-List -Property Name, PasswordExpired, LockedOut
}

function member { # List Group Membership of User in plain text
param($x)
$user = get-aduser $x -Properties *
Write-Host ""
Write-Host "Group Membership for" $user.Name
ForEach ($i in $user.MemberOf)
            {   $group = ($i -split ",")[0].Substring(3)
                Write-Host " " $group -ForegroundColor DarkCyan
            }
}


######################
# Exchange Functions #
######################

function exchange{ # Initiate connection to Exchange Server
$cred = Get-Credential domain.com\ja-admin
$session = New-PSSession -ConfigurationName Microsoft.Exchange -connectionuri http://<exchange_server>/powershell -Credential $cred
Import-PSSession $session
}


#############
#  Aliases  #
#############

Set-Alias nt "notepad.exe"
Set-Alias ch "C:\Program Files\Google\Chrome\Application\chrome.exe"
Set-Alias citrix "C:\Program Files\Citrix\SelfServicePlugin\SelfService.exe"
Set-Alias reboot "shutdown.exe /r"
Set-Alias reflect "C:\home\johna\scripts\mirror_memberof.ps1"

Set-Alias i info
Set-Alias s search
Set-Alias sf search.full
Set-Alias m member
Set-Alias hm home
Set-Alias g google
