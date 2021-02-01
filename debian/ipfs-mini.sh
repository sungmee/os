#!/bin/bash
set -e

#! 设置变量
underline=`tput smul`
nounderline=`tput rmul`
bold=`tput bold`
normal=`tput sgr0`
timeout=21


#! 配置菜单
read -p "请输入主机域名：" DOMAIN
read -p "应用名称？（默认 ${underline}Laravel${nounderline}）" -t $timeout APP_NAME
read -p "应用昵称？（默认 ${underline}Laravel${nounderline}）" -t $timeout APP_NICKNAME

DOMAIN=${DOMAIN:-app.dev}
APP_NAME=${APP_NAME:-Laravel}
APP_NICKNAME=${APP_NICKNAME:-Laravel}


ssh-keygen -f ~/.ssh/id_rsa -q -N ""
cat ~/.ssh/id_rsa.pub
sleep 7


echo -e "-------------------------- 安装和配置 ZSH ---------------------------"
apt update && apt upgrade -y && apt install git curl autojump zsh -y

sh -c "$(wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"
git clone --depth 1 https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
git clone --depth 1 git://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions

sed -i -e "s/ZSH_THEME=.*/ZSH_THEME=\"ys\"/g" ~/.zshrc
sed -i -e "s/plugins=.*/plugins=(debian git docker docker-compose screen cp autojump zsh-autosuggestions zsh-syntax-highlighting)/g" ~/.zshrc
echo "alias dc='docker-compose'" >> ~/.zshrc
echo "alias up='docker-compose up'" >> ~/.zshrc
echo "alias down='docker-compose down'" >> ~/.zshrc
echo "alias logs='docker-compose logs'" >> ~/.zshrc
echo "alias restart='docker-compose restart'" >> ~/.zshrc
echo "alias stop='docker-compose stop'" >> ~/.zshrc
echo "alias dsh='docker exec -it ${DOMAIN} bash'" >> ~/.zshrc
echo "" >> ~/.zshrc
echo ". /usr/share/autojump/autojump.sh" >> ~/.zshrc
echo "" >> ~/.zshrc
echo "if [ -e /lib/terminfo/x/xterm-256color ]; then" >> ~/.zshrc
echo "  export TERM='xterm-256color'" >> ~/.zshrc
echo "else" >> ~/.zshrc
echo "  export TERM='xterm-color'" >> ~/.zshrc
echo "fi" >> ~/.zshrc
echo "" >> ~/.zshrc
echo "cd ~/$DOMAIN" >> ~/.zshrc
echo "" >> ~/.zshrc

echo "alias capp='cd ~/app'" >> ~/.bashrc
echo "alias dc='cd ~/app && docker-compose'" >> ~/.bashrc

sed -i -e "s/typeset -g ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=8'/typeset -g ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=10'/g" ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh


echo -e "--------------------------- 安装 Docker ----------------------------"
curl -fsSL get.docker.com | sh

echo -e "{" > /etc/docker/daemon.json
echo -e "  \"log-driver\": \"json-file\"," >> /etc/docker/daemon.json
echo -e "  \"log-opts\": {\"max-size\": \"30m\", \"max-file\": \"3\"}" >> /etc/docker/daemon.json
echo -e "}" >> /etc/docker/daemon.json


echo -e "------------------------ 安装 DockerCompose ------------------------"
DC_VERSION=$(wget -qO- -t1 -T2 "https://api.github.com/repos/docker/compose/releases/latest" | grep "tag_name" | head -n 1 | awk -F ":" '{print $2}' | sed 's/\"//g;s/,//g;s/ //g')
curl -L "https://github.com/docker/compose/releases/download/$DC_VERSION/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose


echo -e "------------------------ 配置 TROJAN ------------------------"
echo -e '{\n\t"run_type": "server",\n\t"local_addr": "0.0.0.0",\n\t"local_port": 443,\n\t"remote_addr": "nginx",\n\t"remote_port": 80,\n\t"password": [\n\t\t"Google123123"\n\t],\n\t"log_level": 1,\n\t"ssl": {\n\t\t"cert": "/certs/fullchain.pem",\n\t\t"key": "/certs/key.pem",\n\t\t"key_password": "",\n\t\t"cipher": "ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:DHE-RSA-AES128-GCM-SHA256:DHE-RSA-AES256-GCM-SHA384",\n\t\t"cipher_tls13": "TLS_AES_128_GCM_SHA256:TLS_CHACHA20_POLY1305_SHA256:TLS_AES_256_GCM_SHA384",\n\t\t"prefer_server_cipher": true,\n\t\t"alpn": [\n\t\t\t"http/1.1"\n\t\t],\n\t\t"reuse_session": true,\n\t\t"session_ticket": false,\n\t\t"session_timeout": 600,\n\t\t"plain_http_response": "",\n\t\t"curves": "",\n\t\t"dhparam": ""\n\t},\n\t"tcp": {\n\t\t"prefer_ipv4": false,\n\t\t"no_delay": true,\n\t\t"keep_alive": true,\n\t\t"reuse_port": false,\n\t\t"fast_open": false,\n\t\t"fast_open_qlen": 20\n\t},\n\t"mysql": {\n\t\t"enabled": false,\n\t\t"server_addr": "127.0.0.1",\n\t\t"server_port": 3306,\n\t\t"database": "trojan",\n\t\t"username": "trojan",\n\t\t"password": ""\n\t}\n}' > ~/trojan.json


echo -e "------------------------ 配置项目 ------------------------"
cd ~
ssh-keyscan -H bitbucket.org >> ~/.ssh/known_hosts
git clone --depth 1 git@bitbucket.org:bosince/lionhash.git app
cp ~/app/.env.example ~/app/.env
chown -R 1000:33 storage bootstrap/cache
chmod -R 751 storage bootstrap/cache
chmod -R o+r storage bootstrap/cache

sed -i -e "s/^DOMAIN=/DOMAIN=$DOMAIN/g" ~/app/.env
sed -i -e "s/^APP_NAME=Laravel/APP_NAME=$APP_NAME/g" ~/app/.env
sed -i -e "s/^APP_NICKNAME=Laravel/APP_NICKNAME=$APP_NICKNAME/g" ~/app/.env
sed -i -e "s/47.244.123.121/db/g" ~/app/.env
sed -i -e "s/3721/3306/g" ~/app/.env
sed -i -e "s/^DB_DATABASE=laravel/DB_DATABASE=app/g" ~/app/.env
sed -i -e "s/^DB_USERNAME=root/DB_USERNAME=google/g" ~/app/.env
sed -i -e "s/^DB_PASSWORD=/DB_PASSWORD=Google123123/g" ~/app/.env


cd ~/app
docker-compose up -d nginx letsencrypt memcached db app git ftp trojan
docker-compose exec -T app composer install --optimize-autoloader --no-dev && \
docker-compose exec -T app php artisan key:generate && \
docker-compose exec -T app php artisan migrate --force

echo -e "---------------------------- 系统初始化完成 -----------------------------"