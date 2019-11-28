#绿色输出函数
green_echo(){
    echo -e "\033[1;32m$@ \033[0m"
}
#######################配置生成方式 docker-compose.yml #######################
# 清楚日志配置，重构
# dos2unix docker-compose.yml
# cat docker-compose.yml|grep -vE "logging:|options|max-size|driver" >2docker-compose.yml

# # log temp
# echo """    logging:
      # driver: json-file
      # options:
        # max-size: 100m"""> log.temp
# # 重新生成配置
 # awk 'FS="&&" {if($0~/    tty/){print;system("cat log.temp")}else{print}}' 2docker-compose.yml > 3docker-compose.yml

 # ## 生成每个配置文件
 # cat 3docker-compose.yml |awk 'BEGIN{FS="$$"}NR<3{a=a?a"\n"$1:$1;print $1}NR>=3{if($1 ~ /^  \w/){file=substr($1,3);gsub(":","",file);print a > file".yaml"};print >>  file".yaml";}'
 
#######################配置生成方式 docker-compose.yml #######################
 
 # prom='urc -c $basedir/cli_uat.json' # 程序
 # svc=log  # 服务
 # env=wmy-uat # 环境（服务集合）
 
# 更新
basedir=/etc/rancher
update_svc(){
# 环境，服务，日期
# 返回10表示镜像不存在，11，为其他错误
env=$1
svc=$2
day=$3
# 增加公共yaml
if [[ "$port" == "true" ]]
then
port=`awk 'BEGIN{FS="[ \t:]";OFS="\t"}{if($1=="'$svc'"){print $3}}' ../dev.svc.txt`
sed "s/#PORT/$port/;s/lecturer/$svc/g;s/##//;" ../base.$env.yaml > $svc.tmp.yaml
else
sed "s/#PORT/$port/;s/lecturer/$svc/g;" ../base.$env.yaml > $svc.tmp.yaml
fi

if [[ "$use_base" == "true" ]]
then echo 指定了强制使用公共配置
elif [[ ! -f "$svc.yaml" ]]
then echo "$svc.yaml 不存在，使用公共配置"
else
echo "使用 $svc.yaml"
cat $svc.yaml > $svc.tmp.yaml
fi
# 修正分支
if [[ -n "$branch" ]]
then
echo 修正分支 $branch
sed -i "s/\(image.*com.*\?$svc\).*/\1-$branch/" $svc.tmp.yaml
sed -i "s/\(branch: \).*/\1$branch/" $svc.tmp.yaml
fi
# 更新前预判服务状态
preinfo=`$prom ps |grep $env/$svc|awk '{print $5}'`
if [[ "$preinfo" == "upgrading" ]]
then echo "$env/$svc 状态为'upgrading',无法执行更新动作，请UI界面手动更新，回滚或删除该服务，或等待服务更新完成，重新执行发布任务" && exit 1
fi
cat $svc.tmp.yaml|sed "s/\(image:.*$svc[^:]*\).*/\1:$day/"|$prom  up  -p -d --force-upgrade  -c --stack $env -f -
if [[ $? == 0 ]]
# 更新成功才写入配置
then cat $svc.tmp.yaml|sed "s/\(image:.*$svc[^:]*\).*/\1:$day/" > $svc.yaml
fi
info=`$prom ps |grep $env/$svc|grep -E "error|Error|Failed"`
if [ -n "$info" ]
    then  green_echo "更新$svc:$day 失败，报错信息如下(即将回滚):"
          echo $info
          green_echo "回滚服务$svc"
          $prom up -r --stack $env -d -c -f  $svc.yaml
          imageinfo=`echo $info|grep image|grep "not found"`
          if [ -n "$imageinfo" ]
          then return 10
          else return 11
          fi
    else green_echo 更新$svc:$day 成功.
fi

}

upsvc(){
#环境，服务
env=$1
svc=$2
today=`date +"%Y%m%d"`
yestoday=`date -d "1 day ago" +"%Y%m%d"`
thwoday=`date -d "2 day ago" +"%Y%m%d"`
threeday=`date -d "3 day ago" +"%Y%m%d"`
count=0
for day in $today $yestoday $thwoday $threeday
do
    let count=count+1
    update_svc $env $svc $day
    code=$?
    if [ $code = 10 ] 
    then  green_echo $svc:${day}镜像不存在,即将尝试前一天镜像
          if [ $count = 1 ] ; then  green_echo "$svc:${day}更新失败，已回滚，尝试1次，尝试使用最新镜像latest更新。";update_svc $env $svc "latest";exit $?;fi
    elif [ $code = 11 ]
    then green_echo 其他原因更新失败,重试一次.
         update_svc $env $svc $day
         code=$?
         if [ $code != 0 ];then green_echo  "$svc:${day}更新失败，已回滚，其他原因，终止。";exit $code;fi
         break
    else break
    fi
done
# 释放公共变量
unset code
unset use_base
unset port
unset branch
}


# uup(){
# cd /root/rancher/uat
# svc=$1 # 服务
# prom='urc -c $basedir/cli_uat.json' # 程序

# }


