############################################
# Get File

Import-Module winscp

$ServerName = "<<SERVER>>"
$Username = "johna"
$Password = ""

$sessionOptions = New-Object WinSCP.SessionOptions
$sessionOptions.Protocol = [WinSCP.Protocol]::Sftp
$sessionOptions.Hostname = $ServerName
$sessionOptions.Username = $Username
$sessionOptions.Password = $Password
$sessionOptions.GiveUpSecurityAndAcceptAnySshHostKey = $true

$session = New-Object WinSCP.Session
$session.Open($sessionOptions)

$transferOptions = New-Object WinSCP.TransferOptions
$transferOptions.TransferMode = [WinSCP.TransferMode]::Binary

$SourcePath = "/tmp/john/test.*"
$DestinationPath = "C:\bin\test.txt"

$session.Getfiles("$SourcePath", "$DestinationPath", $False, $transferOptions)
#Error checking:
#$result = $session.Getfiles("$SourcePath", "$DestinationPath", $False, $transferOptions)
#$result.Failures
#$result.True

$session.Dispose()

############################################
# Put File

Import-Module winscp

$ServerName = "<<SERVER>>"
$Username = "johna"
$Password = ""

$sessionOptions = New-Object WinSCP.SessionOptions
$sessionOptions.Protocol = [WinSCP.Protocol]::Sftp
$sessionOptions.Hostname = $ServerName
$sessionOptions.Username = $Username
$sessionOptions.Password = $Password
$sessionOptions.GiveUpSecurityAndAcceptAnySshHostKey = $true

$session = New-Object WinSCP.Session
$session.Open($sessionOptions)

$transferOptions = New-Object WinSCP.TransferOptions
$transferOptions.TransferMode = [WinSCP.TransferMode]::Binary

$SourcePath = "C:\bin\test.txt"
$DestinationPath = "/tmp/john/"

$session.PutFiles("$SourcePath", "$DestinationPath", $False, $transferOptions)

$session.Dispose()


############################################
# Move File

Import-Module winscp

$ServerName = "<<SERVER>>"
$Username = "johna"
$Password = ""

$sessionOptions = New-Object WinSCP.SessionOptions
$sessionOptions.Protocol = [WinSCP.Protocol]::Sftp
$sessionOptions.Hostname = $ServerName
$sessionOptions.Username = $Username
$sessionOptions.Password = $Password
$sessionOptions.GiveUpSecurityAndAcceptAnySshHostKey = $true

$session = New-Object WinSCP.Session
$session.Open($sessionOptions)

$transferOptions = New-Object WinSCP.TransferOptions
$transferOptions.TransferMode = [WinSCP.TransferMode]::Binary

$SourcePath = "/tmp/john/from/test.txt"
$DestinationPath = "/tmp/john/to/test.bak"

$session.MoveFile("$SourcePath", "$DestinationPath")

$session.Dispose()