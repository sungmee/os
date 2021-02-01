#!/bin/bash
set -e

#! 设置变量
underline=`tput smul`
nounderline=`tput rmul`
bold=`tput bold`
normal=`tput sgr0`
timeout=21


#! 配置菜单
read -p "请输入主机域名：" HOSTNAME
read -p "请输入 SSH 登陆账户名（默认 ${underline}root${nounderline}）：" -t $timeout USER
read -p "是否更换 Docker 为国内源？（Yes/${underline}No${nounderline}）" -t $timeout DCN
read -p "应用名称？（默认 ${underline}Laravel${nounderline}）" -t $timeout APP_NAME
read -p "应用昵称？（默认 ${underline}Laravel${nounderline}）" -t $timeout APP_NICKNAME

USER=${USER:-root}
APP_NAME=${APP_NAME:-Laravel}
APP_NICKNAME=${APP_NICKNAME:-Laravel}

if [ "root" != "$USER" ]; then
    HOME="/home/$USER"
else
    HOME="/root"
fi


#! 设置主机名
if [ -n "$HOSTNAME" ]; then
    echo $HOSTNAME > /etc/hostname
    hostname $HOSTNAME
fi


#! 生成密钥
echo -e "----------------------------- 生成密钥 -----------------------------"
if [ ! -d $HOME/.ssh ]; then
    mkdir $HOME/.ssh
    chmod 700 $HOME/.ssh
    chown $USER:$USER $HOME/.ssh
fi
ssh-keygen -f $HOME/.ssh/id_rsa
echo ">>>>>>> 公钥 START <<<<<<<"
cat $HOME/.ssh/id_rsa.pub
sleep 14
echo ">>>>>>> 公钥 END <<<<<<<"


#! 开启免密登陆
KEYS="$HOME/.ssh/authorized_keys"

if [ "root" != "$USER" ]; then
    groupadd wheel
    usermod -a -G wheel $USER
    sed -i -e "s/# auth       sufficient pam_wheel.so trust/auth       sufficient pam_wheel.so trust/g" /etc/pam.d/su
    echo "su - root" >> $HOME/.bash_profile
    chown $USER:$USER $HOME/.bash_profile
fi

echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDeUmeQWcqFuY9Ho7wO+S7pnWK1uU5tUyuogvjXyT1qzZNBbFHKTCgOoo3kZyH77Y0IuACeeuHBqc4YSrMm3y+xOMTbEVHXLZYU6iBNxZoJVDVpEJQ2wRImra7uiZhYPzgBNi4KlwfJRBQKGksFrBMzlhBY0n7bL4cXz6vwp6/xlUO2TAmvcC4BiTJGqLVCwTuRslbsQez7ePDriT/CN9gsqys2iEd+CzSLx6JfvUkwG9H6eMeeQ5FBwEqhxkSaGVdoAbF6vAGXFNe2Ib/sK7EVNgmJ3X4gNapzDUkBFtXo2S1H5vE/npJGyI7zxDYTsu4QPq6RDqdphla61O8kuKuj root@google" > $KEYS
echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDe3g/2HD9xzRv7mNnRI8LsEp47tqKSCYI3mlvwm6dNFVKkZPAkhaTMplGSTA9E3JQFZFA0DDo1yL1if2V0dq494HqfBk8Zb0dDquvR68TBgQrRaCAZaVPGlis3Stx9bNbbX6Jqt4wIXV+Ch2EX/TpGjr5TgSVp55fj293pA1jhLaBOq4SWoYnTv4SA6YsqdEwvt+c9tBcvRovPnekNqU9g/kxcFo/2YOIsz1U2rOJa11J2j3UpybMRTk/HtvmxXllS5GcQ98EKAyetBhHQmeik948FsHC7MtdewFcFtZ9W2isKZkJRracFJls7y04KEB+cKIbm2rjKjCBwjRRbJNCQWMQBC+1ooSLFllL/9sOnZRwgAijPo+EYxDKunoTVNa40PG7oMLPO74IBrNzHb2pu8se6d5ss1BFhQJYxOt7W4Y187vBGMm+EszJCAWDCiSyW70RYkId1TwlbvlJBWJYjeZJB54kaq1fYyogUDSh44SF3HsizidcaLooAgmYiMgk= root@alpine" >> $KEYS
echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAAAgQDDMrV6p/3igBXPIFxAZcKNBJyZxoKoUHknVQNZJD5gPOATNNglYpsJON3XP7Mz3vF7fh6q7tLP5Y625GXpktzO7qe2maoAKGnttjpAxCMJVUvjHx9YpCHo6jS2KmZ6AC8Gz+3+gQIDbnuUm4njovrjDpY9WA0h1bKrTpkdbR4xHw== m@iPhone" >> $KEYS
echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCqmlUHAnRA9i+pcRdb3wpH/n5LtDkFTIdM8fAxYrj/DKN0pkudcfj8kgCHucTw1Kqfk0NHd1ZQbVjd8GMg08+DstNGkf2TTrNtpjPtg2HhijWxHVZqoif0EiHPnNYr7mWGxsayu4FRrYYVVWcSn4ZrcXFUeXgNyo1JP2gKR7hmbOTPntGGsDDloCnpOAgLsKcJV1tzrN08MImqs0FPK1MQRU7moajlvNPUyCWhKDsmUsFqXWm8UURHGgL3jJsuE76fa3YPty4l+9pN4M4L/3ZjCyjILKZ6pbF/vJgZpXcov6F2bSg/neUXq4E479mRFUlZLazY0wc6fPWuivZ0u94V shortcuts@iPhone" >> $KEYS
echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDXuZegS5W/Pt2fwoa550ighgACMsKG5xXOW62Um0R7YOUdtyKXuMmfKcGztCrxlxVW4/rWYikefGySmzvi8bFS/zETQW2eK5FPRVsJnzMKxXT6zniPWa38V1uxyIJ3Mr2+7YN9egVOVJ857okasoQIodvU63GtHac/iAGV7ivHz1jU1yWbnfK2fk2Gyy1XjdJEgWx71NsW1+72A/qGy+3P12zKA9IigNLYEtXcnwyYUgjrNqmGcgo/peiSQK+jYzftug5I2NLVG4IkW/l34x/wqW1beW3mAvZYLwHjZaFlgYYtULd1RePfjukfzFOASCNzXKeYguZLa/hJcOaN0Uqh m@air" >> $KEYS
echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCp7jaqwUsC/lrhry10C5zPww2nURKZg/WAAGDNobtPQjcE4sFCYXrh78b9pxwW1Qz1yYdoVEbh2DAXpR5Y5I1MiQ6gjiSYoyWBTBv3vl5N2o4/KWuvXd6kWu31upD9f5jZY2rEsB+hfaGSxkjEMSgBlSJmMB9cQ0AJdmUdXwhHDL1IBiahiZchqj6kDoKDcYgtdu3WI890vAz7uijHOg61EzqIG6V8MzobwwKpNQ1j2w4ea1V/bPjX+v0ybqcItYyrmqtEnZtzBtPNHn6mFmgN5y3krtMSlBV5SBkWRVSVYxtCndbbFwcB0AgkKOrXQfN6TechpGQkPeQtfYeZxgBx m@mini" >> $KEYS

if [ "root" != "$USER" ]; then
    chmod 600 $USER:$USER $KEYS
    chown $USER:$USER $KEYS
fi


echo -e "------------------------- 升级系统并安装基础应用 --------------------------"
apt update
apt upgrade -y
apt install git curl -y


#! 安装 ZSH
echo -e "-------------------------- 安装和配置 ZSH ---------------------------"
CST=${ZSH_CUSTOM:-/root/.oh-my-zsh/custom}

apt install -y autojump zsh
sh -c "$(wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $CST/plugins/zsh-syntax-highlighting
git clone git://github.com/zsh-users/zsh-autosuggestions $CST/plugins/zsh-autosuggestions

