
DIST_IP=10.23.1.161

echo "`ps -ef|grep jar`"
ssh $DIST_IP ps -ef|grep jar 


DIST_IP=10.23.1.161
PROC = `ssh $DIST_IP ps -ef|grep jar |awk '{print $2}'`
echo "$PROC"
ssh $DIST_IP kill $process

ssh $DIST_IP mv /root/super-office-api.jar /root/super-office-api.jar.bak`date "+%Y-%m-%d"` &&  mv /root/website-api.jar /root/website-api.jar.bak`date "+%Y-%m-%d"`


DIST_IP=10.10.12.24
DIST_IP=10.23.1.161
scp /home/jenkins/workspace/super-office-api/super-office/super-office-api/target/super-office-api.jar $DIST_IP:/root/
scp /home/jenkins/workspace/website-api/website-api/target/website-api.jar $DIST_IP:/root/



nohup java -Xms512M -Xmx1G -jar super-office-api.jar --spring.profiles.active=prod > /logs/sit-super-office-api.log &
nohup java -Xms512M -Xmx1G -jar website-api.jar --spring.profiles.active=prod > /logs/sit-website-api.log &



DIST_IP=10.23.1.161

nohup java -Xms512M -Xmx1G -jar super-office-api.jar --spring.profiles.active=sit > /logs/sit-super-office-api.log &
nohup java -Xms512M -Xmx1G -jar website-api.jar --spring.profiles.active=sit > /logs/sit-website-api.log &

ssh $DIST_IP nohup java -Xms512M -Xmx1G -jar super-office-api.jar --spring.profiles.active=sit > sit-super-office-api.log &

ssh $DIST_IP nohup java -Xms512M -Xmx1G -jar website-api.jar --spring.profiles.active=sit > sit-website-api.log &


DIST_IP=10.23.1.161

scp /home/jenkins/workspace/website-api/website-api/target/website-api.jar $DIST_IP:/root/




DIST_IP=10.10.12.24
scp /home/jenkins/workspace/super-office-api-prod/super-office/super-office-api/target/super-office-api.jar $DIST_IP:/root/

PROC = `ssh $DIST_IP ps -ef|grep super-office |awk '{print $2}'`
echo "$PROC"
ssh $DIST_IP kill $process

ssh $DIST_IP nohup java -Xms512M -Xmx1G -jar super-office-api.jar --spring.profiles.active=prod > super.log  2>&1 &


export MINIO_ACCESS_KEY=YKHFIAHHRWMHRZDX
export MINIO_SECRET_KEY=J2TZmIRlkooP4Df*


source /etc/profile
project=super-office-api
dir=/root/
pid=`ps -ef | grep $project | grep -v grep | awk '{print $2}'`
if [ -n "$pid" ]
then
    kill -9 $pid && echo "已关闭进程---$project "
else
    echo "没有这个进程"
    
fi


source /etc/profile
project=super-office-api
dir=/root/
DIST_IP=10.10.12.24
pid=`ssh DIST_IP ps -ef | grep $project | grep -v grep | awk '{print $2}'`
if [ -n "$pid" ]
then
    kill -9 $pid && echo "已关闭进程---$project "
else
    echo "没有这个进程"
    
fi




#!/usr/bin/env bash
source /etc/profile
project=super-office-api.jar
dir=/root/
DIST_IP=10.10.12.24

scp /home/jenkins/workspace/super-office-api-prod/super-office/super-office-api/target/super-office-api.jar $DIST_IP:/root/
#scp /home/jenkins/workspace/website-api/website-api/target/website-api.jar $DIST_IP:/root/

pid=`ssh DIST_IP ps -ef | grep $project | grep -v grep | awk '{print $2}'`
if [ -n "$pid" ]
then
    ssh DIST_IP kill -9 $pid && echo "已关闭进程---$project "
else
    echo "没有这个进程"
    
fi


DIST_IP=10.10.12.24
project=super-office-api
ssh $DIST_IP nohup /opt/java/bin/java -Xms512M -Xmx1G -jar /root/$project.jar > $project.log  2>&1 &

#ssh $DIST_IP nohup /opt/java/bin/java -Xms512M -Xmx1G -jar /root/super-office-api.jar --spring.profiles.active=site







#!/usr/bin/env bash -l
DIST_IP=10.10.12.24
scp /home/jenkins/workspace/super-office-api-prod/super-office/super-office-api/target/super-office-api.jar $DIST_IP:/root/
#scp /home/jenkins/workspace/website-api/website-api/target/website-api.jar 10.23.1.161:/root/

PROC=`ssh $DIST_IP ps -ef|grep super-office-api|grep -v grep |awk '{print $2}'`
echo "进程号为：$PROC" || echo "没有这个进程" 
ssh $DIST_IP kill -9 $PROC 

