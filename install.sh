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
echo "This Script Will be Run With Root Privileges."
echo "Please Enter Root Password."
su root
apt update
apt upgrade
apt autoremove
apt autoclean
apt clean
add-apt-repository universe
apt install sudo
apt install wget
apt install curl
apt install git
apt install ufw
apt install cron
apt install htop
apt install zip
apt install unzip
apt install xclip
apt install dialog
apt install net-tools
apt install certbot
apt install fail2ban
apt install screen
apt install python3
apt install python3-pip
apt install stunnel4
apt install nginx
apt install openssl
apt install resolvconf
apt install snap
apt install docker
apt install composer
apt-get install software-properties-common
