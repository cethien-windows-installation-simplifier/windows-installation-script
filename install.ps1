# Script to install stuff

. .\common.ps1

#region VARIABLES
$downloadLocation = $ENV:USERPROFILE + "/Downloads"
$programsPath = $ENV:ProgramFiles
$commonStartMenuPath = [Environment]::GetFolderPath("CommonPrograms")

$userStartMenuPath = [Environment]::GetFolderPath("Programs")
$userFontPath = $ENV:LOCALAPPDATA + "/Microsoft/Windows/Fonts"

#endregion VARIABLES
$files = Get-Content ".\files.json" | ConvertFrom-Json

foreach ($item in $files) {
    switch ($item.Type) {
        "WebFile" {
            $file = [WebFile]$item
            Write-Host $file.Url
        }
        "WingetFile" {
            $file = [WingetFile]$item
            Write-Host $file.Id
        }
        "GitHubAssetFile" {
            $file = [GitHubAssetFile]$item
            Write-Host $file.Repository
        }
    }
}


#region INSTALL

#endregion INSTALL