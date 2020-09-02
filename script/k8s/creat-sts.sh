mkdir -p deploy sts
for i in aliyun assignment certificate config course customproject enroll esearch exam gateway job live log manage message point research shenwanhongyuan sign site statistics student studylog system trainning vote wechat lecturer;do echo $i;sed "s/#JOB/$i/g" deploy-base.yaml >deploy/deploy-$i.yaml; done

port=31001
expose_ip=192.168.1.114
echo > svc.txt
for i in eureka aliyun assignment certificate config course customproject enroll esearch exam gateway job live log manage message point research shenwanhongyuan sign site statistics student studylog system trainning vote wechat lecturer;
do echo $i;sed "s/#JOB/$i/g" sts-base.yaml |sed  "s/#PORT/$port/g" >sts/sts-$i.yaml;
echo "$i ${expose_ip}:$port" >> svc.txt
let port=port+1
done

#frontend
mkdir -p job
for i in admin student-h5 wmyPc
do
 echo $i;sed "s/#JOB/$i/g" job-base.yaml |awk '{if($0 ~ /image:/){print tolower($0)}else{print}}' > job/job-$i.yaml
done
# 小写

for i in admin student-h5 wmypc
do
 echo $i;sed "s/#JOB/$i/g" job-base.yaml  > job/job-$i.yaml
done

