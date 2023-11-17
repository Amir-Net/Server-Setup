su root
fallocate -l 1G /swapfile
dd if=/dev/zero of=/swapfile bs=1024 count=1048576
chmod 600 /swapfile
mkswap /swapfile
swapon /swapfile
sed -i '$ /swapfile swap swap defaults 0 0' /etc/fstab
swapon --show
free -h
