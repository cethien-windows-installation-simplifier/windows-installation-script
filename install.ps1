# Script to install stuff

#region VARIABLES
$downloadLocation = $ENV:USERPROFILE + "/Downloads"
$programsPath = $ENV:ProgramFiles
$commonStartMenuPath = [Environment]::GetFolderPath("CommonPrograms")
$userStartMenuPath = [Environment]::GetFolderPath("Programs")

$userFontPath = $ENV:LOCALAPPDATA + "/Microsoft/Windows/Fonts"
#endregion VARIABLES

#region FUNCTIONS
function CreateDirectory {
    param (
        [string]$Path,
        [string]$Name
    )  
    return New-Item -Path $Path -Name $Name -ItemType Directory
}

function GetFile {
    param (
        [string]$URL,
        [string]$OutFile
    )
    Write-Host "Downloading '$OutFile' from $URL..."
    Invoke-WebRequest -UserAgent "Wget" -Uri $URL -OutFile $downloadLocation/$OutFile
    return "$downloadLocation/$OutFile"
    Write-Host "Downloaded '$OutFile'!"
}

function GetGithubLatestReleaseAsset {
    param (
        [string]$Repository,
        [string]$AssetNamePattern,
        [string]$OutFile
    )
    $releasesUri = "https://api.github.com/repos/$Repository/releases/latest"
    $asset = (Invoke-WebRequest $releasesUri | ConvertFrom-Json).assets | Where-Object name -like $AssetNamePattern
    Write-Host "Fetching latest Asset '$asset' from '$Repository'..."
    $assetUrl = $asset.browser_download_url

    return GetFile -URL $assetUrl -OutFile $OutFile
    Write-Host "Fetched '$asset' as '$OutFile'!"
}

function CreateShortcut {
    param (
        [string]$SourceFilePath,
        [string]$ShortcutLocation,
        [string]$FileName
    )
    $ShortcutPath = "$ShortcutLocation\$FileName.lnk"
    $WScriptObj = New-Object -ComObject ("WScript.Shell")
    $shortcut = $WscriptObj.CreateShortcut($ShortcutPath)
    $shortcut.TargetPath = $SourceFilePath
    $shortcut.Save()
    Write-Host "Creating Shortcut '$ShortcutName' Done"
    return $SourceFilePath
}

function CreateShortcutStartUser {
    param (
        [string]$SourceFilePath,
        [string]$ShortcutName
    )
        
    Write-Host "Creating User Shortcut '$ShortcutName' in start..."
    return CreateShortcut -SourceFilePath $SourceFilePath -ShortcutLocation $userStartMenuPath -FileName $ShortcutName
}

function CreateShortcutStartAll {
    param (
        [string]$SourceFilePath,
        [string]$ShortcutName
    )
    Write-Host "Creating Shortcut '$ShortcutName' in start..." 
    return CreateShortcut -SourceFilePath $SourceFilePath -ShortcutLocation $commonStartMenuPath -FileName $ShortcutName
}

#endregion FUNCTIONS

# Powershell
winget install -e --id Microsoft.PowerShell --source winget

# Windows Terminal
winget install -e --id Microsoft.WindowsTerminal --source msstore

# Java
winget install -e --id Microsoft.OpenJDK.17

#region MAIN APPS

# Google Chrome
winget install -e --id Google.Chrome

# Spotify
winget install -e --id Spotify.Spotify

# Discord
winget install -e --id Discord.Discord

# Drive File Stream
winget install -e --id Google.Drive

# Rambox
$url = "https://rambox.app/api/download?os=windows"
$file = GetFile `
    -URL $url `
    -OutFile 'Rambox-installer.exe'

Invoke-Item $file

#endregion MAIN APPS

#region UTILITIES

# 7Zip
winget install -e --id 7zip.7zip

#Geek Uninstaller
$file = GetFile `
    -URL "https://geekuninstaller.com/geek.zip" `
    -OutFile "./geekUnistaller.zip"

$installPath = CreateDirectory `
    -Path $programsPath `
    -Name "Geek Uninstaller"

Expand-Archive `
    -Path $file `
    -DestinationPath $installPath

