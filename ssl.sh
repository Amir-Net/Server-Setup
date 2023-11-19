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

  # install certificate
  sudo apt install -y certbot
  echo "SSL/TLS Certificates by Letsencrypt"
  read -p "Enter your email:" email
  read -p "Enter your domain (e.g., sub.domain.com):" domain
  if [ -n "$email" ] && [ -n "$domain" ]; then
  sudo certbot certonly --standalone --preferred-challenges http --agree-tos --email "$email" -d "$domain"
  echo "SSL/TLS certificates obtained successfully for $domain in /etc/letsencrypt/live."
  unset email
  unset domain
  else
  echo "Both email and domain are required to obtain SSL certificates."
  fi
