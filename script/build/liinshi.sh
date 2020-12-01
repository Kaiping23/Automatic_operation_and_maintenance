# 构建环境的脚本

# 前期准备  rancher docker  nginx
# 数据库服务器 mysql redis rabbitmq elasticsearch 31
#应用服务器 2台 21 22
#web服务 1台 10

#中间件服务器
#mysql
mkdir -p /var/lib/mysql56 /var/log/mysql56
docker run --cpus=16 --memory=10G  --restart=always  --name=mysql  -v /etc/mysql/mysql_docker/my.cnf:/etc/mysql/my.cnf -v /var/lib/mysql56:/var/lib/mysql -v /var/log/mysql56:/var/log/mysql -e MYSQL_ROOT_PASSWORD='Yo^!3@LTvBJvtFHy' -e TZ="Asia/Shanghai"  --net=host -d mysql:5.6

#redis
redisdir=/SSD/redisdata
mkdir -p $redisdir
docker run --cpus=8 --memory=8G --restart=always --name=redis -v $redisdir:/data --net=host -d redis:4.0 --requirepass 'C2!LG!Ay$6qJiUWH' --appendonly yes --appendfsync everysec



#rabbitmq
mkdir -p /SSD/rabbitmq
docker run  --cpus=4 --memory=8G -d --restart=always --net=host -v /SSD/rabbitmq:/var/lib/rabbitmq  --name=rabbitmq -e RABBITMQ_DEFAULT_VHOST='/' -e RABBITMQ_DEFAULT_USER=root -e RABBITMQ_DEFAULT_PASS=rabbitmq.linuxs  rabbitmq:3.7-management
#防止应用报错无法启动，需预先创建队列

mkdir -p /opt/rabbitmq
docker run  --cpus=4 --memory=8G -d --restart=always --net=host -v /opt/rabbitmq:/var/lib/rabbitmq  --name=rabbitmq -e RABBITMQ_DEFAULT_VHOST='/' -e RABBITMQ_DEFAULT_USER=root -e RABBITMQ_DEFAULT_PASS=rabbitmq.linuxs  rabbitmq:3.7-management
#防止应用报错无法启动，需预先创建队列

#elasticsearch
#保留



# 创建后端应用

#rancher server -10
 mkdir -p /var/lib/rancher-mysql /var/lib/rancher
 docker run -d -v /var/lib/rancher-mysql:/var/lib/mysql -v /var/lib/rancher:/var/lib/rancher --restart=always  --name=rancher-server -p 8081:8080 rancher/server

#添加主机
sudo docker run -e CATTLE_AGENT_IP="192.168.1.22"  --rm --privileged -v /var/run/docker.sock:/var/run/docker.sock -v /var/lib/rancher:/var/lib/rancher rancher/agent:v1.2.11 http://192.168.1.10:8090/v1/scripts/3AC029BBBB5360537B95:1546214400000:3ObCP9PkcnDdXBNLOTPjlmIw9ZA

#添加域名访问

#安装nginx
#复制生产配置 如web1 /etc/nginx -> /opt/nginx/conf/
#配置rancher域名访问 参考uat 或者rancher文档

#注入jenkins（假如是linshi） 自定义环境名字，及对应配置
#jenkins所在服务器 /etc/rancher 下 加入 base.linshi.yaml  cli_linshi.json 注意与yaml文件内的active毫无关联
#apijson
#前端服务器注入jenkins
#/JAR_DIR/jenkins-config/frontend/web.conf
#在web服务器上创建项目存储路径
mkdir -p /var/www/mm/linshi
#修改配置信息
"""
1016  vim linshi.admin.conf
 1017  cd common_location/
 1018  ls
 1019  cp all_common.info linshi.all_common.info
 1020  vim linshi.all_common.info
 1022  less linshi.all_common.info
 1023  sed -i "s#http://gateway#http://linshi-gateway#" linshi.all_common.info
 1024  less linshi.all_common.info
 1025  cd ..
 1026  ls
 1027  less upstream-gateway.conf
 1028  vim upstream-gateway.conf
 1029  nginx -t
 1030  vim linshi.admin.conf
 1031  nginx -t
 1032  nginx -s reload
 1033  cd ..
 1034  ls
 1035  cd conf.d/common_location/
 1036  ls
 1037  vim linshi.all_common.info
 1038  nginx -t
 1039  cd ..
 1040  ls
 1041  vim linshi.admin.conf
 1042  nginx -t
 1043  mkdir -p /var/log/nginx/linshi/heart_check/
 1044  vim upstream-gateway.conf
 1045  nginx -t
 1046  nginx -s reload
 1047  ls
 1048  cp linshi.admin.conf linshi.student-h5.conf
 1049  vim linshi.student-h5.conf
 1050  nginx -t
 1051  nginx -sreload
 1052  nginx -s reload
 1053  vim linshi.student-h5.conf
 1054  ls /var/www/mm/linshi/student-ht/dist

"""
#以上操作为 创建admin student-h5 wmypc 公共配置 /etc/nginx/conf.d/common_location/linshi.all_common.info,1>修改其中的upstream名称，并配置对应的upstream
#2>修改其中的scorm proxy_pass地址，3> 修改health_check的日志保存路径(该接口是保存学习记录)， 3> 各自的服务架加载该公共配置，并配置自己的域名及项目存储路径
 #include /etc/nginx/conf.d/common_location/linshi.all_common.info;
  #      root    /var/www/mm/linshi/admin/dist;

#oss  customproject映射


#jenkins 启动后端、前端应用




#其他任务
#1.学时处理
1. 进入学时日志目录 /var/log/nginx/linshi/heart_check
2上传脚本
3.创建学习记录库的数据库账号
GRANT insert ON *.*
 TO studyuser@'%'
 IDENTIFIED BY 'studyuser@123';
 FLUSH PRIVILEGES;
4.修改脚本中的数据库
5.创建定时任务
#2elastic

#elasticsearch
 echo '127.0.0.1 mysql elasticsearch elasticsearch.elasticsearch' >> /etc/hosts

 mkdir -p /dockerfile/elasticsearch-data
 chmod 777 /dockerfile/elasticsearch-data
 docker run  --net=host -d --name es-node01 --restart=always  -v /dockerfile/elasticsearch-data:/usr/share/elasticsearch/data  -e "discovery.type=single-node" registry.cn-shanghai.aliyuncs.com/wmy/elasticsearch-6.5.3
 docker run -d --name logstash --restart=always --log-driver=json-file  --log-opt max-size=100m --log-opt max-file=3 --net=host -e 'relaseENV=dev' registry.cn-shanghai.aliyuncs.com/wmy/logstash

#备注 同步更新插件logstash 的配置  在173服务器上/opt/logstash-docker
#更新配置后，执行 push.sh 重新打包发布即可
启动esearch服务即可


# 构建完成




############### 修改环境

192.168.0.145:8088   admin/Harb123#

192.168.0.151

GRANT ALL PRIVILEGES ON  *.* TO 'root'@'%' IDENTIFIED BY 'Qwe123!@#';
FLUSH PRIVILEGES;

GRANT ALL PRIVILEGES ON  *.* TO 'ddhSitadmin'@'%' IDENTIFIED BY 'ddh^Sit3306';
FLUSH PRIVILEGES;

ddhSitadmin	ddh^Sit3306
ddh^Dev3306

SitDdh^redis6379




