# create proxy network
docker network create proxy

### PROXY
## COMPOSE
#Invoke-WebRequest --Uri "https://raw.githubusercontent.com/Cethien/windows-install-scripts/main/software/docker/compose/docker-compose.proxy.yml" `
#--OutFile ./docker-compose.proxy.yml
#docker compose --name "proxy-manager" -f "docker-compose.proxy.yml" up -d

# create volumes
docker volume create npmdata
docker volume create npmle

## create container
docker run -d `
    --name=nginx-proxy-manager `
    -p 8080:80 `
    -p 81:81 `
    -p 443:443 `
    -v data:/data `
    -v npmle:/etc/letsencrypt `
    jc21/nginx-proxy-manager:latest

# start proxy UI
Start-Process "http://localhost:81"

## PORTAINER
## COMPOSE
#Invoke-WebRequest --Uri "https://raw.githubusercontent.com/Cethien/windows-install-scripts/main/software/docker/compose/docker-compose.portainer.yml" `
#--OutFile ./docker-compose.portainer.yml
#docker compose --name "portainer" -f "docker-compose.portainer.yml" up -d

# create Portainer volume
docker volume create portainer_data

# create container
docker run -d `
    --name portainer `
    --restart=always `
    --network="proxy" `
    -v /var/run/docker.sock:/var/run/docker.sock `
    -v portainer_data:/data `
    cr.portainer.io/portainer/portainer-ce:2.9.3