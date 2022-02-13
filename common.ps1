#region CLASSES

class File {
    [string]$Type
    [string]$InstallationCategory = "basic"
    
    File() {
        $this.Type = $this        
    }
}

class WebFile : File {
    [string]$Url
    [string]$OutFile
        
    [void] GetFile() {
        Invoke-WebRequest -UserAgent "Wget" -Uri $this.Url -OutFile $this.OutFile
    }
}
    
class GitHubAssetFile : File {
    [string]$Repository
    [string]$AssetNamePattern
    [string]$OutFile
           
    [void] GetAssetFromLatestRelase() {
        $releasesUri = "https://api.github.com/repos/$this.Repository/releases/latest"
        $asset = (Invoke-WebRequest $releasesUri | ConvertFrom-Json).assets | Where-Object name -like $this.AssetNamePattern
        $assetUrl = $asset.browser_download_url
                
        Invoke-WebRequest -UserAgent "Wget" -Uri $assetUrl -OutFile $this.OutFile
    }
}
        
class WingetFile : File {
    [string]$Id
    [bool]$InteractiveMode = $false
                 
    [void] Install() {
        if ($this.InteractiveMode -eq $true) {
            winget install -e --id $this.Id -i
        }
        else {
            winget install -e --id $this.Id            
        }
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