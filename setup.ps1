. ./common.ps1

#region INSTALLATION

# prompt for installation options
$title = "Hi!"
$msg = "Before we start, do you wish to install your quick basic workspace stuff`
or make a full installation for every autistic programm, setting & customization?"
$options = '&Quick', '&Full'
$default = 0

do {
    $response = $Host.UI.PromptForChoice($title, $msg, $options, $default)
} until ($response -eq 0 -or 1)


$files = Get-Content ".\files.json" | ConvertFrom-Json

Write-Host "Running Installation..."

foreach ($item in $files) {    
    switch ($item.Type) {
        "WebFile" {
            $file = [WebFile]$item
            Write-Host "Webfile URL: " $file.Url
        }
        "WingetFile" {
            $file = [WingetFile]$item
            Write-Host "Winget ID: " $file.Id
        }
        "GitHubAssetFile" {
            $file = [GitHubAssetFile]$item
            Write-Host "Github Repo: " $file.Repository
        }
    }
}

Write-Host "Installation done!"

#endregion INSTALLATION

#region CUSTOMIZATION

# prompt for customization
$title = "Customizting!"
$msg = "Do you want to load you customization script?"
$options = '&Yes', '&No'
$default = 1

do {
    $response = $Host.UI.PromptForChoice($title, $msg, $options, $default)
} until ($response -eq 0 -or 1)

if ($response -eq 0) {
    
    ReloadPath
    
    Write-Host "Running customization..."
    RunFromRaw -FileName "run-customize.ps1"
    Write-Host "Customization done!"
    
    #region Update Script
    
    # Create Update Script into Startup Folder
    $content = "Invoke-WebRequest `"https://raw.githubusercontent.com/Cethien/windows-install-scripts/main/update.ps1`" | Invoke-Expression"
    $item = "$commonStartUpPath/update.ps1"
    New-Item $item
    Set-Content -Path $item -Value $content
    
    # Set Access so you dont need admin to run it
    $acl = Get-Acl $commonStartUpPath/update.ps1
    $AccessRule = New-Object System.Security.AccessControl.FileSystemAccessRule($ENV:USERNAME, "FullControl", "Allow")
    $acl.SetAccessRule($AccessRule)
    $acl | Set-Acl $commonStartUpPath/update.ps1

    #endregion Update Script
}

#endregion CUSTOMIZATION