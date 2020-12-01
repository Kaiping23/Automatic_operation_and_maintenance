#!/bin/bash
source /etc/profile
IP_CONFIG=`cat /JAR_DIR/jenkins-config/frontend/web.conf|grep -w $env|awk '{print$2}'|awk -F":" '{print $1}'`

echo "前端发布目标ip：$IP_CONFIG"

starttime=`date +'%Y-%m-%d %H:%M:%S'`
echo "$starttime-- 开始发布"
echo "环境名及代码分支："$branch "服务名："$frontendServer "端口号："$ports "路径："$appdir

pwd

function git_pull_admin(){
	echo "git_pull_admin 当前目录：" && pwd
	#rm -rf itraining-admin && echo "已删除旧的项目 itraining-admin" || echo "没有这个项目 itraining-admin"
   #git clone -b $branch http://gitlab:Git2020hqjc@39.98.140.255/iTraining/itraining-admin.git

   #git checkout -b $branch
   #git pull
   cd itraining-admin
   #yarn
   sleep 5
   echo "---------git pull && yarn --------->: "
    git pull && yarn && yarn dll
   if [ $? -ne 0 ]; then
     echo "---------- git pull 失败退出 -----------"
	 exit 1
   else
     yarn build:${env}
   fi
   echo "-----------------  yarn build sucess  -------------------"
}



function git_pull_h5(){
	echo "git_pull_sasswechat 当前目录：" && pwd
	#rm -rf  itraining-h5  && echo "已删除旧的项目  itraining-h5" || echo "没有这个项目  itraining-h5 "
   #git clone -b $branch http://gitlab:Git2020hqjc@39.98.140.255/itraining-frontend/itraining-h5.git 
   cd itraining-h5


   #yarn
   echo "---------git pull && npm i --------->: "
    git pull && yarn && yarn dll
   if [ $? -ne 0 ]; then
     echo "---------- git pull 失败退出 -----------"
	 exit 1
   else
     yarn build:${env}
   fi
   echo "-----------------  yarn build sucess   -------------------"
}

function git_pull_pc(){
	echo "当前目录："
	pwd

	echo "git_pull_wmypc 当前目录：" && pwd
	#rm -rf itraining-pc && echo "已删除旧的项目 itraining-pc" || echo "没有这个项目 itraining-pc"
   #git clone -b $branch http://gitlab:Git2020hqjc@39.98.140.255/itraining-frontend/itraining-pc.git
   cd itraining-pc
   #yarn
   echo "---------git pull && yarn --------->: "
    git pull && yarn && yarn dll
   if [ $? -ne 0 ]; then
     echo "---------- git pull 失败退出 -----------"
	 exit 1
   else
     yarn build:${env}
   fi
   echo "-----------------  yarn build is ok  -------------------"
}

function server_admin(){
   echo "------> 当前目录pwd：" && pwd

   echo  $branch"环境IP地址："$1
   tar czf dist.tar.gz dist

   dataday=`date +'%Y%m%d'`
   mkdir -p /itrainning-tmp/jarfile/$branch/admin/$dataday/ && cp dist.tar.gz /itrainning-tmp/jarfile/$branch/admin/$dataday/
   version=$env-admin-`date +'%Y-%m-%d %H:%M:%S'`
   echo $version >>  /itrainning-tmp/jarfile/$branch/admin/$dataday/version.txt

   ssh -p$ports $1 mv $appdir/admin  $appdir/admin`date +'%Y%m%d%H%M%S'`
   ssh -p$ports $1 mkdir -p $appdir/admin/dist
   echo $version >>  dist/version.html
   scp -P$ports -r dist/* root@$1:$appdir/admin/dist/

   echo "$version 发布已完成"
   echo "---------- admin scp 文件已完成 ----------"
   cd ../
}

function server_h5(){
   echo "------> 当前目录pwd：" && pwd

   echo  $branch"环境IP地址："$1
   tar czf dist.tar.gz dist

   dataday=`date +'%Y%m%d'`
   mkdir -p /itrainning-tmp/jarfile/$branch/h5/$dataday/ && cp dist.tar.gz /itrainning-tmp/jarfile/$branch/h5/$dataday/
   version=$env-h5-`date +'%Y-%m-%d %H:%M:%S'`
   echo $version >>  /itrainning-tmp/jarfile/$branch/itrainning-h5/$dataday/version.txt

   ssh -p$ports $1 mv $appdir/h5  $appdir/h5`date +'%Y%m%d%H%M%S'`
   ssh -p$ports $1 mkdir -p $appdir/h5/dist
   echo $version >>  dist/version.html
   scp -P$ports -r dist/* root@$1:$appdir/student-h5/dist/
   echo "$version 发布已完成"
   echo "---------- wechat scp 文件已完成 ----------"
   cd ../
}

function server_pc(){
   echo "------> 当前目录pwd：" && pwd

   echo  $branch"环境IP地址："$1
   tar czf dist.tar.gz dist

   dataday=`date +'%Y%m%d'`
   mkdir -p /itrainning-tmp/jarfile/$branch/pc/$dataday/ && cp dist.tar.gz /itrainning-tmp/jarfile/$branch/pc/$dataday/
   version=$env-pc-`date +'%Y-%m-%d %H:%M:%S'`

   echo $version >>  /itrainning-tmp/jarfile/$branch/pc/$dataday/version.txt

   ssh -p$ports $1 mv $appdir/pc  $appdir/pc`date +'%Y%m%d%H%M%S'`
   ssh -p$ports $1 mkdir -p $appdir/pc/dist
   echo $version >>  dist/version.html
   scp -P$ports -r dist/* root@$1:$appdir/pc/dist/
   echo "$version 发布已完成"
   echo "---------- itrainning-pc scp 文件已完成 ----------"
   cd ../
}

branch_build=(${branch//,/ })
echo "----->发布的环境: "$branch_build
if [ "${branch_build}"x  = "${branch}"x ];then    #选择了develop分支

	array_build=(${frontendServer//,/ })    #服务名frontendServer = admin / wechat / wmypc
	echo "array_build: "$array_build
	for var_build in ${array_build[@]}
	do
		   echo "-------++${branche}++------->>>: "${var_build}
		   if [ "${var_build}"x  = "admin"x ];then
		       echo " ....... admin is running ........ "
			   git_pull_admin
			   server_admin $IP_CONFIG
		   elif [ "${var_build}"x  = "h5"x ];then
		       echo " ....... h5 is running ........ "
			   git_pull_h5
			   server_h5 $IP_CONFIG
		   elif [ "${var_build}"x  = "pc"x ];then
		       echo " ....... wmypc is running ........ "
			   git_pull_pc
			   server_pc $IP_CONFIG
		   else
			   echo " ....... is error ........ "
		   fi
	done
else
    echo "----------------  exit  -------------------"
fi

echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
echo "环境名及代码分支："$branch "服务名："$frontendServer "端口号："$ports "路径："$appdir

endtime=`date +'%Y-%m-%d %H:%M:%S'`
echo "$endtime-- 完成发布"
start_seconds=$(date --date="$starttime" +%s);
end_seconds=$(date --date="$endtime" +%s);
echo "本次jenkins运行的时间："$((end_seconds-start_seconds))"s"

echo "-----------------------------------------------------------"
echo "发布成功 "$branch  "-"  $frontendServer