CreateShortcutStartAll `
    -SourceFilePath "$installPath/geek.exe" `
    -ShortcutName "Geek Uninstaller"

# VLC Media Player
winget install -e --id VideoLAN.VLC

# Adobe Acrobat Reader DC
winget install -e --id Adobe.AdobeAcrobatReaderDC

# powertoys
winget install -e --id Microsoft.PowerToys

#endregion UTILITIES

#region EDITING

# paint.net
$file = GetFile `
    -URL "https://www.dotpdn.com/files/paint.net.4.3.7.install.anycpu.web.zip" `
    -OutFile 'paintNET.zip' 

Expand-Archive -Path $file -DestinationPath $downloadLocation

Invoke-Item $(Get-ChildItem -Path $downloadLocation -Filter *.exe -Include "paint.net" | Select-Object -First 1)

# inkscape
winget install -e --id Inkscape.Inkscape

# gimp
winget install -e --id GIMP.GIMP

# audacity
winget install -e --id Audacity.Audacity

#endregion EDITING

#region FONTS
 
# FiraCode Nerd
$file = GetGithubLatestReleaseAsset `
    -Repository 'ryanoasis/nerd-fonts' `
    -AssetNamePattern 'FiraCode.zip' `
    -OutFile 'FiraCodeNerd-latest.zip'
    
unzip -o -j $file "/*.otf" -d $userFontPath
    
#endregion FONTS

#region CUSTOMIZATION

# Logitech G Hub
$file = GetFile `
    -URL "https://download01.logi.com/web/ftp/pub/techsupport/gaming/lghub_installer.exe" `
    -OutFile 'InstallLogitechGhub.exe'
Invoke-Item $file


# Corsair iCUE
winget install -e --id Corsair.iCUE.4

# Rainmeter
winget install -e --id Rainmeter.Rainmeter

# Spicetify
Invoke-WebRequest "https://raw.githubusercontent.com/khanhas/spicetify-cli/master/install.ps1" | Invoke-Expression

#endregion CUSTOMIZATION

#region AUDIO

# EarTrumpet
winget install -e --id File-New-Project.EarTrumpet

# Equalizer APO
$file = GetFile `
    -URL "https://sourceforge.net/projects/equalizerapo/files/latest/Download"  `
    -OutFile 'InstallEqualizerAPO-latest.exe'
Invoke-Item $file    

# VoiceMeeter Potato
winget install -e --id VB-Audio.VoicemeeterPotato

# Virtual Audio Cable
$file = GetFile `
    -URL "https://Download.vb-audio.com/Download_CABLE/VBCABLE_Driver_Pack43.zip" `
    -OutFile 'VBCABLE_Driver_Pack.zip'

$location = "$downloadLocation/Install_VBCABLE"
unzip $file -d $location
Invoke-Item "$location/VBCABLE_Setup_x64.exe"

#region VST Plugins

# Noise Suppresion VST
$file = GetGithubLatestReleaseAsset `
    -Repository 'werman/noise-suppression-for-voice' `
    -AssetNamePattern 'windows_rnnoise_bin_x64*.zip' `
    -OutFile 'rnnoise-latest.zip'
    
unzip -o -j $file "bin/vst/*" -d $(CreateDirectory -Path $programsPath -Name VSTPlugins)

#endregion VST Plugins

#endregion AUDIO

#region DEVELOPMENT

# Git (interactive mode)
winget install -e --id Git.Git -i

# Github CLI
winget install -e --id GitHub.cli

# Visual Studio Code (interactive mode)
winget install -e --id Microsoft.VisualStudioCode -i

# KeepassXC
winget install -e --id KeePassXCTeam.KeePassXC

# DevToys
winget install -e --id 9PGCV4V3BK4W

#endregion DEVELOPMENT

#region GAMING

# Steam
winget install -e --id Valve.Steam

# MultiMC (Minecraft Instance Manager)
$file = GetFile `
    -URL "https://files.multimc.org/downloads/mmc-stable-win32.zip" `
    -OutFile 'multiMC-latest-stable.zip'

unzip $file -d $programsPath

#endregion GAMING

#region STREAMING

# OBS Studio
winget install -e --id OBSProject.OBSStudio

#endregion STREAMING