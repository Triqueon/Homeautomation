#! /bin/bash

curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
rm get-docker.sh
sudo apt-get install docker-compose
sudo systemctl enable docker
sudo systemctl start docker

CURRENT_USER=$(whoami)
sudo usermod -a -G docker $CURRENT_USER
echo "Please log out and back in to update your user group.\n"
