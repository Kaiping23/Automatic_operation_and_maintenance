#!/usr/bin/env bash
# 前端代码发布脚本， 需放置在web服务器/var/www/script 下
release_docker_front(){
appname=$1 # 项目名
branch=$2 # 分支名
version=$3 # 版本号
appdir=$4 # 增加项目项目存储路径，为同一服务器多套前端代码预留接口
[[ "" != "$appname" ]] || { echo 未指定应用名字 && exit 1;}
[[ "" != "$branch" ]] || { echo 未指定分支 && exit 1;}
[[ "" != "$version" ]] || { echo 未指定版本标签,使用latest && version=latest;}
[[ "" != "$appdir" ]] || { echo 使用默认项目存储路径 /var/www/project && appdir="/var/www/project";}
echo "项目存储路径为:$appdir"
baseurl=`{ ping -c 1 -W 1 registry-vpc.cn-shanghai.aliyuncs.com &>/dev/null && echo registry-vpc.cn-shanghai.aliyuncs.com || echo registry.cn-shanghai.aliyuncs.com; }`
docker login --username=复深蓝开发一中心研发 --password=fulan123wmy $baseurl &>/dev/null
image="${baseurl}/wmy-frontend/${appname}-${branch}:${version}"
docker pull $image  >/dev/null || { echo 拉取镜像失败&&exit 1 ;}
mkdir -p $appdir/$appname
rm -rf $appdir/$appname/*
docker run --rm  --name=$appname -v $appdir/$appname:/var/www/project/$appname $image &>/dev/null
echo "版本信息如下："
cat $appdir/$appname/dist/version_v/version.html
docker rmi $image &>/dev/null
}


release_url_front(){
appname=$1 # 项目名
branch=$2 # 分支名
version=$3 # 版本
appdir=$4 # 增加项目项目存储路径，为同一服务器多套前端代码预留接口
[[ "" != "$appname" ]] || { echo 未指定应用名字 && exit 1;}
[[ "" != "$branch" ]] || { echo 未指定分支 && exit 1;}
[[ "" == "$version" ]] || { echo 未指定版本标签,使用项目最新文件 && version="";}
[[ "" != "$appdir" ]] || { echo 使用默认项目存储路径 /var/www/project && appdir="/var/www/project";}
echo "项目存储路径为:$appdir"
baseurl=`{ ping -c 1 -W 1 customproject.oss-cn-shanghai-internal.aliyuncs.com &>/dev/null && echo customproject.oss-cn-shanghai-internal.aliyuncs.com || echo customproject.oss-cn-shanghai.aliyuncs.com; }`
if [[ "" == "$version" ]]
then image="http://${baseurl}/jarfile/${branch}/${appname}/${appname}.tar.gz"
elif [[ "latest" == "$version" ]]
then image="http://${baseurl}/jarfile/${branch}/${appname}/${appname}.tar.gz"
else image="http://${baseurl}/jarfile/${branch}/${appname}/${version}/${appname}.tar.gz"
fi
mkdir -p $appdir/$appname
curl -sSLf $image > $appdir/${appname}.tar.gz || { echo 下载静态文件包失败&&exit 1 ;}
rm -rf $appdir/$appname/*
tar zxf $appdir/$appname.tar.gz -C $appdir/$appname/  || { echo 解压静态文件包失败&&exit 1 ;}
echo
echo "版本信息如下："
cat $appdir/$appname/dist/version_v/version.html
}



if  which docker &>/dev/null
then release_docker_front  $1 $2 $3 $4
elif which curl &>/dev/null
then release_url_front $1 $2 $3 $4
else echo 目标服务器不存在docker或curl无法更新服务,发布失败 && exit 1
fi

if [[ $? == 0 ]]  ; then echo "*****************发布成功*****************"; else echo "*****************发布失败*****************"; fi
