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

# 14 Function to set up MTProto Proxy submenu
setup_mtproto_proxy_submenu() {
  local mtproto_choice
  dialog --title "Setup MTProto Proxy" --menu "Choose an MTProto Proxy option:" 15 60 6 \
    1 "Setup Erlang MTProto (recommended) | Sergey Prokhorov" \
    2 "Setup/Manage Python MTProto | HirbodBehnam" \
    3 "Setup/Manage Official MTProto | HirbodBehnam" \
    4 "Setup/Manage Golang MTProto | HirbodBehnam" 2> mtproto_choice.txt

  mtproto_choice=$(cat mtproto_choice.txt)

  case $mtproto_choice in
    "1")
      # Setup Erlang MTProto
      curl -L -o mtp_install.sh https://git.io/fj5ru && bash mtp_install.sh
      ;;
    "2")
      # Setup/Manage Python MTProto
      curl -o MTProtoProxyInstall.sh -L https://git.io/fjo34 && bash MTProtoProxyInstall.sh
      ;;
    "3")
      # Setup/Manage Official MTProto
      curl -o MTProtoProxyOfficialInstall.sh -L https://git.io/fjo3u && bash MTProtoProxyOfficialInstall.sh
      ;;
    "4")
      # Setup/Manage Golang MTProto
      curl -o MTGInstall.sh -L https://git.io/mtg_installer && bash MTGInstall.sh
      ;;
    *)
      dialog --msgbox "Invalid choice. No MTProto Proxy setup performed." 10 40
      return
      ;;
  esac

  # Wait for the user to press Enter
  read -p "Please press Enter to continue."
