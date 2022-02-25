#!/bin/bash

export PATH=$PATH:/usr/sbin
export https_proxy=http://10.0.0.2:7890
export http_proxy=http://10.0.0.2:7890
export all_proxy=socks5://10.0.0.2:7891

apt update && apt install -y sudo git curl gnupg2 aptitude net-tools wireless-tools zsh

usermod -a -G sudo wallet

curl -s https://install.zerotier.com | sudo bash

sudo zerotier-cli orbit e1e22b7aec e1e22b7aec
sudo zerotier-cli join 159924d6306be5ee

curl -fsSL get.docker.com | sudo sh

usermod -a -G docker wallet

echo -e "{" > /etc/docker/daemon.json
echo -e "  \"registry-mirrors\": [" >> /etc/docker/daemon.json
echo -e "    \"https://db72lygt.mirror.aliyuncs.com\"," >> /etc/docker/daemon.json
echo -e "    \"https://registry.docker-cn.com\"" >> /etc/docker/daemon.json
echo -e "  ]," >> /etc/docker/daemon.json
echo -e "  \"log-driver\": \"json-file\"," >> /etc/docker/daemon.json
echo -e "  \"log-opts\": {\"max-size\": \"30m\", \"max-file\": \"3\"}" >> /etc/docker/daemon.json
echo -e "}" >> /etc/docker/daemon.json

curl -L "https://github.com/docker/compose/releases/download/1.25.5/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose

chmod +x /usr/local/bin/docker-compose

sed -i -e "s/#PasswordAuthentication yes/PasswordAuthentication no/g" /etc/ssh/sshd_config
sed -i -e "s/#PrintLastLog yes/PrintLastLog no/g" /etc/ssh/sshd_config

read -p "请输入主机编号：" HOSTNO
cp /etc/motd /etc/motd.bk
echo " " > /etc/motd
echo "Welcome to Wallet $HOSTNO" >> /etc/motd

echo '' > ~/.bash_history

exit 0