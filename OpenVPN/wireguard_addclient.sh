#!/bin/bash
set -e

umask 077
wg genkey | tee peer_private.key | wg pubkey > peer_public.key

PRIVATE_KEY=`sudo cat peer_private.key`
PUBLIC_KEY=`sudo cat peer_public.key`

sed 's%<PRIVATE_KEY>%'${PRIVATE_KEY}'%' client_conf.template > client.conf

echo "Please enter device IP number (2-254):\n"
read CLIENT_IP

echo "[Peer]
PublicKey = ${PUBLIC_KEY}
AllowedIPs = 10.42.42.${CLIENT_IP}/32" | sudo tee -a /etc/wireguard/wg0.conf
cat client.conf | qrencode -t ansiutf8