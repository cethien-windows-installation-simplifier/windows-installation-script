#region Windows Terminal

# set the new powershell as default profile
# hide Windows Powershell in profiles
# hide Azure Terminal in profiles
# hide Git bash in profiles
# config powershell to load oh-my-posh's powerlevel10k_rainbow on startup
Start-Transcript -Path $PROFILE
Write-Output "Clear-Host"
Write-Output "oh-my-posh --init --shell pwsh --config "`$$env:localappdata\Programs\oh-my-posh\themes\powerlevel10k_rainbow.omp.json" | Invoke-Expression"

#endregion Windows Terminal

# install spicetify expensions & apps
spicetify
spicetify config extensions webnowplaying.js
spicetify config custom_apps new-releases
spicetify config inject_css 0 replace_colors 0
spicetify backup apply