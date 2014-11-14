# Mirror AD group membership of one user to another

#function reflect{
#param($x, $y)

$x = $args[0]
$y = $args[1]

$ErrorActionPreference = "SilentlyContinue"
$x_CHECK = Get-ADUser $x -ErrorAction SilentlyContinue
$y_CHECK = Get-ADUser $y -ErrorAction SilentlyContinue
$failed_groups = @()

#Validation Check
if ($x_CHECK -eq $null) 
    { Write-Host "Error: $x is not a valid user" -ForegroundColor red
      return
    }
elseif ($y_CHECK-eq $null)
    { Write-Host "Error: $y is not a valid user" -ForegroundColor red
      return
    }

# Confirmation Message Box
$msg = New-Object -ComObject wscript.shell
$intAnswer = $msg.popup("Do you want to copy Group Membership from $x to ${y}?", 0, "Confirmation", 4)

# If "Yes", copy group membership
if ($intAnswer -eq 6)
    {
        Write-Host "Copying Group Membership. Please Wait..." -ForegroundColor green 
        Write-Host ""
        $template = Get-ADUser $x -Properties *
     
        ForEach ($i in $template.MemberOf)
            {   $group_name = ($i -split ",")[0].Substring(3)
                $group = Get-ADGroup -Filter * | Where-Object {$_.name -eq "$group_name"} | Select-Object -ExpandProperty samaccountname
       
                Write-Host $group
                Add-ADGroupMember $group $y

                if ($? -eq $false)
                {
                    Write-Host "Failed" -ForegroundColor red
                    $failed_groups += @("$group")
                }
            }

            if ($failed_groups)
            {
               write-host "Failed Groups"
               write-host $failed_groups
            }
    }
else
    { Write-Host "Cancelled by user" -ForegroundColor red }

    
#}