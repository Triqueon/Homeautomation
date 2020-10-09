#! /bin/bash

# solve docker memory warning issues.
#TODO Only do this on raspbian
#if [[ ! grep -q "cgroup_enable=memory" /boot/cmdline.txt]]
#  echo 'cgroup_enable=memory cgroup_memory=1 swapaccount=1' | sudo tee -a '/boot/cmdline.txt'
#fi

#check for armv7 architecture, not supported by default mariadb or mysql image as of 9/10/2020
#substitute community image in this case
DB_IMAGE="mariadb"
ARCHITECTURE=$(sudo docker info | grep "Architecture: " | sed 's/^.*: //')
if [[ $ARCHITECTURE == armv7* ]]; then
  DB_IMAGE="jsurf/rpi-mariadb"
fi
export DB_IMAGE_NAME=$DB_IMAGE

docker-compose up -d --build

##Setup zigbee2mqtt
# Setup Node.js repository
sudo curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -

# NOTE 1: If you see the message below please follow: https://gist.github.com/Koenkk/11fe6d4845f5275a2a8791d04ea223cb.
# ## You appear to be running on ARMv6 hardware. Unfortunately this is not currently supported by the NodeSource Linux distributions. Please use the 'linux-armv6l' binary tarballs available directly from nodejs.org for Node.js 4 and later.
# IMPORTANT: In this case instead of the apt-get install mentioned below; do: sudo apt-get install -y git make g++ gcc

# NOTE 2: On x86, Node.js 10 may not work. It's recommended to install an unofficial Node.js 12 build which can be found here: https://unofficial-builds.nodejs.org/download/release/ (e.g. v12.16.3)

# Install Node.js;
sudo apt-get install -y nodejs git make g++ gcc

# Verify that the correct nodejs and npm (automatically installed with nodejs)
# version has been installed
node --version  # Should output v12.X or v10.X
npm --version  # Should output 6.X

# Clone Zigbee2MQTT repository
sudo git clone https://github.com/Koenkk/zigbee2mqtt.git /opt/zigbee2mqtt
sudo chown -R pi:pi /opt/zigbee2mqtt

# Install dependencies (as user "pi")
cd /opt/zigbee2mqtt
npm ci