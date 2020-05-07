#!/bin/bash
set -e

#! 设置变量
underline=`tput smul`
nounderline=`tput rmul`
bold=`tput bold`
normal=`tput sgr0`
timeout=21


#! 配置菜单
read -p "请输入主机名称：" HOSTNAME
read -p "请输入 SSH 登陆账户名（默认 ${underline}root${nounderline}）：" -t $timeout USER
read -p "请输入 SSH 登陆公钥（默认导入常用公钥）：" -t $timeout PUB
read -p "是否生成密钥？（${underline}Yes${nounderline}/No）" -t $timeout KEY
read -p "是否安装 ZSH？（${underline}Yes${nounderline}/No）" -t $timeout ZSH
read -p "是否安装 Docker？（${underline}Yes${nounderline}/No）" -t $timeout DKR
read -p "是否更换 Docker 为国内源？（Yes/${underline}No${nounderline}）" -t $timeout DCN
read -p "是否安装 Docker Compose？（${underline}Yes${nounderline}/No）" -t $timeout DCP
read -p "是否安装同步服务 lsyncd？（Yes/${underline}No${nounderline}）" -t $timeout LSD

USER=${USER:-root}
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
if [ -z "$KEY" ] || [ "Y" == "$KEY" ] || [ "y" == "$KEY" ]; then
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
fi


#! 开启免密登陆
KEYS="$HOME/.ssh/authorized_keys"

if [ "root" != "$USER" ]; then
    groupadd wheel
    usermod -a -G wheel $USER
    sed -i -e "s/# auth       sufficient pam_wheel.so trust/auth       sufficient pam_wheel.so trust/g" /etc/pam.d/su
    echo "su - root" >> $HOME/.bash_profile
    chown $USER:$USER $HOME/.bash_profile
fi

if [ -n "$PUB" ]; then
    echo $PUB >> $KEYS
else
    echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDXuZegS5W/Pt2fwoa550ighgACMsKG5xXOW62Um0R7YOUdtyKXuMmfKcGztCrxlxVW4/rWYikefGySmzvi8bFS/zETQW2eK5FPRVsJnzMKxXT6zniPWa38V1uxyIJ3Mr2+7YN9egVOVJ857okasoQIodvU63GtHac/iAGV7ivHz1jU1yWbnfK2fk2Gyy1XjdJEgWx71NsW1+72A/qGy+3P12zKA9IigNLYEtXcnwyYUgjrNqmGcgo/peiSQK+jYzftug5I2NLVG4IkW/l34x/wqW1beW3mAvZYLwHjZaFlgYYtULd1RePfjukfzFOASCNzXKeYguZLa/hJcOaN0Uqh m@air" >> $KEYS
    echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCp7jaqwUsC/lrhry10C5zPww2nURKZg/WAAGDNobtPQjcE4sFCYXrh78b9pxwW1Qz1yYdoVEbh2DAXpR5Y5I1MiQ6gjiSYoyWBTBv3vl5N2o4/KWuvXd6kWu31upD9f5jZY2rEsB+hfaGSxkjEMSgBlSJmMB9cQ0AJdmUdXwhHDL1IBiahiZchqj6kDoKDcYgtdu3WI890vAz7uijHOg61EzqIG6V8MzobwwKpNQ1j2w4ea1V/bPjX+v0ybqcItYyrmqtEnZtzBtPNHn6mFmgN5y3krtMSlBV5SBkWRVSVYxtCndbbFwcB0AgkKOrXQfN6TechpGQkPeQtfYeZxgBx m@mini" >> $KEYS
    echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAAAgQDDMrV6p/3igBXPIFxAZcKNBJyZxoKoUHknVQNZJD5gPOATNNglYpsJON3XP7Mz3vF7fh6q7tLP5Y625GXpktzO7qe2maoAKGnttjpAxCMJVUvjHx9YpCHo6jS2KmZ6AC8Gz+3+gQIDbnuUm4njovrjDpY9WA0h1bKrTpkdbR4xHw== m@6s" >> $KEYS
fi

if [ "root" != "$USER" ]; then
    chmod 600 $USER:$USER $KEYS
    chown $USER:$USER $KEYS
fi


echo -e "------------------------- 升级系统并安装基础应用 --------------------------"
apt update
apt upgrade -y
apt install screen curl -y


#! 安装 ZSH
if [ -z "$ZSH" ] || [ "Y" == "$ZSH" ] || [ "y" == "$ZSH" ]; then
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
fi


#! 安装 Docker
if [ -z "$DKR" ] || [ "Y" == "$DKR" ] || [ "y" == "$DKR" ]; then
    echo -e "--------------------------- 安装 Docker ----------------------------"
    curl -fsSL get.docker.com | sh
fi

if [ "Y" == "$DCN" ] || [ "y" == "$DCN" ]; then
    echo -e "{" > /etc/docker/daemon.json
    echo -e "  \"registry-mirrors\": [" >> /etc/docker/daemon.json
    echo -e "    \"https://db72lygt.mirror.aliyuncs.com\"," >> /etc/docker/daemon.json
    echo -e "    \"https://registry.docker-cn.com\"" >> /etc/docker/daemon.json
    echo -e "  ]," >> /etc/docker/daemon.json
    echo -e "  \"log-driver\": \"json-file\"," >> /etc/docker/daemon.json
    echo -e "  \"log-opts\": {\"max-size\": \"30m\", \"max-file\": \"3\"}" >> /etc/docker/daemon.json
    echo -e "}" >> /etc/docker/daemon.json
fi


#! 安装 Docker Compose
if [ -z "$DCP" ] || [ "Y" == "$DCP" ] || [ "y" == "$DCP" ]; then
    echo -e "------------------------ 安装 DockerCompose ------------------------"
    curl -L "https://github.com/docker/compose/releases/download/1.25.5/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    chmod +x /usr/local/bin/docker-compose
fi


#! 安装 LSYNCD
if [ "Y" == "$LSD" ] || [ "y" == "$LSD" ]; then
    echo -e "------------------------ 安装同步服务 LSYNCD ------------------------"
    apt install lsyncd
fi

echo -e "---------------------------- 系统初始化完成 -----------------------------"