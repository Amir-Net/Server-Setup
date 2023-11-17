dialog --title "Create SWAP File" --yesno "Do you want to create a SWAP file?" 10 60
  response=$?
  if [ $response -eq 0 ]; then
    if [ -f /swapfile ]; then
      dialog --title "Swap File" --msgbox "A SWAP file already exists. Skipping swap file creation." 10 60
    else
      dialog --title "Swap File" --inputbox "Enter the size of the SWAP file (e.g., 2G for 2 gigabytes):" 10 60 2> swap_size.txt
      swap_size=$(cat swap_size.txt)

      if [[ "$swap_size" =~ ^[0-9]+[GgMm]$ ]]; then
        dialog --infobox "Creating SWAP file. Please wait..." 10 60
        sudo fallocate -l "$swap_size" /swapfile
        sudo chmod 600 /swapfile
        sudo mkswap /swapfile
        sudo swapon /swapfile
        echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab
        sudo sysctl vm.swappiness=10
        sudo sysctl vm.vfs_cache_pressure=50
        echo "vm.swappiness=10" | sudo tee -a /etc/sysctl.conf
        echo "vm.vfs_cache_pressure=50" | sudo tee -a /etc/sysctl.conf
        dialog --msgbox "SWAP file created successfully with a size of $swap_size." 10 60
      else
        dialog --msgbox "Invalid SWAP file size. Please provide a valid size (e.g., 2G for 2 gigabytes)." 10 60
      fi
    fi
  else
    dialog --msgbox "Skipping SWAP file creation." 10 60
  fi
dialog --msgbox "$(swapon --show)" 10 50
clear
