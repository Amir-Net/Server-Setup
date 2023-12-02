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

# 1. Function to install essential packages
system_update() {
  dialog --title "Install Essential Packages" --yesno "Do you want to proceed?" 10 60
  response=$?
  if [ $response -eq 0 ]; then
  sudo apt install -y curl && sudo bash -c "$(curl -Lfo- https://raw.githubusercontent.com/Amir-Net/Server-Setup/main/essential.sh)"  
    dialog --msgbox "Essential packages have been installed." 10 60
  else
    dialog --msgbox "Installation of Essential packages canceled." 10 60
  fi
}

# 2. Function to install advanced packages
install_essential_packages() {
  dialog --title "Install Advanced Packages" --yesno "Do you want to proceed?" 10 60
  response=$?
  if [ $response -eq 0 ]; then
  sudo apt install -y curl && sudo bash -c "$(curl -Lfo- https://raw.githubusercontent.com/Amir-Net/Server-Setup/main/advanced.sh)"
    dialog --msgbox "Advanced packages have been installed." 10 60
  else
    dialog --msgbox "Installation of Advanced packages canceled." 10 60
  fi
}

# 3. Function to install Speedtest
install_speedtest() {
  dialog --title "Install Speedtest" --yesno "Do you want to install Speedtest?" 10 60
  response=$?
  if [ $response -eq 0 ]; then
  sudo apt install -y curl && sudo bash -c "$(curl -Lfo- https://raw.githubusercontent.com/Amir-Net/Server-Setup/main/speed.sh)"
    dialog --msgbox "Speedtest has been installed successfully. You can now run it by entering 'speedtest' in the terminal." 10 60
  else
    dialog --msgbox "Skipping installation of Speedtest." 10 60
  fi
}

# 4. Function to create a SWAP file
create_swap_file() {
  dialog --title "Create SWAP File" --yesno "Do you want to create a SWAP file?" 10 60
  response=$?
  if [ $response -eq 0 ]; then
  sudo apt install -y curl && sudo bash -c "$(curl -Lfo- https://raw.githubusercontent.com/Amir-Net/Server-Setup/main/essential.sh)"
    dialog --msgbox "SWAP file created successfully." 10 60
  else
    dialog --msgbox "Skipping SWAP file creation." 10 60
  fi
}

# 5. Function to enable BBR
enable_bbr() {
  dialog --title "Enable BBR" --yesno "Do you want to enable BBR congestion control?\n\nEnabling BBR while Hybla is enabled can lead to conflicts. Are you sure you want to proceed?" 12 60
  response=$?
  if [ $response -eq 0 ]; then
  sudo apt install -y curl && sudo bash -c "$(curl -Lfo- https://raw.githubusercontent.com/Amir-Net/Server-Setup/main/bbr.sh)"
    dialog --msgbox "BBR congestion control has been enabled successfully." 10 60
  else
    dialog --msgbox "BBR configuration skipped." 10 60
  fi
}

# 6. Function to enable Hybla
enable_hybla() {
  dialog --title "Enable Hybla" --yesno "Do you want to enable Hybla congestion control?\n\nEnabling Hybla while BBR is enabled can lead to conflicts. Are you sure you want to proceed?" 12 60
  response=$?
  if [ $response -eq 0 ]; then
  sudo apt install -y curl && sudo bash -c "$(curl -Lfo- https://raw.githubusercontent.com/Amir-Net/Server-Setup/main/hybla.sh)"
    dialog --msgbox "Hybla congestion control has been enabled successfully." 10 60
  else
    dialog --msgbox "Hybla configuration skipped." 10 60
  fi
}

