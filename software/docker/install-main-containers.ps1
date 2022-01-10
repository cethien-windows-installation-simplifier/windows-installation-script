# create proxy network
docker network create proxy

# Proxy
Invoke-WebRequest `
    -Uri "https://raw.githubusercontent.com/Cethien/windows-install-scripts/main/software/docker/compose/docker-compose.proxy.yml" `
    -OutFile ./docker-compose.proxy.yml
docker compose -p "proxy-manager" -f "docker-compose.proxy.yml" up -d

# Portainer

Invoke-WebRequest `
    -Uri "https://raw.githubusercontent.com/Cethien/windows-install-scripts/main/software/docker/compose/docker-compose.portainer.yml" `
    -OutFile ./docker-compose.portainer.yml
docker compose -p "portainer" -f "docker-compose.portainer.yml" up -d