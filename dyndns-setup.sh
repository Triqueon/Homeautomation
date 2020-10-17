#! /bin/bash

sudo apt-get install wget

echo "Enter Zonomi API Key"

read Z_API_KEY

echo "Enter Domain Name"

read DOMAIN_NAME

(crontab -l 2>/dev/null; echo "*/30 * * * * wget 'https://zonomi.com/app/dns/dyndns.jsp?host=${DOMAIN_NAME}&api_key=${Z_API_KEY}'") | crontab -