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
