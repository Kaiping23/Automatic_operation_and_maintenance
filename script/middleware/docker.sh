# redis-4.0
mkdir -p /var/lib/redis/data
docker run --cpus=4 --memory=8G --restart=always --name=redis -v /var/lib/redis/data:/data --net=host -d redis:4.0 --requirepass 'C2!LG!Ay$6qJiUWH' --appendonly yes --appendfsync everysec
#mysql-5.6
mkdir -p /var/lib/mysql /var/log/mysql
docker run --cpus=4 --memory=13G  --restart=always  --name=mysql  -v /etc/mysql-docker/my.cnf:/etc/mysql/my.cnf -v /var/lib/mysql:/var/lib/mysql -v /var/log/mysql56:/var/log/mysql -e MYSQL_ROOT_PASSWORD='Yo^!3@LTvBJvtFHy' -e TZ="Asia/Shanghai"  --net=host -d mysql:5.6

docker run --cpus=16 --memory=10G  --restart=always  --name=mysql  -v /etc/mysql-docker/my.cnf:/etc/mysql/my.cnf -v /var/lib/mysql56:/var/lib/mysql -v /var/log/mysql56:/var/log/mysql -e MYSQL_ROOT_PASSWORD='123456' -e TZ="Asia/Shanghai"  --net=host -d mysql:5.6

#rabbitmq-3.7


mkdir -p /var/lib/rabbitmq /etc/rabbitmq
docker run  --cpus=4 --memory=8G -d --restart=always --net=host -v /var/lib/rabbitmq:/var/lib/rabbitmq  --name=rabbitmq -e RABBITMQ_DEFAULT_VHOST='/wmy' -e RABBITMQ_DEFAULT_USER=root -e RABBITMQ_DEFAULT_PASS=rabbitmq.linuxs  rabbitmq:3.7-management

#elasticsearch
 echo '127.0.0.1 mysql elasticsearch elasticsearch.elasticsearch' >> /etc/hosts

 mkdir -p /dockerfile/elasticsearch-data
 chmod 777 /dockerfile/elasticsearch-data
 docker run -p 9200:9200 -p 9300:9300 -d --name es-node01 --restart=always  -v /dockerfile/elasticsearch-data:/usr/share/elasticsearch/data  -e "discovery.type=single-node" registry.cn-shanghai.aliyuncs.com/wmy/elasticsearch-6.5.3
 docker run -d --name logstash --restart=always --log-driver=json-file  --log-opt max-size=100m --log-opt max-file=3 --net=host -e 'relaseENV=dev' registry.cn-shanghai.aliyuncs.com/wmy/logstash




#
cd rancher-compose

