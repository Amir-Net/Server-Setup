#!/bin/bash
# ... (header and disclaimers) ...

# Check for sudo privileges
# ... (sudo check code) ...

# Install certificate
# ... (certificate installation code) ...

# Setup nginx
sudo apt update -y
sudo apt install -y nginx ufw
sudo ufw allow 'Nginx Full'
sudo systemctl start nginx
sudo systemctl enable nginx

# Prompt for domain and create directories
read -p "Enter your domain address: " domain
sudo mkdir -p /var/www/$domain/html
sudo chown -R $USER:$USER /var/www/$domain/html
sudo chmod -R 755 /var/www/$domain

# Create index.html
cat << EOF > /var/www/$domain/html/index.html
<html>
<head>
<title>Welcome to $domain!</title>
</head>
<body>
<h1>Success! The Nginx is working!</h1>
</body>
</html>
EOF

# Create Nginx configuration
cat << EOF > /etc/nginx/sites-available/$domain
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

sudo ln -s /etc/nginx/sites-available/$domain /etc/nginx/sites-enabled
sudo nginx -t
sudo systemctl restart nginx

# Setup TLS for nginx
sudo certbot --nginx -d $domain -d www.$domain
sudo systemctl status certbot.timer
sudo certbot renew --dry-run
