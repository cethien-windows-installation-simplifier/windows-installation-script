$json = "./data.json"
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

$selectedprofile = $data.install_profiles[$response].name
Write-Host ">> Installing files from profile" -NoNewline
Write-Host ""$selectedprofile -ForegroundColor Green
Write-Host "`r"

# execute commands with selected profiles
foreach ($app in $data.apps) {
    if ($app.install_profiles -contains $selectedprofile) {        
        Write-Host ">> Installing" -NoNewline
        # Write-Host ""$app.file_type -ForegroundColor Green -NoNewline
        Write-Host ""$app.name -ForegroundColor Cyan -NoNewline 
        Write-Host " from" -NoNewline
        Write-Host ""$app.download_source -ForegroundColor Yellow
        Write-Host "`r"
        # $app.install_powershell_command | Invoke-Expression
    }
}

Write-Host "All Done! have fun :3" -ForegroundColor Magenta