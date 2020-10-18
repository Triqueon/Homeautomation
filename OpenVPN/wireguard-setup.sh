#! /bin/bash
set -e

# install kernel headers and wireguard if not already present
if ! which wg > /dev/null; then
  sudo apt-get install raspberrypi-kernel-headers
  echo "deb http://httpredir.debian.org/debian buster-backports main contrib non-free" | sudo tee --append /etc/apt/sources.list.d/debian-backports.list
  wget -O - https://ftp-master.debian.org/keys/archive-key-$(lsb_release -sr).asc | sudo apt-key add -
  sudo apt update
  sudo apt install wireguard qrencode
  sudo reboot
fi

#generate keys for server and one client
umask 077
wg genkey | tee server_private.key | wg pubkey > server_public.key
PRIVATE_KEY=`sudo cat server_private.key`
PUBLIC_KEY=`sudo cat server_public.key`

#enable IPv4 forwarding
sudo perl -pi -e 's/#{1,}?net.ipv4.ip_forward ?= ?(0|1)/net.ipv4.ip_forward = 1/g' /etc/sysctl.conf

echo "Please enter the domain under which the VPN server will be available:\n"
read $DOMAIN

sed "s/<PRIVATE_KEY>/${PRIVATE_KEY}/" wg0.conf | sudo tee /etc/wireguard/wg0.conf
sed -i "s/<PUBLIC_KEY>/${PUBLIC_KEY}/" client_conf.template
sed -i "s/<DOMAIN>/${DOMAIN}/" client_conf.template

sudo systemctl enable wg-quick@wg0
sudo systemctl start wg-quick@wg0

sudo chown -R root:root /etc/wireguard/
sudo chmod -R og-rwx /etc/wireguard/*