# 数据库 80 ；81（后备，暂时不用1）(主主，nginx 113-负载)

# rancher集群
## server  82 83 113(暴露公网，网关) --->数据库--80
## agent  82 83 114

# 清除所有容器
docker rm -f `docker ps -aq`

#部署数据库等 80
mysql5.7 (80, 81)---> rancher集群
mysql5.6  80  ---->应用服务
redis
rabbitmq

# mysql57 主主  80 81 分别执行
mysqldir=/SSD/mysql57
master_cnf=/etc/mysql/mysql57_docker/my.master.cnf
slave_cnf=/etc/mysql/mysql57_docker/my.slave.cnf
mkdir -p $mysqldir
#80
docker run --name m57-master -d -p 3307:3306 -e MYSQL_ROOT_PASSWORD=cattle -e TZ="Asia/Shanghai" -v $mysqldir:/var/lib/mysql -v $master_cnf:/etc/mysql/my.cnf mysql:5.7
#81
docker run --name m57-slave -d -p 3307:3306 -e MYSQL_ROOT_PASSWORD=cattle -e TZ="Asia/Shanghai" -v $mysqldir:/var/lib/mysql -v $slave_cnf:/etc/mysql/my.cnf mysql:5.7
# 做主主配置
#######
# m1 
GRANT REPLICATION SLAVE ON *.* to 'slave'@'%' identified by '123456';
flush PRIVILEGES;
show master status;
# mysql-bin.000003	582

#m2
change master to master_host='192.168.1.80',master_user='slave',master_password='123456',master_log_file='mysql-bin.000003',master_log_pos=590,master_port=3307;
start slave ;


# 反向配置
#m2

GRANT REPLICATION SLAVE ON *.* to 'slave'@'%' identified by '123456';
flush PRIVILEGES;

show master status;

#mysql-bin.000003	1438

#m1

change master to master_host='192.168.1.81',master_user='slave',master_password='123456',master_log_file='mysql-bin.000003',master_log_pos=590,master_port=3307;
start slave ;

########
#redis
redisdir=/SSD/redisdata
mkdir -p $redisdir
docker run --cpus=8 --memory=8G --restart=always --name=redis -v $redisdir:/data --net=host -d redis:4.0 --requirepass 'C2!LG!Ay$6qJiUWH' --appendonly yes --appendfsync everysec
#mysql 

scp -r mysql:/root/backinfo/var/lib/mysql /SSD/mysql56
mkdir -p /var/log/mysql56
 docker run --cpus=16 --memory=10G  --restart=always  --name=mysql  -v /etc/mysql/mysql_docker/my.cnf:/etc/mysql/my.cnf -v /SSD/mysql56/mysql/:/var/lib/mysql -v /var/log/mysql56:/var/log/mysql -e MYSQL_ROOT_PASSWORD='Yo^!3@LTvBJvtFHy' -e TZ="Asia/Shanghai"  --net=host -d mysql:5.6

#rabbitmq
scp -r mysql:/var/lib/rabbitmq /SSD/
docker run  --cpus=4 --memory=8G -d --restart=always --net=host -v /SSD/rabbitmq:/var/lib/rabbitmq  --name=rabbitmq -e RABBITMQ_DEFAULT_VHOST='/wmy' -e RABBITMQ_DEFAULT_USER=root -e RABBITMQ_DEFAULT_PASS=rabbitmq.linuxs  rabbitmq:3.7-management


## rancher集群


登录数据库创建cattle库
CREATE DATABASE IF NOT EXISTS cattle COLLATE = 'utf8_general_ci' CHARACTER SET = 'utf8';
GRANT ALL ON cattle.* TO 'cattle'@'%' IDENTIFIED BY 'cattle';
GRANT ALL ON cattle.* TO 'cattle'@'localhost' IDENTIFIED BY 'cattle';
# 每个节点均执行
#模拟高可用数据库
 
docker run  -d --add-host myhost.example.com:192.168.1.80 --name rancher-server --restart=unless-stopped -p 8080:8080 -p 9345:9345 rancher/server \
     --db-host myhost.example.com --db-port 3307 --db-user cattle --db-pass cattle --db-name cattle \
     --advertise-address 192.168.1.82

#agent
sudo docker run -e CATTLE_AGENT_IP="192.168.1.83"  --rm --privileged -v /var/run/docker.sock:/var/run/docker.sock -v /var/lib/rancher:/var/lib/rancher rancher/agent:v1.2.11 http://192.168.1.113:8080/v1/scripts/3A48564A1DDF65E40474:1546214400000:NfSNpsHtGEDTm8hzVFaLbeE0g

