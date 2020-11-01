#!/bin/bash

IP_CONFIG=`cat /JAR_DIR/jenkins-config/frontend/web.conf|grep -w $branch|awk '{print$2}'|awk -F":" '{print $1}'`

echo "前端发布目标ip：$IP_CONFIG"

starttime=`date +'%Y-%m-%d %H:%M:%S'`
echo "$starttime-- 开始发布"
echo "环境名及代码分支："$branch "服务名："$frontendServer "端口号："$ports "路径："$appdir

pwd

function git_pull_admin(){
	echo "git_pull_admin 当前目录：" && pwd
	rm -rf sass-admin && echo "已删除旧的项目 sass-admin" || echo "没有这个项目 sass-admin"
   git clone -b $branch http://gitlab:Git2020wmy@g.km365.pw/frontend/sass-admin.git
   #git checkout -b $branch
   #git pull
   cd sass-admin
   #yarn
   sleep 5
   echo "---------git pull && yarn --------->: "
    git pull && yarn
   if [ $? -ne 0 ]; then
     echo "---------- git pull 失败退出 -----------"
	 exit 1
   else
     yarn build
   fi
   echo "-----------------  yarn build is ok  -------------------"
}
function git_pull_wechat(){
	echo "git_pull_wechat 当前目录：" && pwd
	rm -rf wechatWeb && echo "已删除旧的项目 wechatWeb" || echo "没有这个项目 wechatWeb"
   git clone -b $branch http://gitlab:Git2020wmy@g.km365.pw/frontend/wechatWeb.git
   cd wechatWeb
   #yarn 
   echo "---------git pull && yarn --------->: "
    git pull && yarn
   if [ $? -ne 0 ]; then
     echo "---------- git pull 失败退出 -----------"
	 exit 1
   else
     yarn build
   fi
   echo "-----------------  yarn build is ok  -------------------"
}

function git_pull_saaswechat(){
	echo "git_pull_sasswechat 当前目录：" && pwd
	rm -rf saas-weichat && echo "已删除旧的项目 saas-weichat" || echo "没有这个项目 saas-weichat"
   git clone -b $branch http://gitlab:Git2020wmy@g.km365.pw/frontend/saas-weichat.git && cd saas-weichat

   
   #yarn 
   echo "---------git pull && npm i --------->: "
    git pull && npm i
   if [ $? -ne 0 ]; then
     echo "---------- git pull 失败退出 -----------"
	 exit 1
   else
     yarn build
   fi
   echo "-----------------  yarn build is ok  -------------------"
}

function git_pull_wmypc(){
	echo "当前目录："
	pwd
    
	echo "git_pull_wmypc 当前目录：" && pwd
	rm -rf wmypcWeb && echo "已删除旧的项目 wmypcWeb" || echo "没有这个项目 wmypcWeb"
   git clone -b $branch http://gitlab:Git2020wmy@g.km365.pw/frontend/wmypcWeb.git
   cd wmypcWeb
   #yarn 
   echo "---------git pull && yarn --------->: "
    git pull && yarn
   if [ $? -ne 0 ]; then
     echo "---------- git pull 失败退出 -----------"
	 exit 1
   else
     yarn build
   fi
   echo "-----------------  yarn build is ok  -------------------"
}

