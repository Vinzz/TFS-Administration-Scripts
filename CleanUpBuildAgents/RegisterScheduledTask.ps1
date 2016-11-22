$logPath = [Environment]::GetFolderPath("Desktop") + "\CleanUp\"
New-Item -ItemType Directory -Force -Path $logPath

$action = New-ScheduledTaskAction -Execute 'Powershell' `
  -Argument '.\CleanUpBuild.ps1' -WorkingDirectory (Get-Item -Path ".\" -Verbose).FullName

$trigger =  New-ScheduledTaskTrigger -Daily -At 3am

$msg = "Enter the username and password that will run the task"; 
$credential = $Host.UI.PromptForCredential("Task username and password",$msg,"$env:userdomain\$env:username",$env:userdomain)
$username = $credential.UserName
$password = $credential.GetNetworkCredential().Password
$settings = New-ScheduledTaskSettingsSet -StartWhenAvailable -RunOnlyIfNetworkAvailable -DontStopOnIdleEnd
Register-ScheduledTask -TaskName "CleanUpBuildFolders" -Description "Daily cleanup of old build folders" -Action $action -Trigger $trigger -User $username -Password $password -Settings $settings | out-null
