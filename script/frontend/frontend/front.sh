#!/usr/bin/env bash
docker login --username=复深蓝开发一中心研发 --password=fulan123wmy registry.cn-shanghai.aliyuncs.com
docker login --username=复深蓝开发一中心研发 --password=fulan123wmy registry-vpc.cn-shanghai.aliyuncs.com
frontend(){
appname=$1
docker pull registry.cn-shanghai.aliyuncs.com/wmy-frontend/$appname-develop:latest
echo docker run --rm  --name=$appname -v /var/www/project:/var/www/project registry.cn-shanghai.aliyuncs.com/wmy-frontend/$appname-develop:latest|bash

}
frontend admin


# registry.cn-shanghai.aliyuncs.com/wmy-frontend/admin-jykl_admin:20190531
mkdir -p /var/www/project
docker pull registry.cn-shanghai.aliyuncs.com/wmy-frontend/admin-jykl_admin:latest
docker run --rm  --name=admin -v /var/www/backup:/var/www/project registry.cn-shanghai.aliyuncs.com/wmy-frontend/admin-jykl_admin:latest

docker login --username=复深蓝开发一中心研发 --password=fulan123wmy registry.cn-shanghai.aliyuncs.com
mkdir -p /var/log/nginx/health_check /logs/ /home/file
active=dev
eureka=http://192.168.1.114:31001/eureka/
appname=live
docker pull registry.cn-shanghai.aliyuncs.com/wmy-backend/$appname-develop_jykl:latest
docker run -d --restart=always  --name $appname -v /logs:/logs -v /customproject:/CodePackage -v /home/file:/home/file registry.cn-shanghai.aliyuncs.com/wmy-backend/$appname-dev-release:latest $appname $active $eureka


#

 curl -sSLf -x 180.169.149.5:13128 http://customproject.oss-cn-shanghai.aliyuncs.com/jarfile/develop_jykl/admin/admin.tar.gz > /var/www/project/admin.tar.gz
 rm -rf /var/www/project/admin/*
 tar zxvf /var/www/project/admin.tar.gz -C /var/www/project/admin/

app=student-h5
#app=admin
curl -sSLf -x 180.169.149.5:13128 http://customproject.oss-cn-shanghai.aliyuncs.com/jarfile/develop_jykl/$app/$app.tar.gz > /var/www/project/$app.tar.gz
 rm -rf /var/www/project/$app/*
 tar zxvf /var/www/project/$app.tar.gz -C /var/www/project/$app/