sed -i -e "s/ZSH_THEME=.*/ZSH_THEME=\"ys\"/g" /root/.zshrc
sed -i -e "s/plugins=.*/plugins=(debian git docker docker-compose screen cp autojump zsh-autosuggestions zsh-syntax-highlighting)/g" /root/.zshrc
echo "alias dc='docker-compose'" >> /root/.zshrc
echo "alias up='docker-compose up'" >> /root/.zshrc
echo "alias down='docker-compose down'" >> /root/.zshrc
echo "alias logs='docker-compose logs'" >> /root/.zshrc
echo "alias restart='docker-compose restart'" >> /root/.zshrc
echo "alias stop='docker-compose stop'" >> /root/.zshrc
echo "" >> /root/.zshrc
echo ". /usr/share/autojump/autojump.sh" >> /root/.zshrc
echo "" >> /root/.zshrc
echo "if [ -e /lib/terminfo/x/xterm-256color ]; then" >> /root/.zshrc
echo "  export TERM='xterm-256color'" >> /root/.zshrc
echo "else" >> /root/.zshrc
echo "  export TERM='xterm-color'" >> /root/.zshrc
echo "fi" >> /root/.zshrc

sed -i -e "s/typeset -g ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=8'/typeset -g ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=10'/g" $CST/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh


#! 安装 Docker
echo -e "--------------------------- 安装 Docker ----------------------------"
curl -fsSL get.docker.com | sh

echo -e "{" > /etc/docker/daemon.json
echo -e "  \"registry-mirrors\": [" >> /etc/docker/daemon.json
if [ "Y" == "$DCN" ] || [ "y" == "$DCN" ]; then
    echo -e "    \"https://db72lygt.mirror.aliyuncs.com\"," >> /etc/docker/daemon.json
    echo -e "    \"https://registry.docker-cn.com\"" >> /etc/docker/daemon.json
fi
echo -e "  ]," >> /etc/docker/daemon.json
echo -e "  \"log-driver\": \"json-file\"," >> /etc/docker/daemon.json
echo -e "  \"log-opts\": {\"max-size\": \"30m\", \"max-file\": \"3\"}" >> /etc/docker/daemon.json
echo -e "}" >> /etc/docker/daemon.json


#! 安装 Docker Compose
echo -e "------------------------ 安装 DockerCompose ------------------------"
curl -L "https://github.com/docker/compose/releases/download/1.26.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose


#! 配置项目
cd $HOME
git clone --depth 1 git@bitbucket.org:bosince/xin-he.git $HOSTNAME
cp $HOME/$HOSTNAME/.env.example $HOME/$HOSTNAME/.env
chmod -R 777 $HOME/$HOSTNAME/bootstrap/cache/
chmod -R 777 $HOME/$HOSTNAME/storage/

sed -i -e "s/^DOMAIN=/DOMAIN=$HOSTNAME/g" $HOME/$HOSTNAME/.env
sed -i -e "s/^APP_NAME=Laravel/APP_NAME=$APP_NAME/g" $HOME/$HOSTNAME/.env
sed -i -e "s/^APP_NICKNAME=Laravel/APP_NICKNAME=$APP_NICKNAME/g" $HOME/$HOSTNAME/.env
sed -i -e "s/47.244.123.121/db/g" $HOME/$HOSTNAME/.env
sed -i -e "s/3721/3306/g" $HOME/$HOSTNAME/.env
sed -i -e "s/^DB_DATABASE=laravel/DB_DATABASE=app/g" $HOME/$HOSTNAME/.env
sed -i -e "s/^DB_USERNAME=root/DB_USERNAME=google/g" $HOME/$HOSTNAME/.env
sed -i -e "s/^DB_PASSWORD=/DB_PASSWORD=Google123123/g" $HOME/$HOSTNAME/.env


echo -e "---------------------------- 系统初始化完成 -----------------------------"