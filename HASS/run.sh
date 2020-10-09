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
echo $DB_IMAGE

docker-compose up -d --build