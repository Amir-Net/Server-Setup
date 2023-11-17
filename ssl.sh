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
