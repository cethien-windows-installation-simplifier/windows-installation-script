# Script to install stuff

#region VARIABLES
$downloadLocation = $ENV:USERPROFILE + "/Downloads"
$programsPath = $ENV:ProgramFiles
$commonStartMenuPath = [Environment]::GetFolderPath("CommonPrograms")
$userStartMenuPath = [Environment]::GetFolderPath("Programs")

$userFontPath = $ENV:LOCALAPPDATA + "/Microsoft/Windows/Fonts"

#endregion VARIABLES

#region CLASSES

class File {
    [string]$InstallationCategory
    [string]$DownloadSource
    [string]$OutFile

    [string]$Url

    [string]$Repository
    [string]$AssetNamePattern
    
    [string]$WingetID
    [bool]$WingetInteractive = $false
    
    File(        
        [string]$installationCategory,
        [string]$downloadSource,
        [string]$outFile
    ) {
        $this.InstallationCategory = $installationCategory
        $this.DownloadSource = $downloadSource
        $this.OutFile = $outFile
    }  
    
    [void] InstallFromPackageManager() {
        if ($this.WingetInteractive -eq $true) {
            winget install -e --id $this.WingetID -i
        }
        else {
            winget install -e --id $this.WingetID            
        }
    }

    [void] GetFromWeb() {
        Invoke-WebRequest -UserAgent "Wget" -Uri $this.Url -OutFile $this.OutFile
    }

    [void] GetFromLatestGitHubRelases() {
        $releasesUri = "https://api.github.com/repos/$this.Repository/releases/latest"
        $asset = (Invoke-WebRequest $releasesUri | ConvertFrom-Json).assets | Where-Object name -like $this.AssetNamePattern
        $assetUrl = $asset.browser_download_url
        
        this.GetFromWeb($assetUrl, $this.OutFile)
    }
}

#endregion CLASSES

