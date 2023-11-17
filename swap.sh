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
if [[ $EUID -ne 0 ]]; then
  if [[ $(sudo -n true 2>/dev/null) ]]; then
    echo "This Script Will be Run with sudo Privileges."
  else
    echo "This Script Must be Run with sudo Privileges."
    echo "Please Enter Root Password."
    su root
  fi
fi
fallocate -l 1G /swapfile
dd if=/dev/zero of=/swapfile bs=1024 count=1048576
chmod 600 /swapfile
mkswap /swapfile
swapon /swapfile
sed -i '$ /swapfile swap swap defaults 0 0' /etc/fstab
swapon --show
free -h
