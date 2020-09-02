#! /bin/sh
echo "依次指定以下参数或环境变量 ："
echo "     应用名字(appname)[参数1]"
echo "     所选环境(active)[参数2]"
echo "     注册中心地址(eureka)(可选)[参数3]"
echo "     日志路径(logpath)(可选)[参数4]"
echo "     日志级别(loglevel)(可选)[参数5]"

echo
echo "读取环境变量和参数，组合执行命令(参数优先级高于环境变量)"
echo
echo "参数为：appname：$1 ;active: $2 ;eureka:$3 ; logpath: $4 ;loglevel: $5 ;"
echo "环境变量为：appname：$appname ;active: $active ;eureka:$eureka ; logpath: $logpath ;loglevel: $loglevel ;"
echo
echo
# 规则,存在变量$1, 或者环境变量appname 则视为指定了appname 优先使用参数，而不是环境变量
 # # 容器下不生效，改写
# { [[ -n $1 ]] || [[ -n $appname ]] ; } || { echo 应用名字未指定,退出; exit 1;} && { [[ -n $1 ]] && appname=$1;echo "应用名字为: $appname";}

# { [[ -n $2 ]] || [[ -n $active ]] ; } || { echo 所选环境未指定,退出; exit 1;} && { [[ -n $2 ]] && active=$2;echo "应用环境为: $active";}
#
# { [[ -n $3 ]] || [[ -n $eureka ]] ; } || { echo 注册中心地址未指定，采用默认; eureka="http://eureka:31001/eureka/";} && { [[ -n $3 ]] && eureka=$3;echo "注册中心地址为: $eureka" ;}
#
# { [[ -n $4 ]] || [[ -n $logpath ]] ; } || { echo 日志路径未指定，采用默认; logpath="/logs/";} && { [[ -n $4 ]] && logpath=$4; echo "日志路径为: $logpath" ;}
#
# { [[ -n $5 ]] || [[ -n $loglevel ]] ; } || { echo 日志级别未指定，采用默认; loglevel="info";} && { [[ -n $5 ]] && loglevel=$5;echo "日志级别为: $loglevel" ;}

 { [[ "" != "$1" ]] || [[ "" != "$appname" ]] ; } || { echo 应用名字未指定,退出; exit 1;} && { [[ "" != "$1" ]] && appname=$1;echo "应用名字为: $appname";}

 { [[ "" != "$2" ]] || [[ "" != "$active" ]] ; } || { echo 所选环境未指定,退出; exit 1;} && { [[ "" != "$2" ]] && active=$2;echo "应用环境为: $active";}

 { [[ "" != "$3" ]] || [[ "" != "$eureka" ]] ; } || { echo 注册中心地址未指定，采用默认; eureka="http://127.0.0.1:80/eureka/";} && { [[ "" != "$3" ]] && eureka=$3;echo "注册中心地址为: $eureka" ;}

 { [[ "" != "$4" ]] || [[ "" != "$logpath" ]] ; } || { echo 日志路径未指定，采用默认; logpath="/logs/";} && { [[ "" != "$4" ]] && logpath=$4; echo "日志路径为: $logpath" ;}

 { [[ "" != "$5" ]] || [[ "" != "$loglevel" ]] ; } || { echo 日志级别未指定，采用默认; loglevel="info";} && { [[ "" != "$5" ]] && loglevel=$5;echo "日志级别为: $loglevel" ;}


 { [[ "" != "$6" ]] || [[ "" != "$javaopts" ]] ; } || { echo javaopts参数为未指定，采用默认空; javaopts="";} && { [[ "" != "$6" ]] && javaopts=$6;echo "javaopts参数为: $javaopts" ;}


 { [[ "" != "$7" ]] || [[ "" != "$argopts" ]] ; } || { echo argopts指定，采用默认空; argopts="";} && { [[ "" != "$7" ]] && argopts=$7;echo "argopts为: $argopts" ;}

