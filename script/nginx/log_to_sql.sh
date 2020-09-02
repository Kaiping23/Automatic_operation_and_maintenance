#! /bin/bash
# 配置
log_file=access.log  #解析日志
bake_logfile=`date '+%y-%m-%d'`"."$log_file #备份日志
sqlfile=`date '+%y-%m-%d-%H%M%S'`".sql" #中间sql
sqlerror=sqlerror.log #错误信息
run_log=sqlrun.log #脚本运行日志
# sql用户名 studyuser 无密码 只对该ip该库有权限； 更换地址请重新添加用户
sqluser=studyuser
sqlhost=192.168.1.31
sqlport=3306
sqlpassword='studyuser@123'
start_time=`date +%s`
echo `date`"----------------开始----------------" >> $run_log
echo `date` "日志分析，生成sql" >> $run_log

# 第一步逐行输入日志文件到当天日志备份文件（例：accsess_log --->> 2018-04-28.accsess_log) 与之同时匹配请求参数交由管道下一步操作;读取结束后,清空当前文件
# 第二步排除上一步未匹配的空行交由管道下一步操作
# 第三步对参数解析并生成sql文件
#awk '{print >> "'$bake_logfile'"; match($0,/.*GET \/heart_check\?(.*session_id.*) HTTP/, a);print a[1]}END{system("echo -n  >"FILENAME)}' $log_file|grep -v "^$"|awk '{printf "INSERT INTO cloud_study.study_log";split($1,a,"&");for(i in a){split(a[i],b,"=");c[b[1]]=b[2]};for(i in c){if(i!="abcabcacbsad"){key=key?key","i:i;c[i]=c[i]?"'\''"c[i]"'\''":"0";value=value?value","c[i]:c[i]}};print "("key") VALUES(" value ");";key=value=None}' |sed  "s/'\+/'/g" |sort |uniq |awk '{split($0,a,"VALUES");gsub(/;/,",",a[2]);b=a[1];c=a[2];d[b]=!d[b]?"VALUES"c:d[b]c;}END{for(i in d){gsub(/,$/,";",d[i]);print i,d[i]}}' > $sqlfile

awk '{print >> "'$bake_logfile'";match($0,/.*nginxtime\"\:\"(.*session_id.*) HTTP/, a);print a[1]}END{system("echo -n  >"FILENAME)}' $log_file|awk -F'"' '{print$1$NF}'|awk -F'GET /heart_check?' '{print "nginx_time="$1"&"$NF}'|grep 2020|awk -F'?' '{print $1$NF}'|grep -v "^$"|awk '{printf "INSERT INTO cloud_study.study_log";nginx_time=$4;split($1,a,"&");for(i in a){split(a[i],b,"=");c[b[1]]=b[2]};for(i in c){if(i!="abcabcacbsad"){key=key?key","i:i;c[i]=c[i]?"'\''"c[i]"'\''":"0";value=value?value","c[i]:c[i]}};print "("key") VALUES(" value ");";key=value=None}' |sed  "s/'\+/'/g"|sort |uniq > $sqlfile

# 逐行插入sql，并保存错误信息,(因此未整个导入sql文件)
# sql用户名 studyuser 无密码 只对该ip该库有权限； 更换地址请重新添加用户
# 读取文件太大，占用太多内存，改为逐行读取
echo `date` "sql逐行入库" >> $run_log
sqlline=`wc -l $sqlfile|awk '{print $1}'` #INSERT 条数
# 导入文件
temperrorlogfile=`cat /dev/urandom |tr -dc '0-9a-zA-Z'|head -c 20`
error_count=`mysql -h$sqlhost -P$sqlport -u$sqluser -p$sqlpassword -f < $sqlfile 2>&1 | tee -a $temperrorlogfile |wc -l|awk '{print $1}'`
if [[ error_count != 0 ]]
	then echo -----------`date`-------------- >> $sqlerror
        echo "++++++++++++++++++++ 插入数据 ++++++++++++++++++++++"
	echo `date` errorsqlfile info $sqlfile >> $sqlerror
	cat $temperrorlogfile >> $sqlerror
	echo end >> $sqlerror
fi
rm -rf $temperrorlogfile
# 结束
echo `date` "分析完成" >> $run_log
let use_time=`date +%s`-start_time
echo `date` "脚本执行用时${use_time}秒,共计${sqlline}条日志,入库失败条数${error_count}条。" >> $run_log
