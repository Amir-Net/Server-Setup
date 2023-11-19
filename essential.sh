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
sudo apt update -y
sudo apt upgrade -y
sudo apt autoremove -y
sudo apt autoclean -y
sudo apt clean -y

# System Installation
sudo apt install -y sudo
sudo apt install -y wget
sudo apt install -y curl
sudo apt install -y git
sudo apt install -y ufw
sudo apt install -y cron
sudo apt install -y htop
sudo apt install -y zip
sudo apt install -y unzip
sudo apt install -y xclip
sudo apt install -y net-tools
sudo apt install -y certbot
sudo apt install -y fail2ban
sudo apt install -y screen
sudo apt install -y openssl
sudo apt install -y resolvconf
sudo apt install -y build-essential
