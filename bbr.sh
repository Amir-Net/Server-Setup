# Add BBR settings to sysctl.conf
echo "net.core.default_qdisc = fq" | sudo tee -a /etc/sysctl.conf
echo "net.ipv4.tcp_congestion_control = bbr" | sudo tee -a /etc/sysctl.conf
# Apply the new settings
sudo sysctl -p
sysctl net.ipv4.tcp_congestion_control
