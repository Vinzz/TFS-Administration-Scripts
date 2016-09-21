# TFS-Administration-Scripts

powershell administrations scripts for TFS

### CleanUp Build Agent

* CleanUpBuild.ps1
* CleanUpBuildXaml.ps1

Will scan for the newest file in each build folder, and delete the build folder if it's too old (just set the _limit_ at the begining of the file)

The according register scheduled tasks scripts prompts for a user name and password and, well, register the scheduled tasks