  dialog --title "Enable BBR" --yesno "Do you want to enable BBR congestion control?\n\nEnabling BBR while Hybla is enabled can lead to conflicts. Are you sure you want to proceed?" 12 60
  response=$?
  if [ $response -eq 0 ]; then
    # Add BBR settings to sysctl.conf
    echo "net.core.default_qdisc = fq" | sudo tee -a /etc/sysctl.conf
    echo "net.ipv4.tcp_congestion_control = bbr" | sudo tee -a /etc/sysctl.conf
    
    # Apply the new settings
    sudo sysctl -p

    dialog --msgbox "BBR congestion control has been enabled successfully." 10 60
  else
    dialog --msgbox "BBR configuration skipped." 10 60
  fi
