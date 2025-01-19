#!/bin/bash

sudo apt-get update
sudo apt-get clean -y
[ -e '/etc/needrestart/needrestart.conf' ] && (printf "\n\$nrconf{restart} = 'a';" >> /etc/needrestart/needrestart.conf)
wget https://software.virtualmin.com/gpl/scripts/virtualmin-install.sh
sudo sh virtualmin-install.sh -f -v
rm -rf virtualmin-install.sh virtualmin-install.log update.txt
sudo apt-get update
sudo apt-get clean -y
sudo apt-get install -y wget curl unzip zip screen iptables fail2ban git fontconfig rar dos2unix smartmontools
sudo apt-get update
sudo apt-get clean -y
sudo -v ; curl https://rclone.org/install.sh | sudo bash
sudo apt-get update
sudo apt-get clean -y
curl -fsSL https://deb.nodesource.com/setup_23.x | sudo -E bash -
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
sudo apt-get clean -y
sudo apt install -y python3.13
apt install -y python3-pip
sudo apt install -y python-is-python3
pip install gdown
sudo apt-get install -y build-essential
printf 'enter' | sudo add-apt-repository ppa:ondrej/php
sudo apt-get update
sudo apt-get clean -y
sudo apt-get install -y php8.4
sudo apt install php8.4-common php8.4-mysql php8.4-xml php8.4-xmlrpc php8.4-curl php8.4-gd php8.4-imagick php8.4-cli php8.4-dev php8.4-imap php8.4-mbstring php8.4-opcache php8.4-soap php8.4-zip php8.4-intl -y
sudo apt-get update
sudo apt-get clean -y
sudo apt install ntpdate -y
sudo ntpdate -s time.nist.gov
sudo timedatectl set-timezone UTC
sudo apt update
sudo apt install -y apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt update
sudo apt install -y docker-ce
cd
sudo swapoff -a
fallocate -l 20GB /swapfile
chmod 600 /swapfile
mkswap /swapfile
swapon /swapfile
echo '/swapfile none swap sw 0 0' | tee -a /etc/fstab
sudo smartctl -s on /dev/sda
cd
echo "" >> /etc/crontab
echo "@daily root sudo apt-get update" >> /etc/crontab
sudo apt-get clean -y
echo "" >> /etc/crontab
echo "@daily root" >> /etc/crontab
echo "" >> /etc/crontab
echo "@daily root /root/bekap_r.sh" >> /etc/crontab
echo "" >> /etc/crontab
echo "@daily root pm2 restart notif" >> /etc/crontab
echo "" >> /etc/crontab
echo "* * * * * root sudo ntpdate -s time.nist.gov" >> /etc/crontab
echo "" >> /etc/crontab
echo "@daily root sudo badblocks -sv /dev/sda1 > bad-blocks-result1 && sudo fsck -t ext4 -l bad-blocks-result1 /dev/sda1 && rm -rf /root/bad-blocks-result1" >> /etc/crontab
echo "" >> /etc/crontab
echo "@daily root sudo badblocks -sv /dev/sda2 > bad-blocks-result2 && sudo fsck -t ext4 -l bad-blocks-result2 /dev/sda2 && rm -rf /root/bad-blocks-result2" >> /etc/crontab
echo "" >> /etc/crontab
echo "@daily root sudo badblocks -sv /dev/sda3 > bad-blocks-result3 && sudo fsck -t ext4 -l bad-blocks-result3 /dev/sda3 && rm -rf /root/bad-blocks-result3" >> /etc/crontab
echo "" >> /etc/crontab
echo "@daily root sudo badblocks -sv /dev/sda4 > bad-blocks-result4 && sudo fsck -t ext4 -l bad-blocks-result4 /dev/sda4 && rm -rf /root/bad-blocks-result4" >> /etc/crontab
echo "" >> /etc/crontab
echo "@daily root sudo badblocks -sv /dev/sda5 > bad-blocks-result5 && sudo fsck -t ext4 -l bad-blocks-result5 /dev/sda5 && rm -rf /root/bad-blocks-result5" >> /etc/crontab
echo "" >> /etc/crontab
echo "* * * * * root [ -f /var/run/reboot-required ] && reboot" >> /etc/crontab
chmod +x /etc/fail2ban/jail.local
printf "[DEFAULT]\nignoreip = 127.0.0.1/89\n\n[sshd]\nenable = true\nport = ssh\nfilter = sshd\nlogpath = /var/log/auth.log\nmaxretry = 4\nbantime = 1d\nignoreip = 127.0.0.1\n\n[myjail]\nenabled = true\nport = 80,8080,443,22,10000\nmaxretry = 6\nbantime = 1d">>/etc/fail2ban/jail.local
systemctl enable fail2ban.service
systemctl start fail2ban
source ~/.bashrc
command

exit 0