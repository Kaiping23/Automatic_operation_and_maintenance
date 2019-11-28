# 基础配置
basedir=/JAR_DIR/jenkins-config
docker_repo="registry-vpc.cn-shanghai.aliyuncs.com" # 镜像地址不包含命名空间及仓库地址
dockerfile_dir=$basedir/new-dockerfile              # dockerfile基础文件目录
BASEDIR=/JAR_DIR/git-project/                       # 项目运行基础目录
[[ -d "$BASEDIR" ]] || mkdir -p $BASEDIR
cd $BASEDIR

# 参数配置
# 示例 GITREPO="ssh://git@g.km365.pw:122/frontend/admin.git" #git 地址
# 示例 project="admin"  # 项目名称
# 示例 branch="dev-release-->test-release" # 分支('$Abranch-->$Bbranch') (参数4，项目目录,该参数存在，将进入真实的目录，适用于混合项目)
[[ "" == "$3" ]] && {
  echo 必须指定 参数1: git地址 参数2:项目名称 参数3:分支 '($Abranch-->$Bbranch)' 三个参数 '(参数4可选,该参数存在，将进入真实的目录<参数2>，适用于混合项目)'
  exit 1
}
GITREPO=$1
project=$2
branch=$3
job=$4

# 主题

merge_to=${branch##*-->}
merge_from=${branch%%-->*}
project_dir=$(echo $GITREPO | awk 'BEGIN{FS="[.|/]"}{print $(NF-1)}')   # 项目的真实目录
# clone项目函数
CloneProject() {
  if [ ! -d "$project_dir" ]; then
    echo "$project_dir 不存在,克隆项目"
    git clone $GITREPO
  else
    echo "$project_dir 已存在"
  fi
}

tag=${project}-${merge_to}-$(date +%Y%m%d_%H_%M_%S)

# 项目合并分支函数
MergeProject() {

  cd $BASEDIR/$project_dir

  git pull
  #
  echo "检测merge_from分支"
  if git checkout $merge_from; then
    git pull
  else
    echo "$merge_from 不存在，自动从develop创建" && git checkout develop && git pull && git checkout -b $merge_from
  fi

  #git checkout $merge_to || (echo $merge_to 不存在，自动从develop创建 && git checkout develop &&git pull&&git checkout  -b $merge_to )
  #git pull
  # merge
  if [ "$merge_to" = "$merge_from" ]; then
    echo 无merge操作,跳过
  else
    echo merge操作:$merge_from "--->" $merge_to
    echo 检测merge_to分支
    if git checkout $merge_to; then
      git pull
    else
      echo $merge_to 不存在,自动从develop创建 && git checkout develop && git pull && git checkout -b $merge_to
    fi
    git merge --commit --ff $merge_from || {
      echo 失败退出;
      exit 1
    }

  fi
  echo "变更信息如下:"
  git show HEAD --pretty=format:"%h - %an, %ad : %s" | head -c 1000
  echo
  echo

  git tag $tag
  echo git push --tags --set-upstream origin $merge_to
  git push --tags --set-upstream origin $merge_to || {
    echo push 失败退出;
    exit 1
  }
  echo
  echo
  echo 当前分支: $project:$(git branch | grep \*)

}

PushJob() {
  if [ -f "pom.xml" ]; then
    echo "java project $project,开始打包"
    group=wmy-backend
    if [[ "$job" != "" ]]; then
      echo "*********指定了混合项目的真实目录，进入真实目录执行***********"
      # real_dir=`ls -d *$project* |xargs -n 1|grep -v api|awk '{if(length($0)>1){print}}'`
      # 忽略命名不规范引起的问题
      real_dir=$(ls | grep -i [^a-zA-Z]$project | xargs -n 1 | grep -v api | awk '{if(length($0)>1){print}}')
      if [[ ! -d "$real_dir" ]]; then
        echo 包含${project}的真实的项目目录不存在,请检查;
        exit 1
      fi
      cd $real_dir
      project_dir=$project_dir/$real_dir
    fi
    echo "-------------------------"
    echo
    echo 项目目录为:$project_dir
    echo mvn 构建
    echo "-------------------------"
    mvn -B -U -f pom.xml clean install -Dmaven.test.skip=true
    #mvn -B -U -q -f pom.xml clean install -Dmaven.test.skip=true
    if [[ $? == 0 ]]; then
      echo "打包完成"
    else
      echo "打包失败,删除缓存仓库,重新打包api和service,可能会影响其他正在打包的程序"
      echo 'rm -rf /root/.m2/repository/com/fulan/*'
      sleep 2
      rm -rf /root/.m2/repository/com/fulan/*
      echo 执行第二次打包
      mvn -B -U -f ../pom.xml clean install -Dmaven.test.skip=true || { echo "打包失败.退出" && exit 1; }
    fi
    if [ -d "target" ]; then
      target_dir=target
    else
      target_dir="$(ls -d */ | grep $project | xargs -n 1 | grep -v api)/target"
    fi
    # 检查打包目录是否存在
    if [ -d "$target_dir" ]; then
      echo "jar包目录："$target_dir
    else
      echo "jar包目录:"$target_dir 不存在,请检查,即将退出
      echo "执行以下命令，查看是否有多个目录"
      echo """ cd $(pwd) && ls -d \`ls -d *$project*/ |xargs -n 1|grep -v api\` """
      exit 1
    fi
    # 生成镜像目录及必备文件

    if [[ "$project" =~ "manage" ]]; then
      image_dir=base-new
    elif [[ "$project" =~ "student" ]]; then
      image_dir=base-new
    else
      image_dir=base
    fi
    echo "基础镜像目录为：$image_dir"

    docker_dir=$(mktemp -d -p $BASEDIR/)
    cp -r $dockerfile_dir/$image_dir/* $docker_dir
    ln $BASEDIR/$project_dir/$target_dir/*jar $docker_dir/jar/ || cp $BASEDIR/$project_dir/$target_dir/*jar $docker_dir/jar/
  else
    echo 前段项目镜像制作
    group=wmy-frontend
    image_dir=frontend
    echo "基础镜像目录为：$image_dir"
    docker_dir=$(mktemp -d -p $BASEDIR/)
    cp -r $dockerfile_dir/$image_dir/* $docker_dir
    sed -i "s/projectname/$project/g" $docker_dir/Dockerfile
    mkdir -p $docker_dir/dist
    # admin 项目特殊处理
    if [[ "$project" == "admin" ]]; then
      echo admin 项目需特殊处理;
      cp -r $BASEDIR/$project_dir/dist $docker_dir/dist/
      mkdir -p $docker_dir/dist/src
      cp -r $BASEDIR/$project_dir/src/static $docker_dir/dist/src
      mv $docker_dir/dist/dist/index.html $docker_dir/dist

    else
      cp -r $BASEDIR/$project_dir/dist/* $docker_dir/dist/
    fi
    #写入打包信息
    mkdir $docker_dir/dist/version_v
    echo "<p>release-image date $(date) </p>" >$docker_dir/dist/version_v/version.html
    echo "<p>project-branch:  $project-$merge_to</p>" >>$docker_dir/dist/version_v/version.html
    echo "<p>tag:  $tag</p>" >>$docker_dir/dist/version_v/version.html
    cd $docker_dir
    tar zcf dist.tar.gz dist/* && rm -rf dist
  fi
  # 制作镜像
  echo 制作镜像
  cd $docker_dir
  dates=$(date +%Y%m%d)
  mvdir=/customproject/jarfile/$merge_to/$project/
  mkdir -p $mvdir/$dates
  [[ -d "jar" ]] && echo $mvdir/$dates/$project.jar && scp jar/*jar $mvdir/$project.jar && scp jar/*jar $mvdir/$dates/$project.jar &
  [[ -f "dist.tar.gz" ]] && echo $mvdir/$dates/$project.tar.gz && scp dist.tar.gz $mvdir/$project.tar.gz && scp dist.tar.gz $mvdir/$dates/$project.tar.gz &
  echo "git-tag:$tag" >version.txt
  scp version.txt $mvdir/$dates/version.txt &
  scp version.txt $mvdir/version.txt &
  sleep 0.5 # 延迟0.5秒 防止打包找不到该文件失败
  sleep 1
  ls
  echo "构建目录：`pwd`"
  image1=$(echo $docker_repo/$group/$project-$merge_to: | sed 's#//#/#g' | tr A-Z a-z)$(date +%Y%m%d)
  image2=$(echo $docker_repo/$group/$project-$merge_to: | sed 's#//#/#g' | tr A-Z a-z)latest
  docker build -t $image1 ./ || {
    echo "构建镜像错误，5秒后重试一次";
    sleep 5
    cd $docker_dir && docker build -t $image1 ./ || exit 1
  }
  docker push $image1
  docker tag $image1 $image2
  docker push $image2
  docker rmi $image1 $image2
  #rm -rf $docker_dir
  echo "镜像生成成功"
  cd $BASEDIR/$project_dir
  wait

}

# 镜像生成函数

# git clone
date
echo -----------------克隆项目-----------------
CloneProject || {
  echo clone "项目失败，退出";
  exit 1
}
echo -----------------克隆项目完成-----------------
echo
echo
echo -----------------merge项目-----------------
# git merge
MergeProject || {
  echo merge "项目失败，删除项目重新merge一次"
  cd $BASEDIR && CloneProject && MergeProject
  [[ $? != 0 ]] && echo "再次merge失败" && exit 1
}
echo -----------------merge项目完成-----------------
echo
echo
# 打包
echo -----------------打包项目,提交镜像-----------------
PushJob || {
  echo 打包 项目失败,退出
  exit 1
}
echo -----------------打包项目,提交镜像完成-----------------
echo 构建完成
date
