$ErrorActionPreference="SilentlyContinue"
Stop-Transcript | out-null
$ErrorActionPreference = "Continue"

$logPath = [Environment]::GetFolderPath("Desktop") + "\CleanUp\CleanBuildXAML" + (get-date -Format yyMMdd )+ ".log"
Start-Transcript -path $logPath -append


$limit = (Get-Date).AddDays(-5)

 
#List build directories
$buildAgentdirs = Get-ChildItem -Path 'C:\Builds' | ?{ $_.PSIsContainer }

#Fetch most recent file in each build dir (eg 1 to xxx dir)
foreach ($d in $buildAgentdirs){

'Process ' + $d.Name

    $buildDefinitiondirs = Get-ChildItem -Path $d.FullName | ?{ $_.PSIsContainer }

    foreach ($build in $buildDefinitiondirs){
            $dirInfo = ([System.IO.DirectoryInfo]$build.FullName)
            $latest = $dirInfo.GetFiles("*.*","AllDirectories") | Sort-Object CreationTime -Descending | Select-Object -First 1

            if($latest.CreationTime -lt $limit){
        
            "<" + $build.Name + ">"
           
                $latest.FullName
                $latest.CreationTime 

                "===> Delete " + $build.Name + " as it is too old"
            "</" + $build.Name + ">"

            $command = 'cmd.exe /C rmdir ' + $build.FullName +  '/S /Q'
            Invoke-Expression -Command:$command

            } else {
            #$build.Name + " is OK"
            }
        }
    
    }

"End of Script"

# Transcript
Stop-Transcript