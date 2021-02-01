#!/bin/sh

# http://mirrors.sjtug.sjtu.edu.cn/alpine/v3.12/main
# http://mirrors.sjtug.sjtu.edu.cn/alpine/v3.12/community


mkdir /root/.ssh && chmod 700 /root/.ssh
touch /root/.ssh/authorized_keys && chmod 600 /root/.ssh/authorized_keys
echo 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDXuZegS5W/Pt2fwoa550ighgACMsKG5xXOW62Um0R7YOUdtyKXuMmfKcGztCrxlxVW4/rWYikefGySmzvi8bFS/zETQW2eK5FPRVsJnzMKxXT6zniPWa38V1uxyIJ3Mr2+7YN9egVOVJ857okasoQIodvU63GtHac/iAGV7ivHz1jU1yWbnfK2fk2Gyy1XjdJEgWx71NsW1+72A/qGy+3P12zKA9IigNLYEtXcnwyYUgjrNqmGcgo/peiSQK+jYzftug5I2NLVG4IkW/l34x/wqW1beW3mAvZYLwHjZaFlgYYtULd1RePfjukfzFOASCNzXKeYguZLa/hJcOaN0Uqh m@air' > /root/.ssh/authorized_keys
echo 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDe3g/2HD9xzRv7mNnRI8LsEp47tqKSCYI3mlvwm6dNFVKkZPAkhaTMplGSTA9E3JQFZFA0DDo1yL1if2V0dq494HqfBk8Zb0dDquvR68TBgQrRaCAZaVPGlis3Stx9bNbbX6Jqt4wIXV+Ch2EX/TpGjr5TgSVp55fj293pA1jhLaBOq4SWoYnTv4SA6YsqdEwvt+c9tBcvRovPnekNqU9g/kxcFo/2YOIsz1U2rOJa11J2j3UpybMRTk/HtvmxXllS5GcQ98EKAyetBhHQmeik948FsHC7MtdewFcFtZ9W2isKZkJRracFJls7y04KEB+cKIbm2rjKjCBwjRRbJNCQWMQBC+1ooSLFllL/9sOnZRwgAijPo+EYxDKunoTVNa40PG7oMLPO74IBrNzHb2pu8se6d5ss1BFhQJYxOt7W4Y187vBGMm+EszJCAWDCiSyW70RYkId1TwlbvlJBWJYjeZJB54kaq1fYyogUDSh44SF3HsizidcaLooAgmYiMgk= root@alpine' >> /root/.ssh/authorized_keys
echo 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAAAgQDDMrV6p/3igBXPIFxAZcKNBJyZxoKoUHknVQNZJD5gPOATNNglYpsJON3XP7Mz3vF7fh6q7tLP5Y625GXpktzO7qe2maoAKGnttjpAxCMJVUvjHx9YpCHo6jS2KmZ6AC8Gz+3+gQIDbnuUm4njovrjDpY9WA0h1bKrTpkdbR4xHw== m@iPhone' >> /root/.ssh/authorized_keys
echo 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCqmlUHAnRA9i+pcRdb3wpH/n5LtDkFTIdM8fAxYrj/DKN0pkudcfj8kgCHucTw1Kqfk0NHd1ZQbVjd8GMg08+DstNGkf2TTrNtpjPtg2HhijWxHVZqoif0EiHPnNYr7mWGxsayu4FRrYYVVWcSn4ZrcXFUeXgNyo1JP2gKR7hmbOTPntGGsDDloCnpOAgLsKcJV1tzrN08MImqs0FPK1MQRU7moajlvNPUyCWhKDsmUsFqXWm8UURHGgL3jJsuE76fa3YPty4l+9pN4M4L/3ZjCyjILKZ6pbF/vJgZpXcov6F2bSg/neUXq4E479mRFUlZLazY0wc6fPWuivZ0u94V shortcuts@iPhone' >> /root/.ssh/authorized_keys
echo 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCp7jaqwUsC/lrhry10C5zPww2nURKZg/WAAGDNobtPQjcE4sFCYXrh78b9pxwW1Qz1yYdoVEbh2DAXpR5Y5I1MiQ6gjiSYoyWBTBv3vl5N2o4/KWuvXd6kWu31upD9f5jZY2rEsB+hfaGSxkjEMSgBlSJmMB9cQ0AJdmUdXwhHDL1IBiahiZchqj6kDoKDcYgtdu3WI890vAz7uijHOg61EzqIG6V8MzobwwKpNQ1j2w4ea1V/bPjX+v0ybqcItYyrmqtEnZtzBtPNHn6mFmgN5y3krtMSlBV5SBkWRVSVYxtCndbbFwcB0AgkKOrXQfN6TechpGQkPeQtfYeZxgBx m@mini' >> /root/.ssh/authorized_keys
lbu add /root/.ssh/authorized_keys

