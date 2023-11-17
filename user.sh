clear
read -p "Enter Your username: " name
adduser $name --shell /usr/sbin/nologin
unset name
