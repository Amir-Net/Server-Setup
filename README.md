# Server-Setup
Atomatic Fresh Server Setup Script
Installation steps on Ubuntu
Connect to your server through ssh and copy and run the following command in the terminal

Server Preparation
```
sudo apt update -y && sudo apt upgrade -y && reboot
sudo apt install -y curl && sudo apt install -y dialog
```

Server Installation
```
sudo curl https://raw.githubusercontent.com/Amir-Net/Server-Setup/main/start.sh | bash
```

For manual installation, copy and run the following command in the terminal.
```
sudo curl https://raw.githubusercontent.com/Amir-Net/Server-Setup/main/essential.sh | sudo bash
sudo curl https://raw.githubusercontent.com/Amir-Net/Server-Setup/main/advanced.sh | sudo bash
sudo curl https://raw.githubusercontent.com/Amir-Net/Server-Setup/main/bbr.sh | sudo bash
sudo curl https://raw.githubusercontent.com/Amir-Net/Server-Setup/main/hybla.sh | sudo bash
sudo curl https://raw.githubusercontent.com/Amir-Net/Server-Setup/main/speed.sh | sudo bash
sudo curl https://raw.githubusercontent.com/Amir-Net/Server-Setup/main/ssl.sh | sudo bash
sudo curl https://raw.githubusercontent.com/Amir-Net/Server-Setup/main/tls.sh | sudo bash
sudo curl https://raw.githubusercontent.com/Amir-Net/Server-Setup/main/swap.sh | sudo bash
sudo curl https://raw.githubusercontent.com/Amir-Net/Server-Setup/main/corn.sh | sudo bash
sudo curl https://raw.githubusercontent.com/Amir-Net/Server-Setup/main/udpgw.sh | sudo bash
sudo curl https://raw.githubusercontent.com/Amir-Net/Server-Setup/main/site.sh | sudo bash
sudo curl https://raw.githubusercontent.com/Amir-Net/Server-Setup/main/ufw.sh | sudo bash
sudo curl https://raw.githubusercontent.com/Amir-Net/Server-Setup/main/user.sh | sudo bash
sudo curl https://raw.githubusercontent.com/Amir-Net/Server-Setup/main/warp.sh | sudo bash
```
Used Projects in this script 🙏
```
https://github.com/P3TERX/warp.sh
https://github.com/ErfanNamira/FreeIRAN
```
You can donate to me through Plisio at ❤️

<a href="https://plisio.net/donate/f_9qcQRU" target="_blank"><img src="https://plisio.net/img/donate/donate_light_icons_color.png" alt="Donate Crypto on Plisio" width="240" height="80" /></a>