# 7. Function to enable and configure Cron
enable_and_configure_cron() {
  # Prompt for automatic updates
  dialog --title "Enable Automatic Updates" --yesno "Would you like to enable automatic updates? This will schedule system updates every night at 00:30 +3:30 GMT." 10 60
  update_response=$?

  # Prompt for scheduling system restarts
  dialog --title "Schedule System Restarts" --yesno "Would you like to schedule system restarts? This will schedule system restarts every night at 01:30 +3:30 GMT." 10 60
  restart_response=$?

  if [ $update_response -eq 0 ]; then
    # Configure automatic updates using Cron
    echo "00 22 * * * /usr/bin/apt-get update && /usr/bin/apt-get upgrade -y && /usr/bin/apt-get autoremove -y && /usr/bin/apt-get autoclean -y && /usr/bin/apt-get clean -y" | sudo tee -a /etc/crontab
    updates_message="Automatic updates have been enabled and scheduled."

    if [ $restart_response -eq 0 ]; then
      # Schedule system restarts using Cron
      echo "30 22 * * * /sbin/shutdown -r" | sudo tee -a /etc/crontab
      restarts_message="System restarts have been scheduled."
    else
      restarts_message="System restart scheduling skipped."
    fi

    # Display appropriate messages based on user choices
    dialog --msgbox "$updates_message\n$restarts_message" 10 60
  else
    if [ $restart_response -eq 0 ]; then
      # Schedule system restarts without automatic updates
      echo "30 22 * * * /sbin/shutdown -r" | sudo tee -a /etc/crontab
      dialog --msgbox "System restarts have been scheduled without automatic updates." 10 60
    else
      dialog --msgbox "Cron configuration skipped." 10 60
    fi
  fi
}

# 8. Function to Install Tweaker
install_tweaker() {
  dialog --title "Enable Tweaker" --yesno "Do you want to enable Tweaker?\n\nEnabling Tweaker can lead to conflicts. Are you sure you want to proceed?" 12 60
  response=$?
  if [ $response -eq 0 ]; then
  sudo apt install -y curl && sudo bash -c "$(curl -Lfo- https://raw.githubusercontent.com/Amir-Net/Server-Setup/main/tweaker.sh)"
    dialog --msgbox "Tweaker has been enabled successfully." 10 60
  else
    dialog --msgbox "Tweaker configuration skipped." 10 60
  fi
}

# 9. Function to obtain SSL certificates
obtain_ssl_certificates() {
  apt install -y certbot
  dialog --title "Obtain SSL Certificates" --yesno "Do you want to Get SSL Certificates?" 10 60
  response=$?
  if [ $response -eq 0 ]; then
    dialog --title "SSL Certificate Information" --inputbox "Enter your email:" 10 60 2> email.txt
    email=$(cat email.txt)
    dialog --title "SSL Certificate Information" --inputbox "Enter your domain (e.g., sub.domain.com):" 10 60 2> domain.txt
    domain=$(cat domain.txt)

    if [ -n "$email" ] && [ -n "$domain" ]; then
      sudo certbot certonly --standalone --preferred-challenges http --agree-tos --email "$email" -d "$domain"

      # Wait for the user to press Enter
      read -p "Please Press Enter to continue"

      dialog --msgbox "SSL certificates obtained successfully for $domain in /etc/letsencrypt/live." 10 60
    else
      dialog --msgbox "Both email and domain are required to obtain SSL certificates." 10 60
    fi
  else
    dialog --msgbox "Skipping SSL certificate acquisition." 10 40
  fi

  # Return to the menu
}

