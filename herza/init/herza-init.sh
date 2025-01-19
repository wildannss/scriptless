#!/bin/bash

sudo apt-get update
sudo apt-get install -y wget curl unzip zip nano ufw squid apache2-utils screen iptables fail2ban git fontconfig dos2unix squid apache2-utils
printf "\ndeb http://download.webmin.com/download/repository sarge contrib">>/etc/apt/sources.list
wget -q -O- http://www.webmin.com/jcameron-key.asc | sudo apt-key add
sudo apt-get update
sudo apt install -y webmin
sudo apt-get update -y
curl -fsSL https://deb.nodesource.com/setup_22.x | sudo -E bash -
sudo apt-get install -y nodejs
npm install pm2@latest -g
pm2 install pm2-logrotate
pm2 set pm2-logrotate:max_size 20M
pm2 set pm2-logrotate:dateFormat DD-MM-YYYY_HH-mm-ss
pm2 set pm2-logrotate:TZ Asia/Jakarta
pm2 startup
pm2 save --force
sudo apt install -y software-properties-common
printf "enter" | sudo add-apt-repository ppa:deadsnakes/ppa
sudo apt-get update
sudo apt install -y python3.12
apt install -y python3-pip
sudo apt install -y python-is-python3
pip install gdown
sudo apt-get install -y build-essential
printf 'enter' | sudo add-apt-repository ppa:ondrej/php
sudo apt-get update
sudo apt install -y apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt update
sudo apt install -y docker-ce
cd
echo "" >> /etc/crontab
echo "@daily root sudo apt-get update" >> /etc/crontab
echo "" >> /etc/crontab
echo "@daily root pm2 restart notif" >> /etc/crontab
echo "" >> /etc/crontab
echo "* * * * * root [ -f /var/run/reboot-required ] && reboot" >> /etc/crontab
touch /etc/fail2ban/jail.local
chmod +x /etc/fail2ban/jail.local
printf "[DEFAULT]\nignoreip = 127.0.0.1/89\n\n[sshd]\nenable = true\nport = ssh\nfilter = sshd\nlogpath = /var/log/auth.log\nmaxretry = 4\nbantime = 1d\nignoreip = 127.0.0.1\n\n[myjail]\nenabled = true\nport = 2828,80,8080,443,22,10000\nmaxretry = 6\nbantime = 1d">>/etc/fail2ban/jail.local
systemctl enable fail2ban.service
systemctl start fail2ban

exit 0