#! /bin/bash

set -ue

PARTITION="/dev/sda1"
cwd=$(pwd)

sudo apt-get install cryptsetup
sudo modprobe dm-crypt sha256 aes
sudo cryptsetup --verify-passphrase luksFormat $PARTITION -c aes -s 256 -h sha256
sudo cryptsetup luksOpen $PARTITION data
sudo mkfs -t ext4 -m 1 /dev/mapper/data
sudo mount /dev/mapper/data $cwd/data
sudo mkdir /etc/.crypto
sudo dd if=/dev/urandom of=/etc/.crypto/cr_crypto.keyfile bs=1024 count=4
sudo chown root:root /etc/.crypto/*
sudo chmod 400 /etc/.crypto/*
sudo cryptsetup luksAddKey $PARTITION /etc/.crypto/cr_crypto.keyfile
echo 'data /dev/sda1 /etc/.crypto/cr_crypto.keyfile luks' | sudo tee -a /etc/crypttab
echo "/dev/mapper/data $cwd/data ext4 defaults,rw 0 0" | sudo tee -a /etc/fstab
