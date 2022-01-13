# Script to install my stuff
$downloadLocation = $ENV:USERPROFILE + "/Downloads"
$vstPath = $ENV:ProgramFiles + "/VSTPlugins"
$progPath = $ENV:ProgramFiles

#region FUNCTIONS

function getGithubLatestReleaseUrl($repo, $assetPattern) {
    $releasesUri = "https://api.github.com/repos/$repo/releases/latest"
    $asset = (Invoke-WebRequest $releasesUri | ConvertFrom-Json).assets | Where-Object name -like $assetPattern
    return $asset.browser_download_url
}

function download($uri, $zipFile) {
    Invoke-WebRequest -UserAgent "Wget" -Uri $uri -OutFile $downloadLocation/$zipFile
    return "$downloadLocation/$zipFile"
}

function downloadAndRun($uri, $runFile) {
    Invoke-Item $(download $uri $runFile)
}

#endregion FUNCTIONS

#region RUNTIMES

# Java
winget install -e --id Microsoft.OpenJDK.17

#endregion RUNTIMES

#region UTILITIES

# 7Zip
winget install -e --id 7zip.7zip

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
$uri = getGithubLatestReleaseUrl 'D4koon/WhatsappTray' 'WhatsappTray*.exe'
downloadAndRun $uri 'InstallWhatsappTray-latest.exe'

#endregion COMMUNICATION

#region EDITING

# paint.net

$file = download "https://www.dotpdn.com/files/paint.net.4.3.7.install.anycpu.web.zip" 'paintNET.zip' 
unzip $file -d 

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

# FiraCode
$uri = getGithubLatestReleaseUrl 'tonsky/FiraCode' 'Fira_Code_v*.zip'
$file = download $uri 'FiraCode-latest.zip'
unzip $file "variable_ttf/*"
Invoke-Item ./variable_ttf/FiraCode-VF.ttf

#endregion MISC

#region CUSTOMIZATION

# Logitech G Hub
downloadAndRun "https://download01.logi.com/web/ftp/pub/techsupport/gaming/lghub_installer.exe" 'InstallLogitechGhub.exe'

# Corsair iCUE
winget install -e --id Corsair.iCUE.4

# Rainmeter
winget install -e --id Rainmeter.Rainmeter

# Spicetify
Invoke-WebRequest -UseBasicParsing "https://raw.githubusercontent.com/khanhas/spicetify-cli/master/install.ps1" | Invoke-Expression

#endregion CUSTOMIZATION

#region AUDIO

# EarTrumpet
winget install -e --id File-New-Project.EarTrumpet

# Equalizer APO
downloadAndRun "https://sourceforge.net/projects/equalizerapo/files/latest/download" 'InstallEqualizerAPO-latest.exe'

# Noise Suppresion VST
$uri = getGithubLatestReleaseUrl 'werman/noise-suppression-for-voice' 'windows_rnnoise_bin_x64*.zip'
$file = download $uri 'rnnoise-latest.zip'
$location = "$downloadLocation/librnnoiseVST"
unzip $file "bin/vst/*" -d $location
explorer.exe $location

$readmefile = "install-readme.txt"
New-Item $location -ItemType Directory
New-Item "$location/$readmefile" -ItemType File -Value "Install by dropping the .dll from bin/vst/ into $vstPath"

# VoiceMeeter Potato
winget install -e --id VB-Audio.VoicemeeterPotato

# Virtual Audio Cable
$file = download "https://download.vb-audio.com/Download_CABLE/VBCABLE_Driver_Pack43.zip" 'VBCABLE_Driver_Pack.zip'
unzip $file -d "./VBCABLE/"
Invoke-Item $downloadLocation/VBCABLE/VBCABLE_Setup_x64.exe

#endregion AUDIO

#region PROGRAMMING

# Git (interactive mode)
winget install -e --id Git.Git -i

# Github CLI
winget install -e --id GitHub.cli

# Visual Studio Code (interactive mode)
winget install -e --id Microsoft.VisualStudioCode -i

# KeepassXC
winget install -e --id KeePassXCTeam.KeePassXC

#endregion PROGRAMMING

#region GAMING

# Steam
winget install -e --id Valve.Steam

# MultiMC (Minecraft Instance Manager)
$location = "$downloadLocation/multiMC-stable"
$file = download "https://files.multimc.org/downloads/mmc-stable-win32.zip" 'multiMC-latest-stable.zip'
unzip $file -d $location
explorer.exe $location

$readmefile = "install-readme.txt"
New-Item $location -ItemType Directory
New-Item "$location/$readmefile" -ItemType File -Value "Install by dropping the MultiMC folder wherever you want to (preferably '$progPath')"

#endregion GAMING

#region STREAMING

# OBS Studio
winget install -e --id OBSProject.OBSStudio

#endregion STREAMING