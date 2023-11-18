if [[ $EUID -ne 0 ]]; 
then
apt update
apt upgrade
apt autoremove
apt autoclean
apt clean
  else
   echo "This Script Must be Run with sudo Privileges."
   echo "Please Enter Root Password."
   su root
   apt update
   apt upgrade
   apt autoremove
   apt autoclean
   apt clean
  fi