#region FUNCTIONS
function CreateDirectory {
    param (
        [string]$Path,
        [string]$Name
    )  
    return New-Item -Path $Path -Name $Name -ItemType Directory
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

$files = [System.Collections.ArrayList]@()

# Powershell
$powershell = [File]::new("basic", "winget", "")
$powershell.WingetID = "Microsoft.PowerShell"
[void]$files.Add($powershell)

# Windows Terminal
$terminal = [File]::new("basic", "winget", "")
$terminal.WingetID = "Microsoft.WindowsTerminal"
[void]$files.Add($terminal)

#region MAIN APPS

# Google Chrome
$chrome = [File]::new("basic", "winget", "")
$chrome.WingetID = "Google.Chrome"
[void]$files.Add($chrome)

# Spotify
$spotify = [File]::new("basic", "winget", "")
$spotify.WingetID = "Spotify.Spotify"
[void]$files.Add($spotify)
    
# Discord
$discord = [File]::new("full", "winget", "")
$discord.WingetID = "Discord.Discord"
[void]$files.Add($discord)
    
# Drive File Stream
$drive = [File]::new("full", "winget", "")
$drive.WingetID = "Google.Drive"
[void]$files.Add($drive)
    
# Rambox
$rambox = [File]::new("full", "web", "Install-Rambox.exe")
$rambox.Url = "https://rambox.app/api/download?os=windows"
[void]$files.Add($rambox)
    
#endregion MAIN APPS

#region UTILITIES

# Java
$java = [File]::new("basic", "winget", "")
$java.WingetID = "Microsoft.OpenJDK.17"
[void]$files.Add($java)

# 7Zip
$7zip = [File]::new("basic", "winget", "")
$7zip.WingetID = "7zip.7zip"
[void]$files.Add($7zip)

# VLC Media Player
$vlc = [File]::new("full", "winget", "")
$vlc.WingetID = "VideoLAN.VLC"
[void]$files.Add($vlc)

# Adobe Acrobat Reader DC
$pdfReader = [File]::new("full", "winget", "")
$pdfReader.WingetID = "Adobe.AdobeAcrobatReaderDC"
[void]$files.Add($pdfReader)

# powertoys
$powertoys = [File]::new("full", "winget", "")
$powertoys.WingetID = "Microsoft.PowerToys"
[void]$files.Add($powertoys)
        
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


#endregion UTILITIES
    
#region EDITING
    
# paint.net
$file = GetFile `
    -URL "https://www.dotpdn.com/files/paint.net.4.3.7.install.anycpu.web.zip" `
    -OutFile 'paintNET.zip' 

Expand-Archive -Path $file -DestinationPath $downloadLocation

Invoke-Item $(Get-ChildItem -Path $downloadLocation -Filter *.exe -Include "paint.net" | Select-Object -First 1)

# inkscape
$inkscape = [File]::new("full", "winget", "")
$inkscape.WingetID = "Inkscape.Inkscape"
[void]$files.Add($inkscape)        
    
# gimp
$gimp = [File]::new("full", "winget", "")
$gimp.WingetID = "GIMP.GIMP"
[void]$files.Add($gimp)
        
# audacity
$audacity = [File]::new("full", "winget", "")
$audacity.WingetID = "Audacity.Audacity"
[void]$files.Add($audacity)
        
#endregion EDITING

#region CUSTOMIZATION

# Logitech G Hub
$file = GetFile `
    -URL "https://download01.logi.com/web/ftp/pub/techsupport/gaming/lghub_installer.exe" `
    -OutFile 'InstallLogitechGhub.exe'
Invoke-Item $file
    
# Corsair iCUE
$icue = [File]::new("full", "winget", "")
$icue.WingetID = "Corsair.iCUE.4"
[void]$files.Add($icue)

# Rainmeter
$rainmeter = [File]::new("full", "winget", "")
$rainmeter.WingetID = "Rainmeter.Rainmeter"
[void]$files.Add($rainmeter)

# Spicetify
Invoke-WebRequest "https://raw.githubusercontent.com/khanhas/spicetify-cli/master/install.ps1" | Invoke-Expression

#endregion CUSTOMIZATION

#region AUDIO

# EarTrumpet
$eartrumpet = [File]::new("full", "winget", "")
$eartrumpet.WingetID = "File-New-Project.EarTrumpet"
[void]$files.Add($eartrumpet)

# BEACN App (Only usable with BEACN Products)
$url = "https://beacn-app-public-download.s3.us-west-1.amazonaws.com/BEACN+Setup+V1.0.134.0.exe"
$file = GetFile `
    -URL $url`
-OutFile "install-beacn-app.exe"
Invoke-Item $file    

# Equalizer APO
$url = "https://sourceforge.net/projects/equalizerapo/files/latest/Download"
$file = GetFile `
    -URL $url  `
    -OutFile 'InstallEqualizerAPO-latest.exe'
Invoke-Item $file    

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

# Git
$git = [File]::new("basic", "winget", "")
$git.WingetID = "Git.Git"
$git.WingetInteractive = $true
[void]$files.Add($git)

# Github CLI
$gh = [File]::new("basic", "winget", "")
$gh.WingetID = "GitHub.cli"
$gh.WingetInteractive = $true
[void]$files.Add($gh)

# Visual Studio Code
$vscode = [File]::new("basic", "winget", "")
$vscode.WingetID = "Microsoft.VisualStudioCode"
$vscode.WingetInteractive = $true
[void]$files.Add($vscode)

# KeepassXC
$keepass = [File]::new("basic", "winget", "")
$keepass.WingetID = "KeePassXCTeam.KeePassXC"
[void]$files.Add($keepass)

# DevToys
$devtoys = [File]::new("basic", "winget", "")
$devtoys.WingetID = "9PGCV4V3BK4W"
[void]$files.Add($devtoys)

#endregion DEVELOPMENT

#region FONTS
 
# FiraCode Nerd
$file = GetGithubLatestReleaseAsset `
    -Repository 'ryanoasis/nerd-fonts' `
    -AssetNamePattern 'FiraCode.zip' `
    -OutFile 'FiraCodeNerd-latest.zip'
    
unzip -o -j $file "/*.otf" -d $userFontPath
    
#endregion FONTS

#region GAMING

# Steam
$steam = [File]::new("full", "winget", "")
$steam.WingetID = "Valve.Steam"
[void]$files.Add($steam)

# MultiMC (Minecraft Instance Manager)
$file = GetFile `
    -URL "https://files.multimc.org/downloads/mmc-stable-win32.zip" `
    -OutFile 'multiMC-latest-stable.zip'

unzip $file -d $programsPath

#endregion GAMING

#region STREAMING

# OBS Studio
$obs = [File]::new("full", "winget", "")
$obs.WingetID = "OBSProject.OBSStudio"
[void]$files.Add($obs)

# Stream Deck
$streamdeck = [File]::new("full", "winget", "")
$streamdeck.WingetID = "Elgato.StreamDeck"
[void]$files.Add($streamdeck)

#endregion STREAMING

#region INSTALL
$install = "full"

foreach ($file in $files) {
    $cond = $file.InstallationCategory -eq $install
    
    if ($install -eq "full") {
        $cond = $file.InstallationCategory -eq "basic" -or "full"
    }

    if ($cond) {        
        switch ($file.DownloadSource) {
            "web" { $file.GetFromWeb() }
            "winget" { $file.InstallFromPackageManager() }
            "github" { $file.GetFromLatestGitHubRelases() }
            Default {
                $source = $file.DownloadSource
                Write-Host "Download Source '$source' undefined"
            }
        }
    }
}

#endregion INSTALL