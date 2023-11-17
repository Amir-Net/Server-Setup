if [[ $EUID -ne 0 ]]; then
  if [[ $(sudo -n true 2>/dev/null) ]]; then
    echo "This Script Will be Run with sudo Privileges."
  else
    echo "This Script Must be Run with sudo Privileges."
    echo "Please Enter Root Password."
    su root
    11g
  fi
fi
apt update
apt upgrade
apt autoremove
apt autoclean
apt clean
