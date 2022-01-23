Write-Host "Fetching newest Update script..."
$startup = [Environment]::GetFolderPath("CommonStartup")
Invoke-WebRequest `
    -Uri "https://raw.githubusercontent.com/Cethien/windows-install-scripts/main/update.ps1" `
    -OutFile "$startup/update.ps1"
Write-Host "Newest Update installed!"

Write-Host "Updating Spictify..."
spicetify upgrade
Write-Host "Spictify updated!"

Write-Host "Updating Winget files..."
winget upgrade --all
Write-Host "winget apps updated!"