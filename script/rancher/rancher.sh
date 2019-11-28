#!/usr/bin/env bash
 mkdir -p /var/lib/rancher-mysql /var/lib/rancher
 docker run -d -v /var/lib/rancher-mysql:/var/lib/mysql -v /var/lib/rancher:/var/lib/rancher --restart=always  --name=rancher-server -p 8080:8080 rancher/server
# 复制配置信息
mkdir -p /etc/rancher
scp conf/etc/rancher/*  /etc/rancher
scp conf/etc/profile.d/* /etc/profile.d/
chmod +x /etc/rancher/rancher
scp /etc/rancher/rancher /usr/bin
source /etc/profile
# project
scp -r backend/dev /etc/rancher