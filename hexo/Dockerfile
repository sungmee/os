FROM node:8.11.4-alpine

MAINTAINER M.Chan <mo@lxooo.com>

# 更换软件源
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories

# 更新并安装 git openssh
RUN apk update \
    && apk upgrade \
    && apk add --no-cache git openssh \
    && rm -rf /var/cache/apk/*

# 设置工作路径
WORKDIR /hexo

# 更换 node 源并全局安装 hexo
RUN npm config set registry http://registry.npm.taobao.org \
    && npm install hexo-cli -g

# 暴露路径
VOLUME ["/hexo", "/root/.ssh"]

# 暴露端口
EXPOSE 4000

# 拷贝启动脚本
COPY docker-entrypoint.sh /docker-entrypoint.sh

ENTRYPOINT ["/docker-entrypoint.sh"]

CMD ['/bin/ash']
