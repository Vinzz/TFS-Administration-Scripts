$ErrorActionPreference="SilentlyContinue"
Stop-Transcript | out-null
$ErrorActionPreference = "Continue"

#log file
$logPath = [Environment]::GetFolderPath("Desktop") + "\StickySession\sticky" + (get-date -Format yyMMdd )+ ".log"

# parameters
$computername = "YourTargetComputer"
$sessionLogin = "loginToUse"
$rdpPath = "pathto RDPfile.rdp"

$queryResults = qwinsta /server:$computername

$isActive = 0

ForEach ($line in $queryResults) {
	if($line.Contains($sessionLogin) -and $line.Contains("Active")) {
		$isActive = 1
	}
}
Start-Transcript -path $logPath -append

#do not  open sessions from 3AM to 6AM
if((get-date).hour -gt 2 -and (get-date).hour -lt 7)
{
    $logTime = Get-Date
    -join ($logTime, ' - ', "No sessions during the dead of night")
    $isActive = 0
}

if($isActive -eq 0) {
	

	# Kill any local RDP session before creating a new one
	Stop-Process -processname mstsc

	$logTime = Get-Date
	-join ($logTime, ' - ', "Open Session")
	 Start-Process "$env:windir\system32\mstsc.exe" -ArgumentList $rdpPath
	 
	
}

# Transcript
Stop-Transcript