# 10. Function to set up Pi-Hole
setup_pi_hole() {
  # Provide information about Pi-Hole and its benefits
  dialog --title "Install Pi-Hole" --yesno "Pi-Hole is a network-wide ad blocker that can improve your online experience by blocking ads at the network level. Do you want to install Pi-Hole?" 12 60
  response=$?

  if [ $response -eq 0 ]; then
    # Install Pi-Hole
    curl -sSL https://install.pi-hole.net | bash

    # Ask if the user wants to change the Pi-Hole web interface password
    dialog --title "Change Pi-Hole Web Interface Password" --yesno "Do you want to change the Pi-Hole web interface password?" 10 60
    response=$?
    if [ $response -eq 0 ]; then
      pihole -a -p
      dialog --msgbox "Pi-Hole web interface password changed successfully." 10 60
    else
      dialog --msgbox "Skipping Pi-Hole web interface password change." 10 40
    fi

    # Ask if the user wants to configure Pi-Hole as a DHCP server
    dialog --title "Configure Pi-Hole as a DHCP Server" --yesno "Do you want to configure Pi-Hole as a DHCP server? This can help manage your local network's IP addresses and improve ad blocking. Note: Ensure that your router's DHCP server is disabled." 12 60
    response=$?
    if [ $response -eq 0 ]; then
      # Provide DHCP configuration instructions here
      dialog --title "Pi-Hole DHCP Configuration" --msgbox "To configure Pi-Hole as a DHCP server, go to the Pi-Hole web interface (http://pi.hole/admin) and navigate to 'Settings' > 'DHCP.' Follow the instructions to enable DHCP and specify the IP range for your local network." 12 80
    else
      dialog --msgbox "Skipping Pi-Hole DHCP server configuration." 10 40
    fi

    # Ask if the user wants to change the Lighttpd port
    if [ -f /etc/lighttpd/lighttpd.conf ]; then
      dialog --title "Change Lighttpd Port" --yesno "If you have installed Pi-Hole, then Lighttpd is listening on port 80 by default. Do you want to change the Lighttpd port?" 10 60
      response=$?
      if [ $response -eq 0 ]; then
        sudo nano /etc/lighttpd/lighttpd.conf
        dialog --msgbox "Lighttpd port changed." 10 60
      else
        dialog --msgbox "Skipping Lighttpd port change." 10 40
      fi
    fi
  else
    dialog --msgbox "Skipping Pi-Hole installation." 10 40
  fi
}

# 11. Function to change SSH port
change_ssh_port() {
  # Provide information about changing SSH port
  dialog --title "Change SSH Port" --msgbox "Changing the SSH port can enhance security by reducing automated SSH login attempts. However, it's essential to choose a port that is not already in use and to update your SSH client configuration accordingly.\n\nPlease consider the following:\n- Choose a port number between 1025 and 49151 (unprivileged ports).\n- Avoid well-known ports (e.g., 22, 80, 443).\n- Ensure that the new port is open in your firewall rules.\n- Update your SSH client configuration to use the new port." 14 80

  # Prompt the user for the new SSH port
  dialog --title "Enter New SSH Port" --inputbox "Enter the new SSH port:" 10 60 2> ssh_port.txt
  new_ssh_port=$(cat ssh_port.txt)

  # Verify that a valid port number is provided
  if [[ $new_ssh_port =~ ^[0-9]+$ ]]; then
    # Remove the '#' comment from the 'Port' line in sshd_config (if present)
    sudo sed -i "/^#*Port/s/^#*Port/Port/" /etc/ssh/sshd_config

    # Update SSH port in sshd_config
    sudo sed -i "s/^Port .*/Port $new_ssh_port/" /etc/ssh/sshd_config

    # Reload SSH service to apply changes
    sudo systemctl reload sshd

    dialog --msgbox "SSH port changed to $new_ssh_port. Ensure that you apply related firewall rules and update your SSH client configuration accordingly." 12 60
  else
    dialog --msgbox "Invalid port number. Please provide a valid port." 10 60
  fi
}

