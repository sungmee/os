#!/bin/sh
echo "--------------------------------- 升级系统 --------------------------------"
apt update
apt upgrade -y

echo "----------------------------- SU 免密并自动 SU -----------------------------"
read -p "输入登陆用户的账户名：" user
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
curl -fsSL get.docker.com | sh

echo "---------------------------- 安装 DockerCompose ---------------------------"
curl -L "https://github.com/docker/compose/releases/download/1.24.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

echo "------------------------------- 系统初始化完成 -----------------------------"