ssh $DIST_IP nohup /opt/java/bin/java -Xms512M -Xmx1G -jar /root/super-office-api.jar --spring.profiles.active=prod &


echo `ssh $DIST_IP ps -ef|grep super-office-api`
#ssh $DIST_IP nohup /opt/java/bin/java -Xms512M -Xmx1G -jar /root/super-office-api.jar --spring.profiles.active=site





https://oss-cn-shanghai.aliyuncs.com itrainning-tmp.oss-cn-shanghai.aliyuncs.com
https://itrainning-tmp.oss-cn-shanghai.aliyuncs.com
LTAI4G9XXaPkPAkU9r4rYan1
TKcJP2LxmGJtuDnHgIJSG1uzdL1A4G


cd $WORKSPACE/super-office/super-office-api/target/
pwd
ls -lah
DIST_IP=10.10.12.24
ENVV=sit
project=super-office-api.jar
scp super-office-api.jar $DIST_IP:/root/ && echo "scp ---ok---"


pid=`ssh $DIST_IP ps -ef | grep $project | grep -v grep | awk '{print $2}'`
if [ -n "$pid" ]
then
    ssh $DIST_IP kill -9 $pid && echo "已关闭进程---$project "
else
    echo "没有这个进程"
    
fi


ssh $DIST_IP nohup /opt/java/bin/java -Xms512M -Xmx1G -jar /root/$project --spring.profiles.active=prod &



#!/usr/bin/env bash -l
pwd
ls -lah
DIST_IP=10.23.1.161

project1=super-office-api.jar
project2=website-api.jar
ENVV=sit

scp /home/jenkins/workspace/super-office-api/super-office/super-office-api/target/$project1 $DIST_IP:/root/ && echo "--- scp $project1 sucess ---"
scp /home/jenkins/workspace/website-api/website-api/target/$project2 $DIST_IP:/root/  && echo "--- scp $project2 sucess ---"


pid1=`ssh $DIST_IP ps -ef | grep $project1 | grep -v grep | awk '{print $2}'` && echo "--- pid1--- $pid1 ---"

if [ -n "$pid1" ]
then
    ssh $DIST_IP kill -9 $pid1 && echo "app1已关闭进程---$project1 "
else
    echo "$project1没有这个进程"
    
fi

pid2=`ssh $DIST_IP ps -ef | grep $project2 | grep -v grep | awk '{print $2}'` && echo "--- pid2--- $pid2 ---"

if [ -n "$pid2" ]
then
    ssh $DIST_IP kill -9 $pid2 && echo "已关闭进程---$project2 "
else
    echo "$project2 没有这个进程"
    
fi

sleep 10

ssh $DIST_IP nohup /opt/java/bin/java -Xms512M -Xmx1G -jar /root/$project1 --spring.profiles.active=$ENVV &
sleep 10

ssh $DIST_IP nohup /opt/java/bin/java -Xms512M -Xmx1G -jar /root/$project2 --spring.profiles.active=$ENVV &

sleep 10

echo `ssh $DIST_IP ps -ef | grep $project1 | grep -v grep `
sleep 10
echo `ssh $DIST_IP ps -ef | grep $project2 | grep -v grep `






DIST_IP1=10.10.12.24
DIST_IP2=10.10.12.25
project=super-office-api.jar

scp $project $DIST_IP1:/root/ && echo "--- scp app1 sucess ---"
scp $project $DIST_IP2:/root/ && echo "--- scp app2 sucess ---"

pid1=`ssh $DIST_IP1 ps -ef | grep $project | grep -v grep | awk '{print $2}'`

if [ -n "$pid1" ]
then
    ssh $DIST_IP1 kill -9 $pid1 && echo "app1已关闭进程---$project "
else
    echo "app1没有这个进程"
    
fi

pid1=`ssh $DIST_IP2 ps -ef | grep $project | grep -v grep | awk '{print $2}'`

if [ -n "$pid2" ]
then
    ssh $DIST_IP2 kill -9 $pid2 && echo "已关闭进程---$project "
else
    echo "app2没有这个进程"
    
fi

sleep 10

ssh $DIST_IP1 nohup /opt/java/bin/java -Xms512M -Xmx1G -jar /root/$project --spring.profiles.active=prod &
sleep 10

ssh $DIST_IP2 nohup /opt/java/bin/java -Xms512M -Xmx1G -jar /root/$project --spring.profiles.active=prod &

sleep 10

echo `ssh $DIST_IP1 ps -ef | grep $project | grep -v grep `

echo `ssh $DIST_IP2 ps -ef | grep $project | grep -v grep `



















