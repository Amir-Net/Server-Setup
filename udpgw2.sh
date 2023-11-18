#!/bin/bash
# -----------------------------------------------------------------------------
# Description: This script automates the setup and configuration of various
#              utilities and services on a Linux server for a secure and
#              optimized environment.
#
# Author: BabyBoss
# GitHub: https://github.com/Amir-Net/
#
# Disclaimer: This script is provided for educational and informational
#             purposes only. Use it responsibly and in compliance with all
#             applicable laws and regulations.
#
# Note: Make sure to review and understand each section of the script before
#       running it on your system. Some configurations may require manual
#       adjustments based on your specific needs and server setup.
# -----------------------------------------------------------------------------
# Check for sudo privileges
if [[ $EUID -ne 0 ]]; then
  if [[ $(sudo -n true 2>/dev/null) ]]; then
    echo "This script will be run with sudo privileges."
  else
    echo "This script must be run with sudo privileges."
    exit 1
  fi
fi
clear

# setup udpgw
wget -O /usr/bin/badvpn-udpgw "https://github.com/Amir-Net/Server-Setup/raw/main/badvpn-udpgw"
if [ "$OS" == "x86_64" ]; then
wget -O /usr/bin/badvpn-udpgw "https://github.com/Amir-Net/Server-Setup/raw/main/badvpn-udpgw64"
fi
wget -O /bin/badvpn-udpgw "https://github.com/Amir-Net/Server-Setup/raw/main/badvpn-udpgw"
if [ "$OS" == "x86_64" ]; then
wget -O /bin/badvpn-udpgw "https://github.com/Amir-Net/Server-Setup/raw/main/badvpn-udpgw64"
fi

# port BadVPN 7300
sed -i '$ i\screen -dmS udpvpn /bin/badvpn-udpgw --listen-addr 127.0.0.1:7300 --max-clients 1000 --max-connections-for-client 10
' /etc/rc.local

# permission
chmod +x /usr/bin/badvpn-udpgw
chmod +x /bin/badvpn-udpgw
chmod +x /etc/rc.local

# active badvpn 7300
screen -dmS udpvpn /bin/badvpn-udpgw --listen-addr 127.0.0.1:7300 --max-clients 1000 --max-connections-for-client 10
systemctl enable rc-local
systemctl start rc-local.service
systemctl status rc-local.service
