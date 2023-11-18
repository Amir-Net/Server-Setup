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

    # Add lines to /etc/security/limits.conf
    echo "* soft nofile 51200" | sudo tee -a /etc/security/limits.conf
    echo "* hard nofile 51200" | sudo tee -a /etc/security/limits.conf
    # Run ulimit command
    ulimit -n 51200
    
    # Add lines to /etc/ufw/sysctl.conf
    sysctl_settings=(
      "fs.file-max = 51200"
      "net.core.rmem_max = 67108864"
      "net.core.wmem_max = 67108864"
      "net.core.netdev_max_backlog = 250000"
      "net.core.somaxconn = 4096"
      "net.ipv4.tcp_syncookies = 1"
      "net.ipv4.tcp_tw_reuse = 1"
      "net.ipv4.tcp_tw_recycle = 0"
      "net.ipv4.tcp_fin_timeout = 30"
      "net.ipv4.tcp_keepalive_time = 1200"
      "net.ipv4.ip_local_port_range = 10000 65000"
      "net.ipv4.tcp_max_syn_backlog = 8192"
      "net.ipv4.tcp_max_tw_buckets = 5000"
      "net.ipv4.tcp_fastopen = 3"
      "net.ipv4.tcp_mem = 25600 51200 102400"
      "net.ipv4.tcp_rmem = 4096 87380 67108864"
      "net.ipv4.tcp_wmem = 4096 65536 67108864"
      "net.ipv4.tcp_mtu_probing = 1"
      "net.ipv4.tcp_congestion_control = hybla"
    )
    for setting in "${sysctl_settings[@]}"; do
      echo "$setting" | sudo tee -a /etc/ufw/sysctl.conf
    done
    sudo sysctl -p
