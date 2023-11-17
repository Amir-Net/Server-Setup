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
