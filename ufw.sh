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
# firewall Preparation
  sudo ufw default deny incoming
  sudo ufw default allow outgoing
  
  # Prompt the user for the SSH port to allow
  read -p "SSH Port-Enter the SSH port to allow (default is 22):" ssh_port
  
  # Check if the SSH port is empty and set it to default (22) if not provided
  if [ -z "$ssh_port" ]; then
    ssh_port=22
  fi
  
  # Allow SSH port
  sudo ufw allow "$ssh_port/tcp"
  unset ssh_port
  
  # Prompt the user for additional ports to open
  read -p  "Additional Ports-Enter additional ports to open (comma-separated, e.g., 80,443):" ufw_ports
  
  # Allow additional ports specified by the user
  if [ -n "$ufw_ports" ]; then
    IFS=',' read -ra ports_array <<< "$ufw_ports"
    for port in "${ports_array[@]}"; do
      sudo ufw allow "$port/tcp"
    done
  fi
  unset ufw_ports
  
  # Enable UFW to start at boot
  sudo ufw enable
  sudo systemctl enable ufw
