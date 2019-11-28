#!/usr/bin/env bash
mkdir -p /home/file /customproject /logs

mkdir -p wmy sit
port=31001
expose_ip=192.168.0.173
for i in eureka aliyun assignment certificate config course customproject enroll esearch exam gateway job live log manage message point research shenwanhongyuan sign site statistics student studylog system trainning vote wechat lecturer;
do echo $i;sed "s/lecturer/$i/g" base.yaml |sed  "s/#PORT/$port/g" >wmy/$i.yaml;
echo "$i ${expose_ip}:$port" >> svc.txt
let port=port+1
done


port=31001
expose_ip=192.168.1.114
active=dev
mkdir -p $active
rm -rf $active.svc.txt
for i in eureka aliyun assignment certificate config course customproject enroll esearch exam gateway job live log manage message point research shenwanhongyuan sign site statistics student studylog system training vote wechat lecturer;
do echo $i;sed "s/lecturer/$i/g;s/#PORT/$port/g;s/active: sit/active: $active/g" base.yaml >$active/$i.yaml;
echo "$i ${expose_ip}:$port" >> $active.svc.txt
let port=port+1
done


# 指定目录
port=31001
expose_ip=192.168.1.114
active=dev
dir=dev-jykl
mkdir -p $dir
rm -rf dir.svc.txt
for i in eureka aliyun assignment certificate config course customproject enroll esearch exam gateway job live log manage message point research shenwanhongyuan sign site statistics student studylog system training vote wechat lecturer;
do echo $i;sed "s/lecturer/$i/g;s/#PORT/$port/g;s/active: sit/active: $active/g" base.yaml >$dir/$i.yaml;
echo "$i ${expose_ip}:$port" >> $dir.svc.txt
let port=port+1
done

# 生成rancher-compose





# start.sh


env=dev

drc up  -p -d --force-upgrade  -c --stack $env --rancher-file=rancher-compose/rancher.yaml

for i in eureka config aliyun assignment certificate  course customproject enroll esearch exam gateway job live log manage message point research shenwanhongyuan sign site statistics student studylog system training vote wechat lecturer;
do echo $i;
   drc up  -p -d --force-upgrade  -c --stack $env -f $i.yaml --rancher-file=../rancher-compose/$i.rancher.yaml

done


addsvc(){
 i=$1
drc up  -p -d --force-upgrade  -c --stack $env -f $i.yaml
}