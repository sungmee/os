FROM p3terx/openwrt-build-env:18.04

LABEL maintainer="M.Chan <mo@lxooo.com>"

RUN touch /home/user/.ssh/authorized_keys \
    && chmod 600 /home/user/.ssh/authorized_keys \
    && echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDXuZegS5W/Pt2fwoa550ighgACMsKG5xXOW62Um0R7YOUdtyKXuMmfKcGztCrxlxVW4/rWYikefGySmzvi8bFS/zETQW2eK5FPRVsJnzMKxXT6zniPWa38V1uxyIJ3Mr2+7YN9egVOVJ857okasoQIodvU63GtHac/iAGV7ivHz1jU1yWbnfK2fk2Gyy1XjdJEgWx71NsW1+72A/qGy+3P12zKA9IigNLYEtXcnwyYUgjrNqmGcgo/peiSQK+jYzftug5I2NLVG4IkW/l34x/wqW1beW3mAvZYLwHjZaFlgYYtULd1RePfjukfzFOASCNzXKeYguZLa/hJcOaN0Uqh m@air" >> /home/user/.ssh/authorized_keys \
    && echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCp7jaqwUsC/lrhry10C5zPww2nURKZg/WAAGDNobtPQjcE4sFCYXrh78b9pxwW1Qz1yYdoVEbh2DAXpR5Y5I1MiQ6gjiSYoyWBTBv3vl5N2o4/KWuvXd6kWu31upD9f5jZY2rEsB+hfaGSxkjEMSgBlSJmMB9cQ0AJdmUdXwhHDL1IBiahiZchqj6kDoKDcYgtdu3WI890vAz7uijHOg61EzqIG6V8MzobwwKpNQ1j2w4ea1V/bPjX+v0ybqcItYyrmqtEnZtzBtPNHn6mFmgN5y3krtMSlBV5SBkWRVSVYxtCndbbFwcB0AgkKOrXQfN6TechpGQkPeQtfYeZxgBx m@mini" >> /home/user/.ssh/authorized_keys \
    && echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAAAgQDDMrV6p/3igBXPIFxAZcKNBJyZxoKoUHknVQNZJD5gPOATNNglYpsJON3XP7Mz3vF7fh6q7tLP5Y625GXpktzO7qe2maoAKGnttjpAxCMJVUvjHx9YpCHo6jS2KmZ6AC8Gz+3+gQIDbnuUm4njovrjDpY9WA0h1bKrTpkdbR4xHw== m@6s" >> /home/user/.ssh/authorized_keys

RUN sudo sed -i '/PasswordAuthentication /c\PasswordAuthentication no' /etc/ssh/sshd_config