# 12. Function to enable UFW
enable_ufw() {
  # Set UFW defaults
  sudo ufw default deny incoming
  sudo ufw default allow outgoing

  # Prompt the user for the SSH port to allow
  dialog --title "Enable UFW - SSH Port" --inputbox "Enter the SSH port to allow (default is 22):" 10 60 2> ssh_port.txt
  ssh_port=$(cat ssh_port.txt)

  # Check if the SSH port is empty and set it to default (22) if not provided
  if [ -z "$ssh_port" ]; then
    ssh_port=22
  fi

  # Allow SSH port
  sudo ufw allow "$ssh_port/tcp"

  # Prompt the user for additional ports to open
  dialog --title "Enable UFW - Additional Ports" --inputbox "Enter additional ports to open (comma-separated, e.g., 80,443):" 10 60 2> ufw_ports.txt
  ufw_ports=$(cat ufw_ports.txt)

  # Allow additional ports specified by the user
  if [ -n "$ufw_ports" ]; then
    IFS=',' read -ra ports_array <<< "$ufw_ports"
    for port in "${ports_array[@]}"; do
      sudo ufw allow "$port/tcp"
    done
  fi

  # Enable UFW to start at boot
  sudo ufw enable
  sudo systemctl enable ufw

  # Display completion message
  dialog --msgbox "UFW enabled and configured successfully.\nSSH port $ssh_port and additional ports allowed." 12 60
}

# 13. Function to install UDPGW
install_UDPGW() {
  dialog --title "Install & Configure UDPGW" --yesno "Do you want to install and configure UDPGW?" 10 60
  response=$?
  if [ $response -eq 0 ]; then
    sudo apt install -y curl && sudo bash -c "$(curl -Lfo- https://raw.githubusercontent.com/Amir-Net/Server-Setup/main/udpgw.sh)"
    
    # Wait for the user to press Enter
    read -p "Please Press Enter to continue"
    
    dialog --msgbox "UDPGW installed and configured successfully." 10 60
  else
    dialog --msgbox "Skipping installation and configuration of UDPGW." 10 60
  fi
}

# 14 Function to set up WebSite
setup_WebSite() {
  dialog --title "Install & Configure WebSite" --yesno "Do you want to install and configure WebSite?" 10 60
  response=$?
  if [ $response -eq 0 ]; then
    sudo apt install -y curl && sudo bash -c "$(curl -Lfo- https://raw.githubusercontent.com/Amir-Net/Server-Setup/main/website.sh)"
    
    # Wait for the user to press Enter
    read -p "Please Press Enter to continue"
    
    dialog --msgbox "WebSite installed and configured successfully." 10 60
  else
    dialog --msgbox "Skipping installation and configuration of WebSite." 10 60
  fi
}

# 15. Function to WordPress
setup_WordPress() {
  dialog --title "Install & Configure WordPress" --yesno "Do you want to install and configure WordPress?" 10 60
  response=$?
  if [ $response -eq 0 ]; then
    sudo apt install -y curl && sudo bash -c "$(curl -Lfo- https://raw.githubusercontent.com/Amir-Net/Server-Setup/main/wordpress.sh)"
    
    # Wait for the user to press Enter
    read -p "Please Press Enter to continue"
    
    dialog --msgbox "WordPress installed and configured successfully." 10 60
  else
    dialog --msgbox "Skipping installation and configuration of WordPress." 10 60
  fi
}

# 16. Function to setup Repositories
setup_juicity() {
  dialog --title "Setup Repositories" --yesno "Do you want to setup Repositories?" 10 60
  response=$?
  if [ $response -eq 0 ]; then
    sudo apt install -y curl && sudo bash -c "$(curl -Lfo- https://raw.githubusercontent.com/Amir-Net/Server-Setup/main/repositories.sh)"
    read -p "Repositories setup completed. Please Press Enter to continue."
  else
    dialog --msgbox "Skipping Repositories setup." 10 40
  fi

  # Return to the menu
}

