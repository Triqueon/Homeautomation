#! /bin/bash

sudo apt-get install docker docker-compose
sudo systemctl enable docker
sudo systemctl start docker

CURRENT_USER=$(whoami)
sudo usermod -a -G docker $CURRENT_USER
echo "Please log out and back in to update your user group.\n"
