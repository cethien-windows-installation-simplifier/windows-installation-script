# Script to install stuff

#region FUNCTIONS & VARIABLES
$downloadLocation = $ENV:USERPROFILE + "/Downloads"

$commonStartMenuPath = [Environment]::GetFolderPath("CommonPrograms")
$userStartMenuPath = [Environment]::GetFolderPath("Programs")
$commonStartUpPath = [Environment]::GetFolderPath("CommonStartup")
$programsPath = $ENV:ProgramFiles

function Create-Directory {
    param (
        [string]$Path,
        [string]$Name
    )  
    return New-Item -Path $Path -Name $Name -ItemType Directory
}

function ReloadPath {
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path", "User")
    Write-Host 'PATH refreshed'
}

function Get-File {
    param (
        [string]$URL,
        [string]$OutFile
    )
    Write-Host "Downloading '$OutFile' from $URL..."
    Invoke-WebRequest -UserAgent "Wget" -Uri $URL -OutFile $downloadLocation/$OutFile
    return "$downloadLocation/$OutFile"
    Write-Host "Downloaded '$OutFile'!"
}

function Get-GithubLatestReleaseAsset {
    param (
        [string]$Repository,
        [string]$AssetNamePattern,
        [string]$OutFile
    )
    $releasesUri = "https://api.github.com/repos/$Repository/releases/latest"
    $asset = (Invoke-WebRequest $releasesUri | ConvertFrom-Json).assets | Where-Object name -like $AssetNamePattern
    Write-Host "Fetching latest Asset '$asset' from '$Repository'..."
    $assetUrl = $asset.browser_download_url

    return Get-File -URL $assetUrl -OutFile $OutFile
    Write-Host "Fetched '$asset' as '$OutFile'!"
}

function Create-Shortcut {
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

function Create-ShortcutStartUser {
    param (
        [string]$SourceFilePath,
        [string]$ShortcutName
    )
        
    Write-Host "Creating User Shortcut '$ShortcutName' in start..."
    return Create-Shortcut -SourceFilePath $SourceFilePath -ShortcutLocation $userStartMenuPath -FileName $ShortcutName
}

function Create-ShortcutStartAll {
    param (
        [string]$SourceFilePath,
        [string]$ShortcutName
    )
    Write-Host "Creating Shortcut '$ShortcutName' in start..." 
    return Create-Shortcut -SourceFilePath $SourceFilePath -ShortcutLocation $commonStartMenuPath -FileName $ShortcutName
}

#endregion FUNCTIONS & VARIABLES

#region RUNTIMES

# Java
winget install -e --id Microsoft.OpenJDK.17

#endregion RUNTIMES

#region UTILITIES

# Windows Terminal
winget install -e --id Microsoft.WindowsTerminal

# 7Zip
winget install -e --id 7zip.7zip

#Geek Uninstaller
$file = Get-File `
    -URL "https://geekuninstaller.com/geek.zip" `
    -OutFile "./geekUnistaller.zip"

$installPath = Create-Directory `
    -Path $programsPath `
    -Name "Geek Uninstaller"

Expand-Archive `
    -Path $file `
    -DestinationPath $installPath

Create-ShortcutStartAll `
    -SourceFilePath "$installPath/geek.exe" `
    -ShortcutName "Geek Uninstaller"

# VLC Media Player
winget install -e --id VideoLAN.VLC

# Adobe Acrobat Reader DC
winget install -e --id Adobe.AdobeAcrobatReaderDC

#endregion UTILITIES

#region MAIN APPS

# Google Chrome
winget install -e --id Google.Chrome

# Spotify
winget install -e --id Spotify.Spotify

# Discord
winget install -e --id Discord.Discord

# Drive File Stream
winget install -e --id Google.Drive

#endregion MAIN APPS

#region COMMUNICATION

# Teamspeak
winget install -e --id TeamSpeakSystems.TeamSpeakClient

# WhatsApp
winget install -e --id WhatsApp.WhatsApp

# WhatsApp Tray
$file = Get-GithubLatestReleaseAsset `
    -Repository 'D4koon/WhatsappTray' `
    -AssetNamePattern 'WhatsappTray*.exe' `
    -OutFile 'InstallWhatsappTray-latest.exe'

Invoke-Item $file

#endregion COMMUNICATION

#region EDITING

# paint.net
$file = Get-File `
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

#region MISC

# powertoys
winget install -e --id Microsoft.PowerToys

#endregion MISC

#region CUSTOMIZATION

#region FONTS

# FiraCode Font
$file = Get-GithubLatestReleaseAsset `
    -Repository 'tonsky/FiraCode' `
    -AssetNamePattern 'Fira_Code_v*.zip' `
    -OutFile 'FiraCode-latest.zip'

unzip -o -j $file "variable_ttf/*" -d $fontDownloadLocation 
Invoke-Item "$fontDownloadLocation/FiraCode-VF.ttf"
    
#endregion FONTS

# Logitech G Hub
$file = Get-File `
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
$file = Get-File `
    -URL "https://sourceforge.net/projects/equalizerapo/files/latest/Download"  `
    -OutFile 'InstallEqualizerAPO-latest.exe'
Invoke-Item $file    

# VoiceMeeter Potato
winget install -e --id VB-Audio.VoicemeeterPotato

# Virtual Audio Cable
$file = Get-File `
    -URL "https://Download.vb-audio.com/Download_CABLE/VBCABLE_Driver_Pack43.zip" `
    -OutFile 'VBCABLE_Driver_Pack.zip'

$location = "$downloadLocation/Install_VBCABLE"
unzip $file -d $location
Invoke-Item "$location/VBCABLE_Setup_x64.exe"

#region VST Plugins

# Noise Suppresion VST
$file = Get-GithubLatestReleaseAsset `
    -Repository 'werman/noise-suppression-for-voice' `
    -AssetNamePattern 'windows_rnnoise_bin_x64*.zip' `
    -OutFile 'rnnoise-latest.zip'
    
unzip -o -j $file "bin/vst/*" -d $(Create-Directory -Path $programsPath -Name VSTPlugins)

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
$file = Get-File `
    -URL "https://files.multimc.org/downloads/mmc-stable-win32.zip" `
    -OutFile 'multiMC-latest-stable.zip'

unzip $file -d $programsPath

#endregion GAMING

#region STREAMING

# OBS Studio
winget install -e --id OBSProject.OBSStudio

#endregion STREAMING

#================================
# POST-INSTALL
#================================

ReloadPath

#region Spicetify

# install spicetify expensions & apps
spicetify
spicetify config extensions webnowplaying.js
spicetify config custom_apps new-releases
spicetify config inject_css 0 replace_colors 0
spicetify backup apply

#endregion Spicetify

#Download Update Script into Startup Folder
Invoke-WebRequest `
    -Uri "https://raw.githubusercontent.com/Cethien/windows-install-scripts/main/update.ps1" `
    -OutFile $commonStartUpPath/update.ps1