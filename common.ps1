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

    static [string] GetUrlForGithubAsset($repository, $assetNamePattern) {
        $releasesUri = "https://api.github.com/repos/$repository/releases/latest"
        $asset = (Invoke-WebRequest $releasesUri | ConvertFrom-Json).assets | Where-Object name -like $assetNamePattern
        return $asset.browser_download_url
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