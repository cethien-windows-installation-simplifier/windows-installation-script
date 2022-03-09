$json = "./data.json"
$updateFile = "./update.ps1"
$data = Get-Content $json | ConvertFrom-Json

# select installation profile
$title = "Hi " + $data.user_name + "!"
$msg = "Select the profile you want to use:"
$options = $(
    foreach ($profile in $data.install_profiles) {
        "&" + $profile.name
    }
)
$default = $(0..($data.install_profiles.Count - 1) | Where-Object { $data.install_profiles[$_].is_default -eq "true" })

do {
    $response = $Host.UI.PromptForChoice($title, $msg, $options, $default)
} until ($response -in 0..($data.install_profiles.Count - 1))

$selectedprofile = $data.install_profiles[$response]
Write-Host "> Installing files from profile" -NoNewline
Write-Host ""$selectedprofile.name -ForegroundColor Green
Write-Host "`r"

if ($selectedprofile.generate_update_script) {   
    if (!(Test-Path -Path $updateFile -PathType Leaf)) {
        New-Item $updateFile 
        Write-Host "Created Update File!" -ForegroundColor Yellow
    }
    Clear-Content $updateFile
}

foreach ($app in $data.apps) {
    if ($app.install_profiles -contains $selectedprofile.name) {
        # install       
        Write-Host ">> Installing" -NoNewline
        # Write-Host ""$app.file_type -ForegroundColor Green -NoNewline
        Write-Host ""$app.name -ForegroundColor Cyan -NoNewline 
        Write-Host " from" -NoNewline
        Write-Host ""$app.download_source -ForegroundColor Yellow

        $app.powershell_command_install | Invoke-Expression

        if (($app.do_update) -and (Test-Path -Path $updateFile -PathType Leaf)) {                
            Add-Content $updateFile $app.powershell_command_update
        }        
    }
}

Write-Host "All Done! have fun :3" -ForegroundColor Magenta