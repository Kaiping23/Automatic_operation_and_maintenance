#!/bin/bash

echo "branch："$branch
IP_CONFIG=`cat /JAR_DIR/jenkins-config/frontend/web.conf|grep -w $branch |awk '{split($2,a,",")}END{for(i in a){print a[i]}}'`

echo "前端发布目标ip：$IP_CONFIG 发布目标路径：$appdir"

starttime=`date +'%Y-%m-%d %H:%M:%S'`
echo "开始发布时间："$starttime
work_space="/JAR_DIR/jenkins/workspace/frontend-sass-sit/"
echo "开始转换工作目录："$work_space
echo "$starttime-- 开始发布"
echo "环境名及代码分支："$branch "服务名："$frontendServer "端口号："$ports "路径："$appdir

pwd

function server_admin(){

    echo "------> 当前目录pwd：" && pwd  

    dataday=$project_version
    cp /customproject/jarfile/$branch/sassadmin/$dataday/dist.tar.gz .
      
    echo  $branch"环境IP地址："$1


    # tar czvf dist.tar.gz dist && echo  "压缩dist文件已完成" || echo  "压缩dist文件已完成" && exit
    ssh -p$ports $1  mv $appdir/sassadmin  $appdir/sassadmin`date +'%Y%m%d%H%M%S'` || mkdir -p $appdir/sassadmin
    ssh -p$ports $1 mkdir -p $appdir/sassadmin/
    scp -P$ports  dist.tar.gz root@$1:$appdir/sassadmin/
    ssh -p$ports $1 tar -zxf $appdir/sassadmin/dist.tar.gz -C $appdir/sassadmin/

   
   #scp -P$ports -r dist/index.html root@$1:$appdir/admin/dist
   #scp -P$ports -r vendor root@$1:$appdir/admin/dist
   #scp -P$ports -r src root@$1:$appdir/admin/dist
   echo "---------- sassadmin scp 文件已完成 ----------"
   cd ../
}

function server_wechat(){
    echo "------> 当前目录pwd：" && pwd  

    dataday=$project_version
    cp /customproject/jarfile/$branch/student-h5/$dataday/dist.tar.gz .
      
    echo  $branch"环境IP地址："$1


    # tar czvf dist.tar.gz dist && echo  "压缩dist文件已完成" || echo  "压缩dist文件已完成" && exit
    ssh -p$ports $1  mv $appdir/student-h5  $appdir/student-h5`date +'%Y%m%d%H%M%S'` || mkdir -p $appdir/sassadmin
    ssh -p$ports $1 mkdir -p $appdir/student-h5/
    scp -P$ports  dist.tar.gz root@$1:$appdir/student-h5/
    ssh -p$ports $1 tar -zxf $appdir/student-h5/dist.tar.gz -C $appdir/student-h5/
   echo "---------- wechat scp 文件已完成 ----------"
   cd ../
}

function server_wmypc(){
    echo "------> 当前目录pwd：" && pwd  

    dataday=$project_version
    cp /customproject/jarfile/$branch/wmypc/$dataday/dist.tar.gz .
      
    echo  $branch"环境IP地址："$1


    # tar czvf dist.tar.gz dist && echo  "压缩dist文件已完成" || echo  "压缩dist文件已完成" && exit
    ssh -p$ports $1  mv $appdir/wmypc  $appdir/wmypc`date +'%Y%m%d%H%M%S'` || mkdir -p $appdir/sassadmin
    ssh -p$ports $1 mkdir -p $appdir/wmypc/
    scp -P$ports  dist.tar.gz root@$1:$appdir/wmypc/
    ssh -p$ports $1 tar -zxf $appdir/wmypc/dist.tar.gz -C $appdir/wmypc/
   echo "---------- wmypc scp 文件已完成 ----------"
   cd ../
}

branch_build=(${branch//,/ })
echo "----->发布的环境: "$branch_build
if [ "${branch_build}"x  = "${branch}"x ];then    #选择了develop分支

	array_build=(${frontendServer//,/ })    #服务名frontendServer = admin / wechat / wmypc
	echo "array_build: "$array_build
	for var_build in ${array_build[@]}
	do
		   echo "-------++master++------->>>: "${var_build}
            for IP in $IP_CONFIG
            do

                if [ "${var_build}"x  = "sassadmin"x ];then
                    echo " ....... admin is running ........ "
                    server_admin $IP
                elif [ "${var_build}"x  = "wechat"x ];then
                    echo " ....... wechat is running ........ "
                    server_wechat $IP
                elif [ "${var_build}"x  = "wmypc"x ];then
                    echo " ....... wmypc is running ........ "
                    server_wmypc $IP
                else
                    echo " ....... is error ........ "
                fi
           done
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
