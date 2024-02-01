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

  # Setup nginx
  sudo apt update -y
  sudo apt install -y nginx
  sudo apt install -y ufw
  sudo ufw allow 'Nginx HTTP'
  sudo ufw allow 'Nginx HTTPS'
  sudo ufw allow 'Nginx Full'
  sudo systemctl start nginx
  sudo systemctl enable nginx
  read -p  "Enter your domain adress:" domain
  sudo mkdir -p /var/www/$domain/html
  sudo chown -R $USER:$USER /var/www/$domain/html
  sudo chmod -R 755 /var/www/$domain
  sudo touch /var/www/$domain/html/index.html
  sudo cat << EOF > /var/www/$domain/html/index.html
    <html>
    <head>
        <title>Welcome to $domain!</title>
    </head>
    <body>
        <h1>Success!  The Nginx is working!</h1>
    </body>
    </html>
  EOF
  sudo cat << EOF > /etc/nginx/sites-available/$domain
  server {
          listen 80;
          listen [::]:80;
          root /var/www/$domain/html;
          index index.html index.htm index.nginx-debian.html;
          server_name $domain www.$domain;
          location / {
          try_files $uri $uri/ =404;
          }
         }
  EOF
  sudo ln -s /etc/nginx/sites-available/$domain /etc/nginx/sites-enabled
  sudo nginx -t
  sudo systemctl restart nginx
  systemctl status nginx

  # install certificate
  sudo apt install -y certbot
  echo "SSL/TLS Certificates by Letsencrypt"
  read -p "Enter your email:" email
  read -p "Enter your domain (e.g., sub.domain.com):" sni
  if [ -n "$email" ] && [ -n "$sni" ]; then
  sudo certbot certonly --standalone --preferred-challenges http --agree-tos --email "$email" -d "$sni"
  echo "SSL/TLS certificates obtained successfully for $sni in /etc/letsencrypt/live."
  unset email
  unset sni
  else
  echo "Both email and domain are required to obtain SSL certificates."
  fi
  
  # Setup TLS for nginx
  sudo apt install -y certbot python3-certbot-nginx
  sudo nginx -t
  sudo systemctl reload nginx
  sudo certbot --nginx -d $domain -d www.$domain
  sudo systemctl status certbot.timer
  sudo certbot renew --dry-run
  unset domain
