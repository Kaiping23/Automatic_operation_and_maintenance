FROM registry.cn-shanghai.aliyuncs.com/wmy/jdk8m2
MAINTAINER ysj 
ADD jar /jar 
ADD start.sh /start.sh 
ADD version.txt  version.txt
ENV TZ=Asia/Shanghai
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
ENTRYPOINT ["sh","/start.sh"]