function server_admin(){
   echo "------> 当前目录pwd：" && pwd  
      
   echo  $branch"环境IP地址："$1
   tar czf dist.tar.gz dist

   dataday=`date +'%Y%m%d'`
   mkdir -p /customproject/jarfile/$branch/sassadmin/$dataday/ && cp dist.tar.gz /customproject/jarfile/$branch/sassadmin/$dataday/
   version=sassadmin-`date +'%Y-%m-%d %H:%M:%S'`
   echo $version >>  /customproject/jarfile/$branch/sassadmin/$dataday/version.txt

   ssh -p$ports $1 mv $appdir/sassadmin  $appdir/sassadmin`date +'%Y%m%d%H%M%S'`
   ssh -p$ports $1 mkdir -p $appdir/sassadmin/dist
   scp -P$ports -r dist/* root@$1:$appdir/sassadmin/dist/
   
   #scp -P$ports -r dist/index.html root@$1:$appdir/admin/dist
   #scp -P$ports -r vendor root@$1:$appdir/admin/dist
   #scp -P$ports -r src root@$1:$appdir/admin/dist
   echo "$version 发布已完成"
   echo "---------- sassadmin scp 文件已完成 ----------"
   cd ../
}

function server_wechat(){
   echo "------> 当前目录pwd：" && pwd 
   
   echo  $branch"环境IP地址："$1
   tar czf dist.tar.gz dist

   dataday=`date +'%Y%m%d'`
   mkdir -p /customproject/jarfile/$branch/student-h5/$dataday/ && cp dist.tar.gz /customproject/jarfile/$branch/student-h5/$dataday/
   version=student-h5-`date +'%Y-%m-%d %H:%M:%S'`
   echo $version >>  /customproject/jarfile/$branch/student-h5/$dataday/version.txt

   ssh -p$ports $1 mv $appdir/student-h5  $appdir/student-h5`date +'%Y%m%d%H%M%S'`
   ssh -p$ports $1 mkdir -p $appdir/student-h5/dist
   scp -P$ports -r dist/* root@$1:$appdir/student-h5/dist/
   echo "$version 发布已完成"
   echo "---------- wechat scp 文件已完成 ----------"
   cd ../
}

function server_saaswechat(){
   echo "------> 当前目录pwd：" && pwd 
   
   echo  $branch"环境IP地址："$1
   tar czf dist.tar.gz dist

   dataday=`date +'%Y%m%d'`
   mkdir -p /customproject/jarfile/$branch/saas-student-h5/$dataday/ && cp dist.tar.gz /customproject/jarfile/$branch/saas-student-h5/$dataday/
   version=saas-student-h5-`date +'%Y-%m-%d %H:%M:%S'`
   echo $version >>  /customproject/jarfile/$branch/saas-student-h5/$dataday/version.txt

   ssh -p$ports $1 mv $appdir/student-h5  $appdir/student-h5`date +'%Y%m%d%H%M%S'`
   ssh -p$ports $1 mkdir -p $appdir/student-h5/dist
   scp -P$ports -r dist/* root@$1:$appdir/student-h5/dist/
   echo "---------- wechat scp 文件已完成 ----------"
   cd ../
}

function server_wmypc(){
   echo "------> 当前目录pwd：" && pwd  
   
   echo  $branch"环境IP地址："$1
   tar czf dist.tar.gz dist

   dataday=`date +'%Y%m%d'`
   mkdir -p /customproject/jarfile/$branch/wmypc/$dataday/ && cp dist.tar.gz /customproject/jarfile/$branch/wmypc/$dataday/
   version=wmypc-`date +'%Y-%m-%d %H:%M:%S'`
   
   echo $version >>  /customproject/jarfile/$branch/wmypc/$dataday/version.txt

   ssh -p$ports $1 mv $appdir/wmypc  $appdir/wmypc`date +'%Y%m%d%H%M%S'`
   ssh -p$ports $1 mkdir -p $appdir/wmypc/dist
   scp -P$ports -r dist/* root@$1:$appdir/wmypc/dist/
   echo "$version 发布已完成"
   echo "---------- wmypc scp 文件已完成 ----------"
   cd ../
}

branch_build=(${branch//,/ })
echo "----->发布的环境: "$branch_build
if [ "${branch_build}"x  = "sit"x ];then    #选择了develop分支

	array_build=(${frontendServer//,/ })    #服务名frontendServer = admin / wechat / wmypc
	echo "array_build: "$array_build
	for var_build in ${array_build[@]}
	do
		   echo "-------++master++------->>>: "${var_build}   
		   if [ "${var_build}"x  = "sassadmin"x ];then
		       echo " ....... admin is running ........ "
			   git_pull_admin
			   server_admin $IP_CONFIG
		   elif [ "${var_build}"x  = "wechat"x ];then
		       echo " ....... wechat is running ........ "
			   git_pull_wechat
			   server_wechat $IP_CONFIG
         elif [ "${var_build}"x  = "saaswechat"x ];then
            echo " ....... wechat is running ........ "
            git_pull_saaswechat
            server_saaswechat $IP_CONFIG
		   elif [ "${var_build}"x  = "wmypc"x ];then
		       echo " ....... wmypc is running ........ "
			   git_pull_wmypc
			   server_wmypc $IP_CONFIG
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
