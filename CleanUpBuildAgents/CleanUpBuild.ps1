$ErrorActionPreference="SilentlyContinue"
Stop-Transcript | out-null
$ErrorActionPreference = "Continue"

$logPath = [Environment]::GetFolderPath("Desktop") + "\CleanUp\CleanBuild" + (get-date -Format yyMMdd )+ ".log"
Start-Transcript -path $logPath -append


$limit = (Get-Date).AddDays(-5)

#Set root dir
$Agentslist = "C:\agent1\_work","C:\agent2\_work"
 
foreach ($root in $Agentslist) {
"<-- Process " + $root + " -->"
    #List build directories
    $builddirs = Get-ChildItem -Path $root | ?{ $_.PSIsContainer }

    #Fetch most recent file in each build dir (eg 1 to xxx dir)
    foreach ($d in $builddirs){

        if($d.Name -match '^\d+$'){

            $dirInfo = ([System.IO.DirectoryInfo]$d.FullName)
            $latest = $dirInfo.GetFiles("*.*","AllDirectories") | Sort-Object CreationTime -Descending | Select-Object -First 1

            if($latest.CreationTime -lt $limit){
        
            "<" + $d.Name + ">"
           
               $latest.FullName
               $latest.CreationTime 

                "===> Delete " + $d.Name + " as it is too old"
            "</" + $d.Name + ">"

            $command = 'cmd.exe /C rmdir ' + $d.FullName +  '/S /Q'
            Invoke-Expression -Command:$command

            } else {
            #$d.Name + " is OK"
            }

        }
    }
}

"End of Script"

# Transcript
Stop-Transcript