# 17. Function to create a non-root SSH user
create_ssh_user() {
  # Ask the user for the username
  dialog --title "Create SSH User" --inputbox "Enter the username for the new SSH user:" 10 60 2> username.txt
  username=$(cat username.txt)

  # Check if the username is empty
  if [ -z "$username" ]; then
    dialog --msgbox "Username cannot be empty. SSH user creation aborted." 10 60
    return
  fi

  # Ask the user for a secure password
  dialog --title "Create SSH User" --passwordbox "Enter a strong password for the new SSH user:" 10 60 2> password.txt
  password=$(cat password.txt)

  # Check if the password is empty
  if [ -z "$password" ]; then
    dialog --msgbox "Password cannot be empty. SSH user creation aborted." 10 60
    return
  fi

  # Create the user with the specified username
  sudo useradd -m -s /bin/bash "$username"

  # Set the user's password securely
  echo "$username:$password" | sudo chpasswd

  # Display the created username and password to the user
  dialog --title "SSH User Created" --msgbox "SSH user '$username' has been created successfully.\n\nUsername: $username\nPassword: $password" 12 60
}

# 18. Function to install and configure WARP Proxy
install_configure_warp_proxy() {
  dialog --title "Install & Configure WARP Proxy" --yesno "Do you want to install and configure WARP Proxy?" 10 60
  response=$?
  if [ $response -eq 0 ]; then
    bash <(curl -fsSL git.io/warp.sh) proxy
    
    # Wait for the user to press Enter
    read -p "Please Press Enter to continue"
    
    dialog --msgbox "WARP Proxy installed and configured successfully." 10 60
  else
    dialog --msgbox "Skipping installation and configuration of WARP Proxy." 10 60
  fi
}

# 19. Function to reboot the system
reboot_system() {
  dialog --title "Reboot System" --yesno "Do you want to reboot the system?" 10 60
  response=$?
  if [ $response -eq 0 ]; then
    dialog --infobox "Rebooting the system..." 5 30
    sleep 2  # Display the message for 2 seconds before rebooting
    sudo reboot
  else
    dialog --msgbox "System reboot canceled." 10 40
  fi
}

# 20. Function to exit the script
exit_script() {
  clear  # Clear the terminal screen for a clean exit
  echo "Exiting the script. Goodbye!"
  exit 0  # Exit with a status code of 0 (indicating successful termination)
}

# Main menu options using dialog
while true; do
  choice=$(dialog --clear --backtitle "FreeIRAN v.1.3.0 - Main Menu" --title "Main Menu" --menu "Choose an option:" 18 60 15 \
    1 "Install Essential Packages" \
    2 "Install Advanced Packages" \
    3 "Install Speedtest" \
    4 "Create Swap File" \
    5 "Enable BBR" \
    6 "Enable Hybla" \
    7 "Schedule Automatic Updates & ReStarts" \
    8 "Install Multiprotocol VPN Panels" \
    9 "Obtain SSL Certificates" \
    10 "Setup Pi-Hole" \
    11 "Change SSH Port" \
    12 "Enable UFW" \
    13 "Install UDPGW" \
    14 "Setup WebSite" \
    15 "Setup WordPress" \
    16 "Setup Repositories" \
    17 "Create SSH User" \
    18 "Configure WARP Proxy" \
    19 "Reboot System" \
    20 "Exit Script" 3>&1 1>&2 2>&3)

  case $choice in
    1) system_update ;;
    2) install_essential_packages ;;
    3) install_speedtest ;;
    4) create_swap_file ;;
    5) enable_bbr ;;
    6) enable_hybla ;;
    7) enable_and_configure_cron ;;
    8) install_vpn_panel ;;
    9) obtain_ssl_certificates ;;
    10) setup_pi_hole ;;
    11) change_ssh_port ;;
    12) enable_ufw ;;
    13) install_configure_warp_proxy ;;
    14) setup_mtproto_proxy ;;
    15) setup_hysteria_ii ;;
    16) setup_tuic_v5 ;;
    17) setup_juicity ;;
    18) setup_wireguard_angristan ;;
    19) setup_openvpn_angristan ;;
    20) setup_ikev2_ipsec ;;
    21) setup_reverse_tls_tunnel ;;
    22) create_ssh_user ;;
    23) reboot_system ;;
    24) exit_script ;;
    *) echo "Invalid option. Please try again." ;;
  esac
done
