#! /bin/bash

# Commonly Used Aliases
alias getlogs="cat ~/.bitcoin/debug.log"
alias cleanlogs='echo "" > ~/.bitcoin/debug.log'
alias cli='omnicore-cli -conf=/home/wallet/bitcoin.conf'

# 返回客户端和协议的各种状态信息
alias getinfo="omnicore-cli -conf=/home/wallet/bitcoin.conf omni_getinfo"

#备份钱包
alias backupwallet="omnicore-cli -conf=/home/wallet/bitcoin.conf backupwallet /home/wallet/wallet.dat"

# 导出私钥 `dumpprivkey <address>`
alias dumpprivkey="omnicore-cli -conf=/home/wallet/bitcoin.conf dumpprivkey"

# 生成BTC、USDT地址 `omnicore-cli getnewaddress <account>`
alias getnewaddress="omnicore-cli -conf=/home/wallet/bitcoin.conf getnewaddress"

# 显示钱包当前的所有地址的余额总和
alias getbalance="omnicore-cli -conf=/home/wallet/bitcoin.conf getbalance"

# 查询指定地址余额 `omni_getbalance <address> <令牌id>`
alias omni_getbalance="omnicore-cli -conf=/home/wallet/bitcoin.confomni_getbalance"

# 查询钱包内的所有地址的USDT余额列表
alias omni_getwalletaddressbalances="omnicore-cli -conf=/home/wallet/bitcoin.conf omni_getwalletaddressbalances"
alias ye="omnicore-cli -conf=/home/wallet/bitcoin.conf omni_getwalletaddressbalances"

# 查询钱包内的USDT总额
alias omni_getwalletbalances="omnicore-cli -conf=/home/wallet/bitcoin.conf omni_getwalletbalances"

# 解密
alias jm='_jm(){ omnicore-cli -conf=/home/wallet/bitcoin.conf walletpassphrase $1 300; }; _jm'

# 转账 omni_funded_send <fromaddress> <toaddress> <propertyid> <amount> <feeaddress?>
alias omni_funded_send="omnicore-cli -conf=/home/wallet/bitcoin.conf omni_funded_send"
# 转账 zz <fromaddress> <toaddress> <propertyid> <amount> <feeaddress?>
alias zz='_zz(){ omnicore-cli -conf=/home/wallet/bitcoin.conf omni_funded_send $1 $2 31 $3 $1; }; _zz'
alias zzf='_zzf(){ omnicore-cli -conf=/home/wallet/fee.conf omni_funded_send $1 $2 31 $3 $1; }; _zzf'

# 查询交易事务 `omni_gettransaction <事务 hex>`
alias omni_gettransaction="omnicore-cli -conf=/home/wallet/bitcoin.conf omni_gettransaction"

# 查询本地事务列表 `omni_listtransactions <addfilt> <count> <skip> <startblock> <endblock>`
alias omni_listtransactions="omnicore-cli -conf=/home/wallet/bitcoin.conf omni_listtransactions"