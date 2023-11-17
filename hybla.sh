  dialog --title "Enable Hybla" --yesno "Do you want to enable Hybla congestion control?\n\nEnabling Hybla while BBR is enabled can lead to conflicts. Are you sure you want to proceed?" 12 60
  response=$?
  if [ $response -eq 0 ]; then
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

    dialog --msgbox "Hybla congestion control has been enabled successfully." 10 60
  else
    dialog --msgbox "Hybla configuration skipped." 10 60
  fi
