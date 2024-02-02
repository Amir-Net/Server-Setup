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

 # install certificate
 sudo apt install -y certbot python3-certbot-nginx
 echo "SSL/TLS Certificates by Letsencrypt"
 read -p "Enter your email:" email
 read -p "Enter your domain adress:" domain
 if [ -n "$email" ] && [ -n "$domain" ]; then
 sudo certbot certonly --standalone --preferred-challenges http --email "$email" -d "$domain"
 echo "SSL/TLS certificates obtained successfully for $domain in /etc/letsencrypt/live."
 else
 echo "Both email and domain are required to obtain SSL certificates."
 fi

# Setup nginx
sudo apt update -y
sudo apt install -y nginx ufw
sudo ufw allow 'Nginx Full'
sudo systemctl start nginx
sudo systemctl enable nginx

# Create Nginx configuration
cat << EOF > /etc/nginx/sites-available/default
server {
    listen 80;
    listen [::]:80;
    server_name $domain www.$domain;

    # Redirect to HTTPS
    return 301 https://$server_name$request_uri;
}

server {
    listen 443 ssl http2;
    listen [::]:443 ssl http2;
    server_name $domain www.$domain;
    # SSL/TLS configuration
    ssl_certificate /etc/letsencrypt/live/$domain/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/$domain/privkey.pem;
    root /var/www/$domain/html;
    index index.html index.htm index.nginx-debian.html;
    location / {
        try_files $uri $uri/ =404;
    }
}
EOF

sudo systemctl reload nginx
sudo systemctl restart nginx
sudo nginx -t

# Setup TLS for nginx
# sudo certbot --nginx -d $domain -d www.$domain
# sudo systemctl status certbot.timer
# sudo certbot renew --dry-run
