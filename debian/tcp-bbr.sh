#!/bin/bash

# TCP 拥塞控制算法 BBR (Bottleneck Bandwidth and RTT) 可以让服务器的带宽尽量跑慢，
# 并且尽量不要有排队的情况，让网络服务更佳稳定和高效。

# 修改系统变量
echo net.core.default_qdisc=fq >> /etc/sysctl.conf
echo net.ipv4.tcp_congestion_control=bbr >> /etc/sysctl.conf

# 保存生效
sysctl -p

# 查看开启情况
sysctl net.ipv4.tcp_available_congestion_control
lsmod | grep bbr

exit 0