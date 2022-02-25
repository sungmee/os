#!/bin/bash

timedatectl set-timezone Asia/Shanghai

# sh -c "$(wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"

apt update && apt upgrade -y && apt install screen git curl autojump zsh -y

git clone --depth 1 https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
git clone --depth 1 git://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions

sed -i -e "s/ZSH_THEME=.*/ZSH_THEME=\"ys\"/g" ~/.zshrc
sed -i -e "s/plugins=.*/plugins=(debian git screen cp autojump zsh-autosuggestions zsh-syntax-highlighting)/g" ~/.zshrc
sed -i -e "s/typeset -g ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=8'/typeset -g ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=10'/g" ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

echo "" >> ~/.zshrc
echo "export LC_ALL=en_US.UTF-8" >> ~/.zshrc
echo ". /usr/share/autojump/autojump.sh" >> ~/.zshrc
echo "" >> ~/.zshrc
echo "if [ -e /lib/terminfo/x/xterm-256color ]; then" >> ~/.zshrc
echo "  export TERM='xterm-256color'" >> ~/.zshrc
echo "else" >> ~/.zshrc
echo "  export TERM='xterm-color'" >> ~/.zshrc
echo "fi" >> ~/.zshrc
echo "" >> ~/.zshrc

echo "" >> /etc/vim/vimrc.tiny
echo "set nocompatible" >> /etc/vim/vimrc.tiny
echo "set backspace=2" >> /etc/vim/vimrc.tiny

curl -fsSL get.docker.com | sh

# {
#   "registry-mirrors": [
#     "http://db72lygt.mirror.aliyuncs.com",
#     "http://registry.docker-cn.com",
#     "http://docker.mirrors.ustc.edu.cn",
#     "http://hub-mirror.c.163.com",
#   ],
#   "log-driver": "json-file",
#   "log-opts": {
#     "max-size": "10m",
#     "max-file": "3"
#   }
# }
echo -e "{" > /etc/docker/daemon.json
echo -e "  \"registry-mirrors\": [" >> /etc/docker/daemon.json
echo -e "    \"http://db72lygt.mirror.aliyuncs.com\"," >> /etc/docker/daemon.json
echo -e "    \"http://registry.docker-cn.com\"", >> /etc/docker/daemon.json
echo -e "    \"http://docker.mirrors.ustc.edu.cn\"", >> /etc/docker/daemon.json
echo -e "    \"http://hub-mirror.c.163.com\"" >> /etc/docker/daemon.json
echo -e "  ]," >> /etc/docker/daemon.json
echo -e "  \"log-driver\": \"json-file\"," >> /etc/docker/daemon.json
echo -e "  \"log-opts\": {\"max-size\": \"10m\", \"max-file\": \"3\"}" >> /etc/docker/daemon.json
echo -e "}" >> /etc/docker/daemon.json

DC_VERSION=$(wget -qO- -t1 -T2 "https://api.github.com/repos/docker/compose/releases/latest" | grep "tag_name" | head -n 1 | awk -F ":" '{print $2}' | sed 's/\"//g;s/,//g;s/ //g') && \
curl -L "https://github.com/docker/compose/releases/download/$DC_VERSION/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose && \
chmod +x /usr/local/bin/docker-compose

exit 0