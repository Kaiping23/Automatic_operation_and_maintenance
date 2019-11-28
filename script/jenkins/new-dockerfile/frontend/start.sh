 # 参数1
echo "依次指定以下参数或环境变量 ："
echo "     应用名字(appname)[参数1]"
echo "     项目路径(ProjectPath)(可选)[参数2]"
echo
echo "读取环境变量和参数，组合执行命令(参数优先级高于环境变量)"

echo
echo "参数为：appname：$1 ;ProjectPath: $2 ;"
echo "环境变量为：appname：$appname ;ProjectPath: $ProjectPath ;"
echo
echo
# 规则,存在变量$1, 或者环境变量appname 则视为指定了appname 优先使用参数，而不是环境变量

 { [[ "" != "$1" ]] || [[ "" != "$appname" ]] ; } || { echo 项目名字未指定,退出; exit 1;} && { [[ "" != "$1" ]] && appname=$1;echo "应用名字为: $appname";}
 { [[ "" != "$2" ]] || [[ "" != "$ProjectPath" ]] ; } || { echo 项目路径未指定，采用默认; ProjectPath="/var/www/project/$appname";} && { [[ "" != "$2" ]] && ProjectPath=$2; echo "项目路径: $ProjectPath" ;}

echo "参数变量已确定如下：appname：$appname ;ProjectPath: $ProjectPath "
echo "开始执行"
echo "请确保容器已读写映射物理机实际项目目录！！！"
echo 删除项目目录${ProjectPath}下所有文件，并复制新内容
if [[ ! -d $ProjectPath ]] ; then echo " $ProjectPath 不存在,即将创建";mkdir -p $ProjectPath;fi
rm -rf $ProjectPath/*
#cp -r dist $ProjectPath
tar zxvf dist.tar.gz -C $ProjectPath
echo 项目复制完成
