
# 基础配置
docker_repo="registry.cn-shanghai.aliyuncs.com" #镜像地址不包含命名空间及仓库地址
dockerfile_dir=/root/new-dockerfile # dockerfile基础文件目录
BASEDIR=/JAR_DIR/git-project/ #项目运行基础目录
[[ -d "$BASEDIR" ]] || mkdir -p $BASEDIR
cd $BASEDIR

# 参数配置
# 示例 GITREPO="ssh://git@g.km365.pw:122/frontend/admin.git" #git 地址
# 示例 project="admin"  # 项目名称
# 示例 branch="dev-release-->test-release" # 分支('$Abranch-->$Bbranch')
[[ "" = "$3" ]] && { echo 必须指定 git地址 项目名称 分支 '($Abranch-->$Bbranch)' 三个参数 ;exit 1; }
GITREPO=$1
project=$2
branch=$3


# 主题

merge_to=${branch##*-->}
merge_from=${branch%%-->*}
project_dir=`echo $GITREPO|awk 'BEGIN{FS="[.|/]"}{print $(NF-1)}'`
# clone项目函数
CloneProject(){
    if [ ! -d "$project_dir" ]
    then echo $project_dir 不存在，克隆项目
        git clone $GITREPO
    else
        echo $project_dir 已存在
    fi
}



#项目合并分支函数
MergeProject() {
cd $BASEDIR/$project_dir

git pull

git checkout $merge_to || (echo $merge_to 不存在，自动从develop创建 && git checkout develop &&git checkout  -b $merge_to )
# merge
if [ "$merge_to" = "$merge_from" ] 
then echo 无merge操作，跳过
else echo merge操作：$merge_from "--->" $merge_to
     git merge --commit --ff $merge_from || { echo merge 失败退出; eixt 1; }
        
fi
echo push --set-upstream origin $merge_to
git push --set-upstream origin $merge_to || { echo push 失败退出; eixt 1; }
echo 
echo
echo 当前分支: $project:`git branch |grep \*`


}

PushJob() {
if [ -f "pom.xml" ]
then echo "java project $project,开始打包"
    group=wmy-backend
    mvn -B -f pom.xml clean install -Dmaven.test.skip=true || { echo 打包失败，退出 && exit 1; }
    if [ -d "target" ]
    then target_dir=target
    else target_dir="`ls -d *$project* |xargs -n 1|grep -v api`/target"
    fi
    # 检查打包目录是否存在
    if [ -d "$target_dir" ]
    then echo "jar包目录："$target_dir
    else echo "jar包目录："$target_dir 不存在，请检查，即将退出
         echo "执行以下命令，查看是否有多个目录"
         echo  """ cd `pwd` && ls -d \`ls -d *$project* |xargs -n 1|grep -v api\` """
         exit 1
    fi
    # 生成镜像目录及必备文件
    
    if [[ "$project" =~ "manage" ]] 
    then image_dir=base-new
    elif [[ "$project" =~ "student" ]]
    then image_dir=base-new
    else image_dir=base
    fi
    echo "基础镜像目录为：$image_dir"
    
    docker_dir=`mktemp -d -p $BASEDIR/`
    cp -r $dockerfile_dir/$image_dir/*  $docker_dir
    ln  $BASEDIR/$project_dir/$target_dir/*jar $docker_dir/jar/ || cp $BASEDIR/$project_dir/$target_dir/*jar $docker_dir/jar/ 
else echo 前段项目镜像制作
     group=wmy-frontend
     image_dir=frontend
     echo "基础镜像目录为：$image_dir"
     docker_dir=`mktemp -d -p $BASEDIR/`
     cp -r $dockerfile_dir/$image_dir/*  $docker_dir
     sed -i "s/projectname/$project/g" $docker_dir/dockerfile
     mkdir -p $docker_dir/dist
     # admin 项目特殊处理
     if [[ "$project" = "admin" ]]; 
     then echo admin 项目需特殊处理; 
          cp -r $BASEDIR/$project_dir/dist $docker_dir/dist/
          cp -r $BASEDIR/$project_dir/src/static  $docker_dir/dist/src
          mv $docker_dir/dist/dist/index.html $docker_dir/dist
          
     else 
          cp -r $BASEDIR/$project_dir/dist/* $docker_dir/dist/  
     fi
     #写入打包信息
     mkdir $docker_dir/dist/version_v
     echo "<p>release-image date `date` </p>" >$docker_dir/dist/version_v/version.html
     echo "<p>project-branch:  $project-$merge_to</p>" >>$docker_dir/dist/version_v/version.html
fi
# 制作镜像
echo 制作镜像
cd $docker_dir
image1=`echo $docker_repo/$group/$project-$merge_to:|sed 's#//#/#g' |tr A-Z a-z``date +%Y%m%d`
image2=`echo $docker_repo/$group/$project-$merge_to:|sed 's#//#/#g' |tr A-Z a-z`latest
docker build -t $image1 . 
docker push $image1
docker tag $image1 $image2
docker push $image2
docker rmi $image1 $image2
rm -rf $docker_dir
echo "镜像生成成功"
cd $BASEDIR/$project_dir


}


# 镜像生成函数



# git clone
date
echo -----------------克隆项目-----------------
CloneProject || { echo clone 项目失败，退出;exit 1 ; }
echo -----------------克隆项目完成-----------------
echo
echo
echo -----------------merge项目-----------------
# git merge
MergeProject || { echo merge 项目失败，删除项目重新merge一次 ;cd BASEDIR && CloneProject && MergeProject ;[[ $? != 0 ]]&& echo 再次merge失败 && exit 1;  }
echo -----------------merge项目完成-----------------
echo 
echo
# 打包
echo -----------------打包项目，提交镜像-----------------
PushJob || { echo 打包 项目失败，退出;exit 1 ; }
echo -----------------打包项目，提交镜像完成-----------------
echo 构建完成
date
