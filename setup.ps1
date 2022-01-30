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


Write-Host "Running main Installation..."
RunFromRaw -FileName "install.ps1"
Write-Host "Main Installation done!"

ReloadPath

Write-Host "Running customization..."
RunFromRaw -FileName "customize.ps1"
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

