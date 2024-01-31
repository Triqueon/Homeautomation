#! /bin/sh

set -eu

sudo systemctl disable systemd-resolved
sudo systemctl stop system-resolved
rm /etc/resolv.conf

echo "Please put dns=default in the [main] section of your /etc/NetworkManager/NetworkManager.conf and restart NetworkManager"
