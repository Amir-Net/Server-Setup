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

# read on-login users
  read -p  "Enter your usernames (comma-separated, e.g. A,B):" user_names
    if [ -n "$user_names" ]; then
    IFS=',' read -ra ports_array <<< "$user_names"
    for port in "${ports_array[@]}"; do
      sudo adduser "$port" --shell /usr/sbin/nologin
    done
  fi
  unset ufw_ports
  # Add names to the user

