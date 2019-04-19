#!/bin/sh
set -e

underline=`tput smul`
nounderline=`tput rmul`
bold=`tput bold`
normal=`tput sgr0`

echo "--------------------------------- 升级系统 --------------------------------"
apt update
apt upgrade -y

echo "----------------------------- SU 免密并自动 SU -----------------------------"
read -p "输入登陆用户的账户名：" user
user=${user:-mchan}

groupadd wheel
usermod -a -G wheel $user
sed -i -e "s/# auth       sufficient pam_wheel.so trust/auth       sufficient pam_wheel.so trust/g" /etc/pam.d/su
echo "su - root" >> /home/$user/.bash_profile

echo "--------------------------- 安装基础应用和配置 ZSH --------------------------"
apt install -y git screen autojump zsh
sh -c "$(wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone git://github.com/zsh-users/zsh-autosuggestions $ZSH_CUSTOM/plugins/zsh-autosuggestions

sed -i -e "s/ZSH_THEME=.*/ZSH_THEME=\"ys\"/g" ~/.zshrc
sed -i -e "s/plugins=.*/plugins=(git zsh-autosuggestions zsh-syntax-highlighting)/g" ~/.zshrc
echo "" >> ~/.zshrc
echo ". /usr/share/autojump/autojump.sh" >> ~/.zshrc
echo "" >> ~/.zshrc
echo "if [ -e /lib/terminfo/x/xterm-256color ]; then" >> ~/.zshrc
echo "  export TERM='xterm-256color'" >> ~/.zshrc
echo "else" >> ~/.zshrc
echo "  export TERM='xterm-color'" >> ~/.zshrc
echo "fi" >> ~/.zshrc

echo "------------------------------- 安装 Docker -------------------------------"
read -t 7 -p "是否安装 Docker？（${underline}Yes${nounderline}/No）" doc
if [ -z $doc || "Y" == $doc || "y" == $doc || "yes" == $doc || "Yes" == $doc ]
    curl -fsSL get.docker.com | sh
fi

read -t 7 -p "是否更换 Docker 为国内源？（Yes/${underline}No${nounderline}）" dcn
if [ "Y" == $dcn || "y" == $dcn || "yes" == $dcn || "Yes" == $dcn ]
    echo -e "\{" >> /etc/docker/daemon.json
    echo -e "  \"registry-mirrors\": [" >> /etc/docker/daemon.json
    echo -e "    \"https://db72lygt.mirror.aliyuncs.com\"," >> /etc/docker/daemon.json
    echo -e "    \"https://registry.docker-cn.com\"" >> /etc/docker/daemon.json
    echo -e "  ]" >> /etc/docker/daemon.json
    echo -e "\}"
fi

echo "---------------------------- 安装 DockerCompose ---------------------------"
read -t 7 -p "是否安装 Docker Compose？（${underline}Yes${nounderline}/No）" com
if [ -z $com || "Y" == $com || "y" == $com || "yes" == $com || "Yes" == $com ]
    curl -L "https://github.com/docker/compose/releases/download/1.24.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    chmod +x /usr/local/bin/docker-compose
fi

echo "---------------------------- 安装同步服务 LSYNCD ---------------------------"
read -t 7 -p "是否安装 Docker Compose？（Yes/${underline}No${nounderline}）" lsd
if [ "Y" == $lsd || "y" == $lsd || "yes" == $lsd || "Yes" == $lsd ]
    apt install lsyncd
fi

echo "--------------------------------- 生成密钥 --------------------------------"
read -t 7 -p "是否生成密钥？（${underline}Yes${nounderline}/No）" key
if [ -z $key || "Y" == $key || "y" == $key || "yes" == $key || "Yes" == $key ]
    ssh-keygen
fi

read -t 7 -p "是否读取公钥？（${underline}Yes${nounderline}/No）" cat
if [ -z $cat || "Y" == $cat || "y" == $cat || "yes" == $cat || "Yes" == $cat ]
    cat ~/.ssh/id_rsa.pub
fi

echo "------------------------------- 系统初始化完成 -----------------------------"