# Script to install my stuff
$downloadLocation = $ENV:USERPROFILE + "\Downloads"

# FUNCTIONS
# ====
function getGithubRepoUrl($repo, $assetPattern) {
    $releasesUri = "https://api.github.com/repos/$repo/releases/latest"
    $asset = (Invoke-WebRequest $releasesUri | ConvertFrom-Json).assets | Where-Object name -like $assetPattern
    return $asset.browser_download_url
}

# RUNTIMES
# ====
# Java
winget install -e --id Microsoft.OpenJDK.17

# UTILITIES
# ====
# 7Zip
winget install -e --id 7zip.7zip
# VLC Media Player
winget install -e --id VideoLAN.VLC
# Adobe Acrobat Reader DC
winget install -e --id Adobe.AdobeAcrobatReaderDC

# APPS
# ====
# Spotify
winget install -e --id Spotify.Spotify
# Discord
winget install -e --id Discord.Discord
# Drive File Stream
winget install -e --id Google.Drive


# COMMUNICATION
# ====
# Teamspeak
winget install -e --id TeamSpeakSystems.TeamSpeakClient
# WhatsApp
winget install -e --id WhatsApp.WhatsApp
# WhatsApp Tray
$uri = getGithubRepoUrl 'D4koon/WhatsappTray' 'WhatsappTray*.exe'
$file = 'InstallWhatsappTray-latest.exe'
Invoke-WebRequest -Uri $uri -OutFile $downloadLocation\$file

Invoke-Item $downloadLocation\$file

# EDITING
# ====
# paint.net
$uri = "https://www.dotpdn.com/files/paint.net.4.3.7.install.anycpu.web.zip"
$file = 'paintNET.zip'
Invoke-WebRequest -Uri $uri -OutFile $downloadLocation\$file
unzip $downloadLocation\$file -d 
# inkscape
winget install -e --id Inkscape.Inkscape
# gimp
winget install -e --id GIMP.GIMP
# audacity
winget install -e --id Audacity.Audacity

# MISC
# ====
# FiraCode
$uri = getGithubRepoUrl 'tonsky/FiraCode' 'Fira_Code_v*.zip'
$file = 'FiraCode-latest.zip'
Invoke-WebRequest -Uri $uri -OutFile $downloadLocation\$file

unzip $downloadLocation\$file "variable_ttf/*"
./variable_ttf/FiraCode-VF.ttf

# CUSTOMIZATION
# ====
# Logitech G Hub
$file = 'InstallLogitechGhub.exe'
Invoke-WebRequest -Uri "https://download01.logi.com/web/ftp/pub/techsupport/gaming/lghub_installer.exe" -OutFile $downloadLocation\$file
Invoke-Item $downloadLocation\$file
# Corsair iCUE
winget install -e --id Corsair.iCUE.4
# Rainmeter
winget install -e --id Rainmeter.Rainmeter
# Spicetify
Invoke-WebRequest -UseBasicParsing "https://raw.githubusercontent.com/khanhas/spicetify-cli/master/install.ps1" | Invoke-Expression

# AUDIO
# ====
# EarTrumpet
winget install -e --id File-New-Project.EarTrumpet
# Equalizer APO
$file = 'InstallEqualizerAPO-latest.exe'
Invoke-WebRequest -UserAgent "Wget" -Uri "https://sourceforge.net/projects/equalizerapo/files/latest/download" -OutFile $downloadLocation\$file
Invoke-Item $downloadLocation\$file
# VoiceMeeter Potato
winget install -e --id VB-Audio.VoicemeeterPotato
# Virtual Audio Cable
$file = 'VBCABLE_Driver_Pack.zip'
Invoke-WebRequest -UserAgent "Wget" -Uri "https://download.vb-audio.com/Download_CABLE/VBCABLE_Driver_Pack43.zip" -OutFile $downloadLocation\$file
unzip $downloadLocation\$file -d ".\VBCABLE\"
Invoke-Item $downloadLocation\VBCABLE\VBCABLE_Setup_x64.exe

# PROGRAMMING
# ====
# Git (interactive mode)
winget install -e --id Git.Git -i
# Github CLI
winget install -e --id GitHub.cli
# Visual Studio Code (interactive mode)
winget install -e --id Microsoft.VisualStudioCode -i
# KeepassXC
winget install -e --id KeePassXCTeam.KeePassXC

# GAMING
# ====
# Steam
winget install -e --id Valve.Steam

# STREAMING
# ====
# OBS Studio
winget install -e --id OBSProject.OBSStudio
