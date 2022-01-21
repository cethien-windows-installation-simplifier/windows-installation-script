function ReloadPath {
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path", "User")
    Write-Host 'PATH refreshed'
}

# enable WSL and upgrade to WSL 2
wsl --install
wsl --set-default-version 2
# install Ubuntu in WSL
wsl.exe --install -d "Ubuntu"
wsl --setdefault "Ubuntu"

# Docker
winget install -e --id Docker.DockerDesktop

#================================
# POST-INSTALL
#================================

ReloadPath

# create proxy network
docker network create proxy

# Proxy Manager
Invoke-WebRequest `
    -Uri "https://raw.githubusercontent.com/Cethien/windows-install-scripts/main/docker/compose/docker-compose.proxymanager.yml" `
    -OutFile ./docker-compose.proxymanager.yml
docker compose -p "proxy-manager" -f "docker-compose.proxymanager.yml" up -d

# Portainer
Invoke-WebRequest `
    -Uri "https://raw.githubusercontent.com/Cethien/windows-install-scripts/main/docker/compose/docker-compose.portainer.yml" `
    -OutFile ./docker-compose.portainer.yml
docker compose -p "portainer" -f "docker-compose.portainer.yml" up -d