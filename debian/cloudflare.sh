#!/bin/bash

############### .env 授权信息 ################
# auth_email    CloudFlare 注册邮箱
# auth_key      CloudFlare Global API Key
# zone_name     做 DDNS 的一级域名
# record_name   做 DDNS 的二级域名，即最终应用访问域名

######################  读取配置信息 #######################
while read line; do export $line; done < .env

######################  修改配置信息 #######################
# IPv6 检测服务，本站检测服务仅在大陆提供
# http://v6.ipv6-test.com/api/myip.php
# https://v6.ident.me
ipv6=$(curl -s v6.ident.me)
# IPv4 检测服务
# https://ipinfo.io/ip
# https://ipv4.icanhazip.com
# https://v4.ident.me/.json
# https://api.ipify.org?format=json
# http://v4.ipv6-test.com/api/myip.php
ip=$(curl -s $api_url)
# 变动前的公网 IP 保存位置
ip_file="ip.txt"
ipv6_file="ipv6.txt"
# 域名识别信息保存位置
id_file="ids.txt"
# 监测日志保存位置
log_file="log.txt"

######################  监测日志格式 ########################
log() {
    if [ "$1" ]; then
        echo -e "[$(date)] - $1" >> $log_file
    fi
}
log "Check Initiated"

######################  判断 IP 是否变化 ####################
if [ -f $ip_file ]; then
    old_ip=$(cat $ip_file)
    if [ "$ip" == "$old_ip" ]; then
        echo "IP has not changed."
        exit 0
    fi
fi

######################  获取域名及授权 ######################
if [ -f $id_file ] && [ $(wc -l $id_file | cut -d " " -f 1) == 3 ]; then
    zone_identifier=$(head -1 $id_file)
    record_identifier_ipv4=$(head -2 ids.txt | tail -1)
    record_identifier_ipv6=$(tail -1 $id_file)
else
    zone_identifier=$(curl -s -X GET "https://api.cloudflare.com/client/v4/zones?name=$zone_name" -H "X-Auth-Email: $auth_email" -H "X-Auth-Key: $auth_key" -H "Content-Type: application/json" | grep -Po '(?<="id":")[^"]*' | head -1 )
    record_identifier_ipv4=$(curl -s -X GET "https://api.cloudflare.com/client/v4/zones/$zone_identifier/dns_records?name=$record_name&type=A" -H "X-Auth-Email: $auth_email" -H "X-Auth-Key: $auth_key" -H "Content-Type: application/json"  | grep -Po '(?<="id":")[^"]*')
    record_identifier_ipv6=$(curl -s -X GET "https://api.cloudflare.com/client/v4/zones/$zone_identifier/dns_records?name=$record_name&type=AAAA" -H "X-Auth-Email: $auth_email" -H "X-Auth-Key: $auth_key" -H "Content-Type: application/json"  | grep -Po '(?<="id":")[^"]*')
    echo "$zone_identifier" > $id_file
    echo "$record_identifier_ipv4" >> $id_file
    echo "$record_identifier_ipv6" >> $id_file
fi

######################  更新 IPv4 DNS 记录 ######################
update_ipv4=$(curl -s -X PUT "https://api.cloudflare.com/client/v4/zones/$zone_identifier/dns_records/$record_identifier_ipv4" -H "X-Auth-Email: $auth_email" -H "X-Auth-Key: $auth_key" -H "Content-Type: application/json" --data "{\"type\":\"A\",\"name\":\"$record_name\",\"content\":\"$ip\",\"ttl\":\"1\"}")

######################  更新 IPv6 DNS 记录 ######################
update_ipv6=$(curl -s -X PUT "https://api.cloudflare.com/client/v4/zones/$zone_identifier/dns_records/$record_identifier_ipv6" -H "X-Auth-Email: $auth_email" -H "X-Auth-Key: $auth_key" -H "Content-Type: application/json" --data "{\"type\":\"AAAA\",\"name\":\"$record_name\",\"content\":\"$ipv6\",\"ttl\":\"1\"}")


#########################  更新反馈 #########################
if [[ $update_ipv4 == *"\"success\":false"* ]]; then
    message="IPv4 API UPDATE FAILED. DUMPING RESULTS:\n$update_ipv4"
    log "$message"
    echo -e "$message"
    # exit 1
else
    message="IP changed to: $ip"
    echo "$ip" > $ip_file
    log "$message"
    echo "$message"
fi

#########################  IPv6 更新反馈 #########################
if [[ $update_ipv6 == *"\"success\":false"* ]]; then
    message2="IPv6 API UPDATE FAILED. DUMPING RESULTS:\n$update_ipv6"
    log "$message2"
    echo -e "$message2"
    exit 1
else
    message2="IPv6 changed to: $ipv6"
    echo "$ipv6" > $ipv6_file
    log "$message2"
    echo "$message2"
fi