echo '' > /etc/motd
echo '*****************************************************' >> /etc/motd
echo '*                                                   *' >> /etc/motd
echo '**      ╔╦╗ ╔═╗┬ ┬┌─┐┌┐┌┌─┐  ╔═╗┬  ┌─┐┌─┐┬ ┬       **' >> /etc/motd
echo '***     ║║║ ║  ├─┤├─┤│││└─┐  ║  │  ├─┤└─┐├─┤      ***' >> /etc/motd
echo '**      ╩ ╩o╚═╝┴ ┴┴ ┴┘└┘└─┘  ╚═╝┴─┘┴ ┴└─┘┴ ┴       **' >> /etc/motd
echo '*                                                   *' >> /etc/motd
echo '*****************************************************' >> /etc/motd
echo '' >> /etc/motd


echo 'net.ipv4.ip_forward = 1' >> /etc/sysctl.conf
echo 'net.ipv6.conf.all.forwarding = 1' >> /etc/sysctl.conf
# touch /etc/sysctl.d/01-router.conf
# echo 'net.ipv4.ip_forward = 1' > /etc/sysctl.d/01-router.conf
# echo 'net.ipv6.conf.all.forwarding = 1' >> /etc/sysctl.d/01-router.conf
sysctl -p


chmod +x /usr/sbin/clash
touch /etc/local.d/clash.start
chmod +x /etc/local.d/clash.start
echo '#!/bin/sh' > /etc/local.d/clash.start
echo 'nohup clash -d /root/.config/clash >/dev/null 2>&1 &' >> /etc/local.d/clash.start
echo 'exit 0' >> /etc/local.d/clash.start
rc-update add local
lbu add /usr/sbin/clash
lbu add /root/.config/clash/


mkdir -p /root/.config/init.d


apk add open-vm-tools
/etc/init.d/open-vm-tools start
rc-update add open-vm-tools

mv /etc/init.d/open-vm-tools /root/.config/init.d/
ln -s /root/.config/init.d/open-vm-tools /etc/init.d/open-vm-tools
lbu add /root/.config/init.d/open-vm-tools
lbu add /etc/init.d/open-vm-tools


apk add iptables ip6tables
rc-update add iptables
iptables -t nat -N clash
iptables -t nat -A clash -d 10.0.0.0/24 -j RETURN
iptables -t nat -A clash -p tcp -j RETURN -m mark --mark 0xff
iptables -t nat -A clash -p tcp -j REDIRECT --to-ports 7892
iptables -t nat -A PREROUTING -p tcp -j clash
/etc/init.d/iptables save
mv /etc/init.d/iptables /root/.config/init.d/
mv /etc/init.d/ip6tables /root/.config/init.d/
ln -s /root/.config/init.d/iptables /etc/init.d/iptables
ln -s /root/.config/init.d/ip6tables /etc/init.d/ip6tables
lbu add /root/.config/init.d/iptables
lbu add /etc/init.d/iptables
lbu add /root/.config/init.d/ip6tables
lbu add /etc/init.d/ip6tables


lbu ci sda

exit 0