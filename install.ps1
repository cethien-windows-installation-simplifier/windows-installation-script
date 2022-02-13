# Script to install stuff

. .\common.ps1

#region VARIABLES
$downloadLocation = $ENV:USERPROFILE + "/Downloads"
$programsPath = $ENV:ProgramFiles
$commonStartMenuPath = [Environment]::GetFolderPath("CommonPrograms")

$userStartMenuPath = [Environment]::GetFolderPath("Programs")
$userFontPath = $ENV:LOCALAPPDATA + "/Microsoft/Windows/Fonts"

#endregion VARIABLES
$files = Get-Content ".\data.json" | ConvertFrom-Json

foreach ($item in $files) {
    switch ($item.Type) {
        "WebFile" {
            $webfile = [WebFile]$item
        }
    }
}


#region INSTALL

#endregion INSTALL