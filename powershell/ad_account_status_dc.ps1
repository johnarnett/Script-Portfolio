# Check account status on all Domain Controllers

$DomainControllers = Get-ADDomainController -Filter *

ForEach ($DC in $DomainControllers)
    {
    Write-Host $DC
    Get-ADUser -Identity "<<username>>" -Server $DC.Hostname `
    -Properties AccountLockoutTime, LastBadPasswordAttempt, BadPwdCount, LockedOut
    }