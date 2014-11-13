# This file defines user-specific settings
# when Powershell starts

set-location c:\home\johna

function home{Set-Location C:\home\johna}
function scripts{Set-Location C:\home\johna\scripts}

function info{
param($x)
Get-ADUser -Identity $x -Properties * | Format-List -Property Name,Title,Department,Office,OfficePhone,SamAccountName,LogonCount,PasswordExpired, LockedOut,BadLogonCount,LastBadPasswordAttempt
}

function confirm{
param($x)
Get-ADUser -Identity $x -Properties * | Format-List -Property Name,PasswordExpired, LockedOut
}

function search{
param($x)
Get-ADUser -filter * | Where-Object {$_.samaccountname -like "*$x*"} | Format-List -Property SamAccountName
}

function pkill{
param($x)
Get-Process -name $x | Stop-Process
}

function g {
$x = $args -split ";"
$base = "https://www.google.com/search?q="
$search = $x[0]
for ($i=1; $i -lt $x.count; $i++)
{$search = $search+"+"+$x[$i]}
ch $base+$search
}

# Aliases

set-alias hm home
set-alias scripts scripts
set-alias nt "notepad.exe"
set-alias ch "C:\Program Files\Google\Chrome\Application\chrome.exe"
set-alias citrix "C:\Program Files\Citrix\SelfServicePlugin\SelfService.exe"
set-alias reboot "shutdown.exe /r"

# AD Aliases

set-alias i info
set-alias s search