#!/bin/bash

# Stoppe und lösche alle Container nur, wenn sie existieren
if [ "$(docker ps -a -q)" ]; then
    echo "Stopping all running containers..."
    docker stop $(docker ps -a -q)

    echo "Removing all containers..."
    docker rm $(docker ps -a -q)
else
    echo "No containers to stop or remove."
fi

# Lösche Docker-Images nur, wenn welche existieren
if [ "$(docker images -q)" ]; then
    echo "Removing all Docker images..."
    docker rmi $(docker images -q)
else
    echo "No Docker images to remove."
fi

# Baue das neue Docker-Image
echo "Building the Docker image for pdf-file-server..."
docker build -t pdf-file-server .

# Starte den neuen Container
echo "Running the pdf-file-server container on port 8080..."
docker run -d -p 8080:80 --name pdf-file-server --mount type=bind,source=./logs,target=/var/log/nginx pdf-file-server
docker run -d -v ./logs:/logs -v ./webalizer:/webalizer -e LOGPREFIX=access -e INTERVAL=3600 -e VERBOSE=0 toughiq/webalizer:latest
echo "Process completed successfully."
