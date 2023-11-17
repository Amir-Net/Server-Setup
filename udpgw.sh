wget -O /usr/bin/badvpn-udpgw "https://github.com/Amir-Net/Server-Setup/raw/main/badvpn-udpgw"
if [ "$OS" == "x86_64" ]; then
wget -O /usr/bin/badvpn-udpgw "https://github.com/Amir-Net/Server-Setup/raw/main/badvpn-udpgw64"
fi
wget -O /bin/badvpn-udpgw "https://github.com/Amir-Net/Server-Setup/raw/main/badvpn-udpgw"
if [ "$OS" == "x86_64" ]; then
wget -O /bin/badvpn-udpgw "https://github.com/Amir-Net/Server-Setup/raw/main/badvpn-udpgw64"
fi
touch /etc/rc.local
sed -i '$ i\screen -dmS udpvpn /bin/badvpn-udpgw --listen-addr 127.0.0.1:7300 --max-clients 1000 --max-connections-for-client 10
' /etc/rc.local
chmod +x /usr/bin/badvpn-udpgw
chmod +x /bin/badvpn-udpgw
chmod +x /etc/rc.local
systemctl enable rc-local
systemctl start rc-local.service
systemctl status rc-local.service
