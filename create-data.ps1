. .\common.ps1

$files = [System.Collections.ArrayList]@()

#region APPS

# Powershell
$powershell = [WingetFile]::new("basic", "Microsoft.PowerShell", $false)
[void]$files.Add($powershell)

# Windows Terminal
$terminal = [WingetFile]::new("basic", "Microsoft.WindowsTerminal", $false)
[void]$files.Add($terminal)

#region MAIN APPS

# Google Chrome
$chrome = [WingetFile]::new("basic", "Google.Chrome", $false)
[void]$files.Add($chrome)

# Spotify
$spotify = [WingetFile]::new("basic", "Spotify.Spotify", $false)
[void]$files.Add($spotify)
    
# Discord
$discord = [WingetFile]::new("full", "Discord.Discord", $false)
[void]$files.Add($discord)
    
# Drive File Stream
$drive = [WingetFile]::new("full", "Google.Drive", $false)
[void]$files.Add($drive)
    
# Rambox
$url = "https://rambox.app/api/download?os=windows"
$rambox = [WebFile]::new("full", $url, "Install-Rambox.exe")
[void]$files.Add($rambox)
    
#endregion MAIN APPS

#region UTILITIES

# Java
$java = [WingetFile]::new("basic", "Microsoft.OpenJDK.17", $false)
[void]$files.Add($java)

# 7Zip
$7zip = [WingetFile]::new("basic", "7zip.7zip", $false)
[void]$files.Add($7zip)

# VLC Media Player
$vlc = [WingetFile]::new("full", "VideoLAN.VLC", $false)
[void]$files.Add($vlc)

# Adobe Acrobat Reader DC
$pdfReader = [WingetFile]::new("full", "Adobe.AdobeAcrobatReaderDC", $false)
[void]$files.Add($pdfReader)

# powertoys
$powertoys = [WingetFile]::new("full", "Microsoft.PowerToys", $false)
[void]$files.Add($powertoys)

#Geek Uninstaller
$url = "https://geekuninstaller.com/geek.zip"
$geek = [WebFile]::new("full", $url, "geekUnistaller.zip")
[void]$files.Add($geek)

#endregion UTILITIES
    
#region EDITING
    
# paint.net
$url = "https://www.dotpdn.com/files/paint.net.4.3.7.install.anycpu.web.zip"
$paintnet = [WebFile]::new("basic", $url, "paintNET.zip")
[void]$files.Add($paintnet)

# inkscape
$inkscape = [WingetFile]::new("full", "Inkscape.Inkscape", $false)
[void]$files.Add($inkscape)        
    
# gimp
$gimp = [WingetFile]::new("full", "GIMP.GIMP", $false)
[void]$files.Add($gimp)
        
# audacity
$audacity = [WingetFile]::new("full", "Audacity.Audacity", $false)
[void]$files.Add($audacity)
        
#endregion EDITING

#region CUSTOMIZATION

# Logitech G Hub
$url = "https://download01.logi.com/web/ftp/pub/techsupport/gaming/lghub_installer.exe"
$lghub = [WebFile]::new("full", $url, "Install-LogitechGhub.exe")
[void]$files.Add($lghub)
    
# Corsair iCUE
$icue = [WingetFile]::new("full", "Corsair.iCUE.4", $false)
[void]$files.Add($icue)

# Rainmeter
$rainmeter = [WingetFile]::new("full", "Rainmeter.Rainmeter", $false)
[void]$files.Add($rainmeter)

# Spicetify
# Invoke-WebRequest "https://raw.githubusercontent.com/khanhas/spicetify-cli/master/install.ps1" | Invoke-Expression

#endregion CUSTOMIZATION

#region AUDIO

# EarTrumpet
$eartrumpet = [WingetFile]::new("full", "File-New-Project.EarTrumpet", $false)
[void]$files.Add($eartrumpet)

# BEACN App (Only usable with BEACN Products)
$beacnapp = [WebFile]::new("full", "web", "Install-BeacnApp.exe")
$beacnapp.Url = "https://beacn-app-public-download.s3.us-west-1.amazonaws.com/BEACN+Setup+V1.0.134.0.exe"
[void]$files.Add($beacnapp)

# Equalizer APO
$eqApo = [WebFile]::new("full", "web", "Install-EqualizerAPO.exe")
$eqApo.Url = "https://sourceforge.net/projects/equalizerapo/files/latest/Download"
[void]$files.Add($eqApo)

#region VST Plugins

# Noise Suppresion VST
$repo = "werman/noise-suppression-for-voice"
$assetName = "windows_rnnoise_bin_x64*.zip"
$rnnoise = [GitHubAssetFile]::new("full", $repo, $assetName, "rnnoise-latest.zip")
[void]$files.Add($rnnoise)

#endregion VST Plugins

#endregion AUDIO

#region DEVELOPMENT

# Git
$git = [WingetFile]::new("basic", "Git.Git", $true)
[void]$files.Add($git)

# Github CLI
$gh = [WingetFile]::new("basic", "GitHub.cli", $false)
[void]$files.Add($gh)

# Visual Studio Code
$vscode = [WingetFile]::new("basic", "Microsoft.VisualStudioCode", $true)
[void]$files.Add($vscode)

# KeepassXC
$keepass = [WingetFile]::new("basic", "KeePassXCTeam.KeePassXC", $false)
[void]$files.Add($keepass)

# DevToys
$devtoys = [WingetFile]::new("basic", "9PGCV4V3BK4W", $false)
[void]$files.Add($devtoys)

#endregion DEVELOPMENT

#region FONTS
 
# FiraCode Nerd
$repo = "ryanoasis/nerd-fonts"
$assetName = "FiraCode.zip"
$firacode = [GitHubAssetFile]::new("full", $repo, $assetName, "FiraCodeNerd-latest.zip")
[void]$files.Add($firacode)

#endregion FONTS

#region GAMING

# Steam
$steam = [WingetFile]::new("full", "Valve.Steam", $false)
[void]$files.Add($steam)

# MultiMC (Minecraft Instance Manager)
$url = "https://files.multimc.org/downloads/mmc-stable-win32.zip"
$multimc = [WebFile]::new("full", $url, "multiMC-latest-stable.zip")
[void]$files.Add($multimc)

#endregion GAMING

#region STREAMING

# OBS Studio
$obs = [WingetFile]::new("full", "OBSProject.OBSStudio", $false)
[void]$files.Add($obs)

# Stream Deck
$streamdeck = [WingetFile]::new("full", "Elgato.StreamDeck", $false)
[void]$files.Add($streamdeck)

#endregion STREAMING

#endregion APPS

$files | ConvertTo-Json | Out-File "data.json"