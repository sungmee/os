#!/bin/bash

export https_proxy=http://10.0.0.2:7890
export http_proxy=http://10.0.0.2:7890
export all_proxy=socks5://10.0.0.2:7891

ssh-keygen

cat ~/.ssh//id_rsa.pub
sleep 14

KEYS="~/.ssh/authorized_keys"

touch $KEY && chmod 600 $KEY

echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDXuZegS5W/Pt2fwoa550ighgACMsKG5xXOW62Um0R7YOUdtyKXuMmfKcGztCrxlxVW4/rWYikefGySmzvi8bFS/zETQW2eK5FPRVsJnzMKxXT6zniPWa38V1uxyIJ3Mr2+7YN9egVOVJ857okasoQIodvU63GtHac/iAGV7ivHz1jU1yWbnfK2fk2Gyy1XjdJEgWx71NsW1+72A/qGy+3P12zKA9IigNLYEtXcnwyYUgjrNqmGcgo/peiSQK+jYzftug5I2NLVG4IkW/l34x/wqW1beW3mAvZYLwHjZaFlgYYtULd1RePfjukfzFOASCNzXKeYguZLa/hJcOaN0Uqh m@air" >> $KEYS
echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC2yb9ZffG7R7mAu7EWBLoigFQrcNyRDIj6KcRrj44bC3G+TM4mmZh8ic6bOdjiOJ0han8itsV/lel/YPRkgS4pqOVsXawx9lE24FKmgV8YncQAkvXxrqUuxMTmg0F9mcokO2lMnP/WJlZjfJiVkrAEcbO+r4Q+lrevcWVxexCpa/i/sCSMB4k5Maic255iNAiuoBAODU0TC73T4ETC0zXhlpPHwWjqD9jZUUN/aV6+YZ7QaGveA00UHAIeHyHMC6YpUpT6NBt4NVghPa60U77hb12CaKkqqqrTWeXCSPJK88CBnbvDx4PtjNj1yhIJi9v28EbT+8YP8S7Kuh3Nqo19 root@Yogurt" >> $KEYS
echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCqmlUHAnRA9i+pcRdb3wpH/n5LtDkFTIdM8fAxYrj/DKN0pkudcfj8kgCHucTw1Kqfk0NHd1ZQbVjd8GMg08+DstNGkf2TTrNtpjPtg2HhijWxHVZqoif0EiHPnNYr7mWGxsayu4FRrYYVVWcSn4ZrcXFUeXgNyo1JP2gKR7hmbOTPntGGsDDloCnpOAgLsKcJV1tzrN08MImqs0FPK1MQRU7moajlvNPUyCWhKDsmUsFqXWm8UURHGgL3jJsuE76fa3YPty4l+9pN4M4L/3ZjCyjILKZ6pbF/vJgZpXcov6F2bSg/neUXq4E479mRFUlZLazY0wc6fPWuivZ0u94V shortcuts@iphone" >> $KEYS
echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAAAgQDDMrV6p/3igBXPIFxAZcKNBJyZxoKoUHknVQNZJD5gPOATNNglYpsJON3XP7Mz3vF7fh6q7tLP5Y625GXpktzO7qe2maoAKGnttjpAxCMJVUvjHx9YpCHo6jS2KmZ6AC8Gz+3+gQIDbnuUm4njovrjDpY9WA0h1bKrTpkdbR4xHw== m@6s" >> $KEYS
echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCp7jaqwUsC/lrhry10C5zPww2nURKZg/WAAGDNobtPQjcE4sFCYXrh78b9pxwW1Qz1yYdoVEbh2DAXpR5Y5I1MiQ6gjiSYoyWBTBv3vl5N2o4/KWuvXd6kWu31upD9f5jZY2rEsB+hfaGSxkjEMSgBlSJmMB9cQ0AJdmUdXwhHDL1IBiahiZchqj6kDoKDcYgtdu3WI890vAz7uijHOg61EzqIG6V8MzobwwKpNQ1j2w4ea1V/bPjX+v0ybqcItYyrmqtEnZtzBtPNHn6mFmgN5y3krtMSlBV5SBkWRVSVYxtCndbbFwcB0AgkKOrXQfN6TechpGQkPeQtfYeZxgBx m@mini" >> $KEYS

sh -c "$(wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"
sed -i -e "s/ZSH_THEME=.*/ZSH_THEME=\"ys\"/g" ~/.zshrc

echo "alias geth='docker exec -it ethereum geth --nousb'" >> ~/.zshrc
echo "alias stop='docker-compose -f /srv/docker/docker-compose.yaml stop'" >> ~/.zshrc

echo '' > ~/.bash_history

exit 0