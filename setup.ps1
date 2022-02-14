#region FUNCTIONS
function CreateDirectory {
    param (
        [string]$Path,
        [string]$Name
    )  
    return New-Item -Path $Path -Name $Name -ItemType Directory
}

function RunFile {
    param (
        [string]$FileName
    )

    Invoke-WebRequest "https://raw.githubusercontent.com/cethien-windows-installation-simplifier/windows-install-scripts/main/$FileName" | Invoke-Expression
}

function ReloadPath {
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path", "User")
    Write-Host 'PATH refreshed'
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

#region INSTALLATION

$json = $(Invoke-WebRequest "https://raw.githubusercontent.com/cethien-windows-installation-simplifier/windows-installation-data-manager/main/create-data.ps1" | Invoke-Expression)
$files = $json | ConvertFrom-Json

# prompt for installation options
$title = "Hi!"
$msg = "Before we start, do you wish to install your quick basic workspace stuff`
or make a full installation for every autistic programm, setting & customization?"
$options = '&Basic', '&Full'
$default = 0

do {
    $response = $Host.UI.PromptForChoice($title, $msg, $options, $default)
} until ($response -eq 0 -or 1)



Write-Host "`nRunning Installation...`n"

foreach ($item in $files) {

    switch ($response) {
        0 { $cond = $item.InstallationCategory -eq "basic" }
        1 { $cond = $item.InstallationCategory -eq "basic" -or "full" }
    }

    if ($cond) {        
        switch ($item.Type) {
            "WebFile" {
                Write-Host "Todo: WEBINSTALLATION + ZIP HANDLING"
            }
            "WingetFile" {
                if ($item.InteractiveMode = $true) {
                    winget install -e --id $item.Id -i
                }
                else {
                    winget install -e --id $item.Id
                }
            }
        }
    }   
}

Write-Host "`nInstallation done!`n"

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
    
    Write-Host "`nRunning customization...`n"
    RunFile -FileName "run-customize.ps1"
    Write-Host "`nCustomization done!`n"
    
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