# # 参数1
# if [[ -n $1 ]] || [[ -n $appname ]]
# then [[ -n $1 ]] && appname=$1;echo "应用名字为: $appname"; 
# else echo 应用名字未指定,退出; exit 1;
# fi
# # 参数2
# if [[ -n $2 ]] || [[ -n $active ]]
# then [[ -n $2 ]] && active=$2;echo "应用环境为: $active";
# else echo 所选环境未指定,退出; exit 1;
# fi
# # 参数3
# if [[ -n $3 ]] || [[ -n $eureka ]]
# then [[ -n $3 ]] && eureka=$3;echo "注册中心地址为: $eureka" ;
# else echo 注册中心地址未指定，采用默认; eureka="http://127.0.0.1:80/eureka/";
# fi
# # 参数4
# if [[ -n $4 ]] || [[ -n $logpath ]] 
# then [[ -n $4 ]] && logpath=$4; echo "日志路径为: $logpath" ;
# else echo 日志路径未指定，采用默认; logpath="/logs/";
# fi

# # 参数5
# if [[ -n $5 ]] || [[ -n $loglevel ]]
# then [[ -n $5 ]] && loglevel=$5;echo "日志级别为: $loglevel" 
# else echo 日志级别未指定，采用默认; loglevel="info";
# fi

echo "参数变量已确定如下：appname：$appname ;active: $active ;eureka:$eureka ; logpath: $logpath ;loglevel: $loglevel ;javaopts: $javaopts; argopts:$argopts"
JAVA_OPTS="-Dlogging.level.org.springframework=$loglevel -Dspring.logging.path=$logpath   -Dserver.port=80 -Dspring.profiles.active=$active  -DACTIVE=$active  -Deureka.client.serviceUrl.defaultZone=$eureka   -Dfile.encoding=UTF8  -Duser.timezone=GMT+08"
JAVA_OPTS_CONFIG="-Dlogging.level.org.springframework=$loglevel -Dspring.logging.path=$logpath -Dserver.port=80  -DACTIVE=$active  -Deureka.client.serviceUrl.defaultZone=$eureka -Dfile.encoding=UTF8  -Duser.timezone=GMT+08"
JAVA_OPTS_EUREKA="-Dlogging.level.org.springframework=$loglevel -Dspring.logging.path=$logpath -Dserver.port=80 -Dspring.profiles.active=$active -DACTIVE=$active  -Deureka.client.serviceUrl.defaultZone=$eureka   -Dspring.application.name=eureka  -Dfile.encoding=UTF8  -Duser.timezone=GMT+08"
mkdir -p /jar
cd /jar
# 新增先看目录下有没有打包好的jar，没有就去下载 
# 增加强制更新参数环境变量

app=`ls |grep -iw $appname`
if [[ "$force" == "force" ]]
then echo 已选择强制更新,删除老文件
echo rm -rf $app sentries 
rm  -rf $app sentries  
unset app
fi

if [[ "$app" != "" ]]
then echo 项目jar包已存在，为$app
else

  if [[ ! -f "/jar/$appname.jar" ]]
  then echo 不存在jar,即将下载
  echo " curl -sSLf  --retry 4 $curlargs http://customproject.oss-cn-shanghai.aliyuncs.com/jarfile/$branch/$appname/$appname.jar > /jar/$appname.jar "
  curl -sSLf $curlargs  --retry 4 http://customproject.oss-cn-shanghai.aliyuncs.com/jarfile/$branch/$appname/$appname.jar > /jar/$appname.jar ||{ echo 下载失败;exit 1; }
  echo 下载完成，启动。
  else
  echo jar包已存在
  fi
  app=$appname.jar
  echo 项目jar包为$app
fi

echo 
# 选择java变量，运行命令
echo 开始运行程序
[[ "$appname" = "eureka" ]]&&JAVA_OPTS=${JAVA_OPTS_EUREKA}
[[ "$appname" = "config" ]]&&JAVA_OPTS=${JAVA_OPTS_CONFIG}
echo "project-name："$appname && echo "JAVA_OPTS: "${JAVA_OPTS}
 echo "执行命令如下："java ${JAVA_OPTS} $javaopts -Djava.security.egd=file:/dev/./urandom -jar /jar/$app $argopts
java ${JAVA_OPTS} $javaopts -Djava.security.egd=file:/dev/./urandom -jar /jar/$app $argopts
