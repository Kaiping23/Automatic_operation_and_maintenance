#! /bin/bash -i
# 参数4 控制是否只打包镜像,参数5控制是否只发布
#source /etc/profile.d/rancher.sh
 
cd `dirname $0`

# $1 项目名
# $2 分支
p=$1
b=$2
[[ "$p" == "" ]] && echo 未指定项目名，退出&&exit 1
[[ "$b" == "" ]] && echo 未指定分支，退出&&exit 1
[[ "`awk '{print $4}' gitrepo.sh| grep -w $p `" == "" ]] && echo 未找到该项目退出 && exit 1
release(){
# 增加判断项目是否存在
awk '$4 ~/^'"$p"'$/{$5="\"'$b'\"";print }' gitrepo.sh

}
envs=$3
[[ "$envs" == "" ]] && echo 未指定发布环境，退出&&exit 1

if [[ "$4" != "notbuild" ]]
then 
   release $1 $2 |bash || { echo 打包未成功，不继续执行后续动作;exit 1; }
else echo 已选择不打包，跳过打包
fi


echo -------更新项目-----------
# 前端项目列表，改为从配置中最后一列判断
#if { [[ "student-h5 admin wmypc wmyPc" =~ "$1" ]] && [[ "$1" != "student" ]]; }
ptype=`awk '$4 ~/^'"$p"'$/{$5="\"'$b'\"";print $NF }' gitrepo.sh`

if [[ "$5" != "notrelease" ]]
then
    # 更新分支
    p=$1
    b=$2
    # 修正分支合并的情况
    b=${b##*-->}
    branch=$b
    port=$6 # 是否暴露端口
    use_base=$7 # 是否使用公共配置
    if [[ $p == "gateway"  ]]
    then port=true
    elif [[ "$envs" == "dev" ]]
    then    port=true
    elif [[ "$envs" == "sit" ]]
    then    port=true
    fi

    if [[ "$ptype" == "frontend" ]]
    then echo 前端项目${1}发布,环境为$envs
    # 获取脚本最后一个参数，前端项目存储路径
    for appdir; do true; done
    if [[ ${appdir:0:1} != "/" ]];then echo "前端项目路径($appdir)指定不正确,使用默认/var/www/project";fi
    appdir="/var/www/project"
    # 前端镜像版本默认用最新的
    version="latest"
    bash  /JAR_DIR/jenkins-config/frontend/frontend.sh $p $b $envs $version $appdir
    else
    echo upjob $envs $p
    upjob $envs $p
    #sed -i "s/\(image.*\?$p\).*/\1-$b/" /etc/rancher/$env/$p.yaml
    #${envs:0:1}up $p
    # 更新自由切换环境
    fi
else echo "已选择不发布，跳过发布"
fi


