#!/usr/bin/env bash
# 前端发布脚本， 依赖配置文件 web.conf 执行脚本所在服务器需要免登陆配置中的各服务器
script_dir=`dirname $0`
appname=$1 # 项目名
branch=$2 # 分支名
envs=$3 # 环境
version=$4 # 版本
appdir=$5 # 增加项目项目存储路径，为同一服务器多套前端代码预留接口
[[ "" != "$appname" ]] || { echo 未指定应用名字 && exit 1;}
[[ "" != "$branch" ]] || { echo 未指定分支 && exit 1;}
[[ "" != "$envs" ]] || { echo 未指定发布环境 && exit 1;}
[[ "" != "$version" ]] || { echo 未指定版本标签,使用latest && version=latest;}
[[ "" != "$appdir" ]] || {  appdir="/var/www/project";}
docker login --username=复深蓝开发一中心研发 --password=fulan123wmy registry.cn-shanghai.aliyuncs.com &>/dev/null
docker login --username=复深蓝开发一中心研发 --password=fulan123wmy registry-vpc.cn-shanghai.aliyuncs.com &>/dev/null
for i in `grep -E "$envs" ${script_dir}/web.conf|awk '{split($2,a,",")}END{for(i in a){print a[i]}}'`
do
ip=`echo $i|awk -F":" '{print $1}'`
port=`echo $i|awk -F":" '{print $2}'`
[[ "$port" == "" ]] && port=22
echo "发布信息为: $envs $ip $appname $branch $version"
# 存在就不复制发布脚本
ssh -o StrictHostKeyChecking=no -p $port $ip "mkdir -p /var/www/script/" || { echo 连接$port $ip 失败; exit 1 ;}
# 前端发布脚本，依赖docker或者curl，优先使用docker发布
scp -P $port ${script_dir}/release_front.sh  $ip:/var/www/script/release_front.sh >/dev/null || { echo 连接$port $ip 复制脚本失败; exit 1 ;}
#
{ ssh -p $port $ip "bash /var/www/script/release_front.sh $appname $branch $version $appdir" ; code=$?; if [[ $code != 0 ]] ;then echo 更新 $envs \
  $ip $appname 失败 ;exitcode=$code;fi ; } &
done
wait
exit $exitcode
