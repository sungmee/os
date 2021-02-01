#!/bin/bash

# Crontab
# 0 */1 * * * /srv/docker/ddns/cloudflare.sh > /dev/null 2>&1

path="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

###################### 读取 .env 配置信息 #######################
while read line; do export $line; done < $path/.env

############### .env 授权信息 ################
# auth_email    CloudFlare 注册邮箱
# auth_key      CloudFlare Global API Key
# zone_name     做 DDNS 的一级域名
# record_name   做 DDNS 的二级域名，即最终应用访问域名

if [ -z $auth_email ] || [ -z $auth_key ] || [ -z $zone_name ] || [ -z $record_name ]; then
    echo -e "Create .env file and set the necessary variables, pls."
    exit 0
fi

###################### 设置默认配置信息 #######################
need_update_ipv4=${need_update_ipv4:=true}
need_update_ipv6=${need_update_ipv6:=true}

# IPv4 检测服务
# https://ipinfo.io/ip
# https://ipv4.icanhazip.com
# https://v4.ident.me/.json
# https://api.ipify.org?format=json
# http://v4.ipv6-test.com/api/myip.php
ipv4_url=${ipv4_url:='ipinfo.io/ip'}
ipv4=$(curl -s $ipv4_url)

# IPv6 检测服务
# https://v6.ident.me
# http://v6.ipv6-test.com/api/myip.php
ipv6_url=${ipv6_url:='v6.ident.me'}
ipv6=$(curl -s $ipv6_url)

path="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
# 变动前的公网 IP 保存位置
ip_file=${ip_file:="$path/ip.txt"}
# 域名识别信息保存位置
id_file=${id_file:="$path/ids.txt"}
# 监测日志保存位置
log_file=${log_file:="$path/log.txt"}

###################### 监测日志格式 ########################
log() {
    if [ "$1" ]; then
        echo -e "[$(date)] - $1" >> $log_file
    fi
}
log "Check Initiated"

###################### 判断 IP 是否变化 ####################
if [ -f $ip_file ]; then
    old_ipv4=$(head -1 $ip_file)
    if [ "$ipv4" == "$old_ipv4" ]; then
        echo "IPv4 has not changed."
        need_update_ipv4=false
    fi

    old_ipv6=$(tail -1 $ip_file)
    if [ "$ipv6" == "$old_ipv6" ]; then
        echo "IPv6 has not changed."
        need_update_ipv6=false
    fi
fi

###################### 获取域名及授权 ######################
if [ -f $id_file ] && [ $(wc -l $id_file | cut -d " " -f 1) == 3 ]; then
    zone_identifier=$(head -1 $id_file)
    record_identifier_ipv4=$(head -2 $id_file | tail -1)
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
if [ "$need_update_ipv4" = true ]; then
    result=$(curl -s -X PUT "https://api.cloudflare.com/client/v4/zones/$zone_identifier/dns_records/$record_identifier_ipv4" -H "X-Auth-Email: $auth_email" -H "X-Auth-Key: $auth_key" -H "Content-Type: application/json" --data "{\"type\":\"A\",\"name\":\"$record_name\",\"content\":\"$ipv4\",\"ttl\":\"1\"}")

    if [[ $result == *"\"success\":false"* ]]; then
        message="IPv4 API UPDATE FAILED. DUMPING RESULTS:\n$result"
        log "$message"
        echo -e "$message"
    else
        message="IPv4 changed to: $ipv4"
        log "$message"
        echo "$message"
    fi
fi

######################  更新 IPv6 DNS 记录 ######################
if [ "$need_update_ipv6" = true ]; then
    result=$(curl -s -X PUT "https://api.cloudflare.com/client/v4/zones/$zone_identifier/dns_records/$record_identifier_ipv6" -H "X-Auth-Email: $auth_email" -H "X-Auth-Key: $auth_key" -H "Content-Type: application/json" --data "{\"type\":\"AAAA\",\"name\":\"$record_name\",\"content\":\"$ipv6\",\"ttl\":\"1\"}")

    if [[ $result == *"\"success\":false"* ]]; then
        message="IPv6 API UPDATE FAILED. DUMPING RESULTS:\n$result"
        log "$message"
        echo -e "$message"
    else
        message="IPv6 changed to: $ipv6"
        log "$message"
        echo "$message"
    fi
fi


echo "$ipv4" > $ip_file
echo "$ipv6" >> $ip_file

exit 0