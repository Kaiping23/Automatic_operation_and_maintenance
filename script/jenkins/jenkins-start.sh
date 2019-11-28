#!/bin/bash -l

if [[ "$projects" != "" ]]

then echo 多项目自定义指定发布
     project=$projects
fi

success="/tmp/${JOB_BASE_NAME}.$BUILD_NUMBER.success.log"
faild="/tmp/${JOB_BASE_NAME}.$BUILD_NUMBER.failed.log"
echo ""> $success
echo ""> $faild

if [[ $envs != "sit" ]]
then
#build=notbuild
echo $envs
fi
echo project:$project
echo branch:$branch envs:$envs build：$build release：$release port：$port use_base：$use_base $appdir:appdir
for i in $project
do
echo 开始打包发布项目$i
bash -l /JAR_DIR/jenkins-config/release.sh $i $branch $envs $build $release $port $use_base $appdir ||{ echo $i $envs $branch  >> $faild ;exitcode=1; continue;}
echo  $i $envs $branch >> $success
echo  $i $envs $branch 发布完成
echo '************************************************************'
echo
done
echo 汇总发布情况如下：
echo ***success***
cat $success|grep -v "^$"
echo 
echo
echo
echo ***faild***
cat $faild|grep -v "^$"
if [[ "$exitcode" != "" ]]
then
 echo 退出状态码为：$exitcode
 exit $exitcode
else exit 0
fi

