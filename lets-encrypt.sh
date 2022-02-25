#!/bin/bash
set -e

read -p "请输入顶级域名：" DOMAIN

curl -L "https://dl.eff.org/certbot-auto" -o /usr/local/bin/certbot-auto
chmod a+x /usr/local/bin/certbot-auto

#! 生成顶级域名证书
certbot-auto certonly  -d "$DOMAIN" --manual --preferred-challenges dns-01  --server https://acme-v02.api.letsencrypt.org/directory

#! 生成泛域名证书
certbot-auto certonly  -d "*.$DOMAIN" --manual --preferred-challenges dns-01  --server https://acme-v02.api.letsencrypt.org/directory

#! 生成软链接
ln -s /etc/letsencrypt/live /certs

#! 定时自动续期
echo -e "0 0 */30 * * usr/local/bin/certbot-auto renew &>/dev/null\n" >> /var/spool/cron/crontabs/root