$commonStartUpPath = [Environment]::GetFolderPath("CommonStartup")

function ReloadPath {
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path", "User")
    Write-Host 'PATH refreshed'
}

function RunFromRaw {
    param (
        [string]$FileName
    )

    Invoke-WebRequest "https://raw.githubusercontent.com/Cethien/windows-install-scripts/main/$FileName" | Invoke-Expression
}

$title = "Hi!"
$msg = "Before we start, do you wish to install your quick basic workspace stuff`
or make a full installation for every autistic setting & customization?"
$options = '&Quick', '&Full'
$default = 0

do {
    $response = $Host.UI.PromptForChoice($title, $msg, $options, $default)
} until ($response -eq 0 -or 1)

Write-Host "Running Installation..."
RunFromRaw -FileName "install-main.ps1"

if ($response -eq 1) {
    
}

Write-Host "Installation done!"

if ($response -eq 1) {
    
    ReloadPath

    Write-Host "Running customization..."
    RunFromRaw -FileName "run-customize.ps1"
    Write-Host "Customization done!"

    #region Update Script

    #Create Update Script into Startup Folder
    $content = "Invoke-WebRequest `"https://raw.githubusercontent.com/Cethien/windows-install-scripts/main/update.ps1`" | Invoke-Expression"
    $item = "$commonStartUpPath/update.ps1"
    New-Item $item
    Set-Content -Path $item -Value $content

    #Access so you dont need admin to run it
    $acl = Get-Acl $commonStartUpPath/update.ps1
    $AccessRule = New-Object System.Security.AccessControl.FileSystemAccessRule($ENV:USERNAME, "FullControl", "Allow")
    $acl.SetAccessRule($AccessRule)
    $acl | Set-Acl $commonStartUpPath/update.ps1

    #endregion Update Script
}