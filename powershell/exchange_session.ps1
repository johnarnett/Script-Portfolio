# Create powershell session to Exchange

function exchange($EXCHANGE_SERVER) {
$cred = Get-Credential zumiez.com\ja-admin
$session = New-PSSession -ConfigurationName Microsoft.Exchange -connectionuri http://$EXCHANGE_SERVER/powershell -Credential $cred
Import-PSSession $session
}