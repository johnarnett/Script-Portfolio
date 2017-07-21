# Prepend employee IDs in Active Directory with leading zeros

$input = Get-ADUser -Filter * -Properties * | where {$_.employeeid -ne $null} | where {($_.employeeid | measure -Character).Characters -lt 6 } | select samaccountname,employeeid
$input | measure

foreach ($x in $input) {
    Write-Host $x.samaccountname
    Write-Host $x.employeeid
    $salescode = $x.employeeid

    $count = ($x.employeeid | Measure-Object -Character).Characters

    $sub = 6 - $count
    $pre = "0"
    for ($i=1; $i -lt $sub; $i++)
    {
        $pre = "${pre}0"
    }
    
    $result = "${pre}${salescode}"
    $result
    
    Set-ADUser -Identity $x.samaccountname -EmployeeID $result
    Write-Host ""
}

$Error