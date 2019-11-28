#! /bin/bash -i
# 参数4 控制是否只打包镜像,参数5控制是否只发布
#source /etc/profile.d/rancher.sh
#bash -l /JAR_DIR/jenkins-config/02_release.sh $i $branch $envs $build $release $port $use_base $appdir ||{ echo $i $envs $branch  >> $faild ;exitcode=1; continue;}

cd $(dirname $0)  # 进入脚本所在目录
# $1 i:项目名 $2 branch:分支 $3 envs:环境名 $4 build:是否打包 $5 release:是否发布 $6 port:是否开放端口 $7 use_base:是否使用基础配置
p=$1
b=$2
[[ "$p" == "" ]] && echo "未指定项目名, 退出 "&&exit 1
[[ "$b" == "" ]] && echo "未指定分支" && exit 1
[[ "$(awk '{print $4}' gitrepo.sh | grep -w $p)" == "" ]] && echo "未找到该项目,退出" && exit 1
release() {
  # 增加判断项目是否存在
  #  awk '$4 ~/^'"library"'$/{$5="\"'master'\"";print }' gitrepo.sh
  #  sh build3.sh ssh://git@g.km365.pw:122/backend/caselibrary.git library "master" true
  awk '$4 ~/^'"$p"'$/{$5="\"'$b'\"";print }' gitrepo.sh
}
envs=$3
[[ "$envs" == "" ]] &&  echo "未指定发布环境, 退出"&&exit 1

if [[ "$4" != "notbuild" ]]; then
  #  build3.sh ssh://git@g.km365.pw:122/backend/caselibrary.git library
  release $1 $2 | bash || {
    echo "打包未成功, 不继续执行后续动作" ;
    exit 1
  }
else
  echo "已选择不打包,跳过打包"
fi

echo "-------更新项目-----------"
# 前端项目列表，改为从配置中最后一列判断 #if { [[ "student-h5 admin wmypc wmyPc" =~ "$1" ]] && [[ "$1" != "student" ]]; }
ptype=$(awk '$4 ~/^'"$p"'$/{$5="\"'$b'\"";print $NF }' gitrepo.sh)
if [[ "$5" != "notrelease" ]]; then
  p=$1  # 更新分支
  b=$2
  b=${b##*-->}  # 修正分支合并的情况
  branch=$b
  port=$6     # 是否暴露端口
  use_base=$7 # 是否使用公共配置
  if [[ $p == "gateway" ]]; then
    port=true
  elif [[ "$envs" == "dev" ]]; then
    port=true
  elif [[ "$envs" == "sit" ]]; then
    port=true
  fi
  if [[ "$ptype" == "frontend" ]]; then
    echo "前端项目${1}发布,环境为$envs"
    # 获取脚本最后一个参数，前端项目存储路径
    for appdir; do true; done
    if [[ ${appdir:0:1} != "/" ]]; then
      echo "前端项目路径($appdir)指定不正确,需指定为绝对路径"
      exit 1
    fi
    version="latest"  # 前端镜像版本默认用最新的
    bash /JAR_DIR/jenkins-config/frontend/frontend.sh $p $b $envs $version $appdir
  else
    echo upjob $envs $p
    upjob $envs $p
  fi
else
  echo "已选择不发布，跳过发布"
fi