uup(){
cd $basedir/uat
env=wmy-uat

temp=`date +"%m月%d日"`
prom="rancher -c $basedir/cli_uat.json" # 程序
[[ -f "release.txt" ]] || (echo "date" >release.txt&&$prom ps|awk '{print $3}'|grep wmy|awk 'BEGIN{FS="/"}{print $2}'|sort >>release.txt)
for sv in `echo $@|awk 'BEGIN{RS=",| |\t|，|;|、"}{print}'|grep -v "^$"|awk 'BEGIN{FS="-|_" }{print $NF}'`
do  flag=false
    for svcs in `awk '{print $1}' ../dev.svc.txt|grep -v "^$"`
    do  
        if [ $sv = $svcs ]
        then flag=true
        break
        fi
    done
    if [ "$flag" = "true" ]
    then 
        echo $sv >> $temp
        upsvc $env $sv
        
    
    else green_echo $sv 不存在请检查
    fi
 done
}


pup(){
cd $basedir/prod
env=wmy-prod
temp=`date +"%m月%d日"`
prom="rancher -c $basedir/cli.json" # 程序
[[ -f "release.txt" ]] || (echo "date" >release.txt&&$prom ps|awk '{print $3}'|grep wmy|awk 'BEGIN{FS="/"}{print $2}'|sort >>release.txt)
for sv in `echo $@|awk 'BEGIN{RS=",| |\t|，|;|、"}{print}'|grep -v "^$"|awk 'BEGIN{FS="-|_" }{print $NF}'`
do  flag=false
    for svcs in `awk '{print $1}' ../dev.svc.txt|grep -v "^$"`
    do  
        if [ $sv = $svcs ]
        then flag=true
        break
        fi
    done
    if [ "$flag" = "true" ]
    then 
        echo $sv >> $temp
        upsvc $env $sv
    else green_echo $sv 不存在请检查
    fi
done
}






sup(){
cd $basedir/sit
env=sit
temp=`date +"%m月%d日"`
prom="rancher -c $basedir/cli_sit.json" # 程序
[[ -f "release.txt" ]] || (echo "date" >release.txt&&$prom ps|awk '{print $3}'|grep wmy|awk 'BEGIN{FS="/"}{print $2}'|sort >>release.txt)
for sv in `echo $@|awk 'BEGIN{RS=",| |\t|，|;|、"}{print}'|grep -v "^$"|awk 'BEGIN{FS="-|_" }{print $NF}'`
do  flag=false
    for svcs in `awk '{print $1}' ../dev.svc.txt|grep -v "^$"`
    do  
        if [ $sv = $svcs ]
        then flag=true
        break
        fi
    done
    # 去掉服务是否存在验证
    #flag=true
    if [ "$flag" = "true" ]
    then 
        echo $sv >> $temp
        upsvc $env $sv
    else green_echo $sv 不存在请检查
    fi
done
}

dup(){
cd $basedir/dev
env=dev
temp=`date +"%m月%d日"`
prom="rancher -c $basedir/cli_dev.json" # 程序
[[ -f "release.txt" ]] || (echo "date" >release.txt&&$prom ps|awk '{print $3}'|grep wmy|awk 'BEGIN{FS="/"}{print $2}'|sort >>release.txt)
for sv in `echo $@|awk 'BEGIN{RS=",| |\t|，|;|、"}{print}'|grep -v "^$"|awk 'BEGIN{FS="-|_" }{print $NF}'`
do  flag=false
    for svcs in `awk '{print $1}' ../dev.svc.txt|grep -v "^$"`
    do
        if [ $sv = $svcs ]
        then flag=true
        break
        fi
    done
    # 去掉服务是否存在验证
    #flag=true
    if [ "$flag" = "true" ]
    then
        echo $sv >> $temp
        upsvc $env $sv
       # update_svc  $env $sv latest
    else green_echo $sv 不存在请检查
    fi
done
}

upjob(){
env=$1
# 兼容uat/prod
if [[ "$env" == "uat" ]]
then env="wmy-uat"
elif [[ "$env" == "prod" ]]
then env="wmy-prod"
fi
prom="rancher -c $basedir/cli_$env.json" # 程序
mkdir -p $basedir/$env
[[ -f "$basedir/base.$env.yaml" ]] || { echo "$basedir/base.$env.yaml 文件不存在，退出" && exit 1; }
[[ -f "$basedir/cli_$env.json" ]] || { echo "$basedir/cli_$env.json 文件不存在，退出" && exit 1; }
cd $basedir/$env
for sv in `echo ${@:2}|awk 'BEGIN{RS=",| |\t|，|;|、"}{print}'|grep -v "^$"|awk 'BEGIN{FS="-|_" }{print $NF}'`
do  flag=false
    for svcs in `awk '{print $1}' ../dev.svc.txt|grep -v "^$"`
    do
        if [ $sv = $svcs ]
        then flag=true
        break
        fi
    done
    # 去掉服务是否存在验证
    #flag=true
    if [ "$flag" = "true" ]
    then
        upsvc $env $sv
       # update_svc  $env $sv latest
    else green_echo $sv 不存在请检查
    fi
done
}
