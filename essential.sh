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

# System Preparation
apt update
apt upgrade
apt autoremove
apt autoclean
apt clean

# System Installation
apt install -y sudo
apt install -y wget
apt install -y curl
apt install -y git
apt install -y ufw
apt install -y cron
apt install -y htop
apt install -y zip
apt install -y unzip
apt install -y dialog
apt install -y net-tools
apt install -y certbot
apt install -y fail2ban
apt install -y screen
apt install -y stunnel4
apt install -y openssl
apt install -y resolvconf
apt install -y build-essential
apt install -y software-properties-common
