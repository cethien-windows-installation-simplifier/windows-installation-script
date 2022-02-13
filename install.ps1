# Script to install stuff

. .\common.ps1

#region VARIABLES
$downloadLocation = $ENV:USERPROFILE + "/Downloads"
$programsPath = $ENV:ProgramFiles
$commonStartMenuPath = [Environment]::GetFolderPath("CommonPrograms")
$userStartMenuPath = [Environment]::GetFolderPath("Programs")

$userFontPath = $ENV:LOCALAPPDATA + "/Microsoft/Windows/Fonts"

#endregion VARIABLES

$files = Get-Content -Raw -Path ".\data.json" | ConvertFrom-Json
$files


#region INSTALL

#endregion INSTALL