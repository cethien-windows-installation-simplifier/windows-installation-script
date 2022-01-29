Write-Host "Updating Spictify..."
spicetify upgrade
Write-Host "Spictify updated!"

Write-Host "Updating Winget files..."
winget upgrade --all
Write-Host "winget apps updated!"