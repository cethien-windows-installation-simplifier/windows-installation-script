# Windows Script to install some stuff so my desktop looks pretty

# Corsair iCUE
winget install -e --id Corsair.iCUE.4

# Rainmeter
winget install -e --id Rainmeter.Rainmeter

# Spicetify
Invoke-WebRequest -UseBasicParsing "https://raw.githubusercontent.com/khanhas/spicetify-cli/master/install.ps1" | Invoke-Expression

# install spicetify expensions & apps
spicetify
spicetify config extensions webnowplaying.js
spicetify config custom_apps new-releases
spicetify config inject_css 0 replace_colors 0
spicetify backup apply
