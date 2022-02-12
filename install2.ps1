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

$files = [System.Collections.ArrayList]@()

# Powershell
$powershell = [File]::new("basic", "winget", "")
$powershell.WingetID = "Microsoft.PowerShell"
[void]$files.Add($powershell)

# Windows Terminal
$terminal = [File]::new("basic", "winget", "")
$terminal.WingetID = "Microsoft.WindowsTerminal"
[void]$files.Add($terminal)

# beacn app (software for Beacn products)
$beacnapp = [File]::new("full", "web", "Install-BeacnApp.exe")
$beacnapp.Url = "https://beacn-app-public-download.s3.us-west-1.amazonaws.com/BEACN+Setup+V1.0.134.0.exe"
[void]$files.Add($beacnapp)

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


