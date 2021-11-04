rem Windows Script to install some stuff so my desktop looks pretty

rem Rainmeter
winget install -e --id Rainmeter.Rainmeter

rem Spicetify
powershell.exe -command "& Invoke-WebRequest -UseBasicParsing \"https://raw.githubusercontent.com/khanhas/spicetify-cli/master/install.ps1\" | Invoke-Expression"

spicetify
spicetify config extensions webnowplaying.js
spicetify config custom_apps new-releases
spicetify config inject_css 0 replace_colors 0
spicetify backup apply
