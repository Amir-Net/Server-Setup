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
system_update() {
  dialog --title "System Update and Cleanup" --yesno "This operation will update your system and remove unnecessary packages. Do you want to proceed?" 10 60
  response=$?
  
  if [ $response -eq 0 ]; then
    sudo apt update -y
    sudo apt upgrade -y
    sudo apt autoremove -y
    sudo apt autoclean -y
    sudo apt clean -y

    dialog --msgbox "System updates and cleanup completed." 10 60
  else
    dialog --msgbox "System updates and cleanup operation canceled." 10 60
  fi
}
