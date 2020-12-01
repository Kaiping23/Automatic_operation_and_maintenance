# for my job
192897
192898
192899
192900
192901
192902
192903
192904
192905
192906
192907
192908

'192897','192898','192899','192900','192901','192902','192903','192904','192905','192906','192907','192908'
-- 这些服务配置四星级课程
  SELECT vl.`code`,MAX(vli.learningInformationId)
	 FROM vmb_learningactivity AS vl
	INNER JOIN vmb_learninginformation AS vli ON vli.learningactivityid = vl.learningActivityId
	-- WHERE vl.`code` IN ('180001')
	WHERE vl.`code` IN ('192897','192898','192899','192900','192901','192902','192903','192904','192905','192906','192907','192908')
	GROUP BY vl.`code`;

  SELECT vl.`code`,CONCAT('>=',ROUND(vli.duration*0.9))
	 FROM vmb_learningactivity AS vl
	INNER JOIN vmb_learninginformation AS vli ON vli.learningactivityid = vl.learningActivityId
	-- WHERE vl.`code` IN ('180001')
	WHERE vl.`code` IN ('192897','192898','192899','192900','192901','192902','192903','192904','192905','192906','192907','192908')
	GROUP BY vl.`code`;

-- 虚拟机初始化
https://raw.githubusercontent.com/a001189/scripts/master/init_intall.sh

-- 新加服务器，需要在新的服务器上完成以下操作
--     购买相同配置服务器选择 包年包月 华东2 可用区B 自定义镜像app-add-image 16c 64G 存储 系统盘 SSD云盘100G 数据盘高效云盘 400G 专有网络wmy-prod 交换机wmy-prod-vs
--     分配公网ip 带宽计费模式 按流量使用 带宽峰值 100M 安全组 弹性网卡wmy-prod-vs 实例名称 主机名
--     app-add-images-base 加入到默认资源组 专用网络
--     oss挂载
--     配置前端服务器nginx的网关 在upstream-gateway.conf中加入后端服务的 server ip
--     注册docker仓库
--     对比检查容器状态


sit环境cleverbee服务域名:
sit.authzmenu.kmelearning.com

sudo yum install -y curl policycoreutils-pythonopenssh-server
sudo systemctl enable sshd

sudo systemctl start sshd

yum groupinstall "X Window System" -y
# openoffice4解析失败   安装文泉驿中文字体
yum install -y 'wqy-*'

220.248.15.46

193035 改类型为微系列

Docker配置本地镜像与容器的存储位置
https://blog.csdn.net/wenwenxiong/article/details/78728696
00-50-56-38-50-28

-- 服务ID：BD3B-0TDW-798P-IHZS
BD3B-0TDW-798P-IHZS

 Upgrading (Failed to allocate instance [container:1i8605]: Bad instance [container:1i8605] in state [error]: Allocation failed: No healthy hosts meet the resource constraints: [31025:80/tcp portReservation, instanceReservation: 1].)
 BCUA-O1AY-1XR6-SLC0
 AAABNA0ODAoPeNptkMtqwzAQRff6CkE37ULBUuq8QNBU9iLgxCVOSgvdqGKSiNqKkeTQ9Our2Al9k
IVg0Nx758zcrHYNTkBhNsBRPInohA6xKFaYRXSMEnDK6trrveFibzZlA0YBvi3AHsDevU1wepBlI
08CJCy0RSI98JOdUEbYAAWjl8ovZAX8Q+pam208og/bSuqyp/YVUiG5FxT6ANzbBrqPwkvrwfKNL
B1cQtJ5MF1P+SH5FZJpBcbB6lhDO1/k83m6FLNphsqu9QzWnTwMhWjjwciwYfpZa3s8L8IiElHCY
pTbrTTadTOO+munKeouMUv4o1hPSU6nr4S+LAekyESEinTBwyMZvR/Gw/64j848QZ/Nkr+tlnfRV
O9g883aBSxO6MVwHeipsWonHfy/+DedWZg2MCwCFHBsw2lOEPFq6KwXxcClUajm0RUyAhRuX9m9R
40g2LozIVUg4+sGmI7D6w==X02ff

 -- 浦发月报提供数据2019年12月(相应课程的学习记录)
        SELECT la.`code` AS 课程编码,
             vdi.display AS 课程类型,
             la.`name` 课程名称,
             CASE WHEN vd.`itemId`= 48 THEN '已上架' WHEN vd.`itemId`= 18 THEN '已下架' ELSE '未上架' END AS 课程状态,
             t.`用户名`,
             t.`姓名`,
             t.`所属企业`,
             t.`所属学院`,
             sec_to_time(sum(TIMESTAMPDIFF(SECOND, sd.`starttime`, sd.`endtime`))) 总学习时长,
             sum(TIMESTAMPDIFF(SECOND, sd.`starttime`, sd.`endtime`)) / 60 AS 分钟数,
             min(sd.`starttime`) 开始时间,
             max(sd.`endtime`) 最后一次学习时间,
             COUNT(sd.`accountid`) AS 学习次数仅供参考,
             CASE WHEN max(sd.`sucessfuled`)= 1 THEN "完成" ELSE "未完成" END AS 完成情况, max(sd.`score`) 课程分数, t.`用户状态`
        FROM(
      SELECT ac.`accountId` id, concat(" '", ac.`name` ) 用户名,
              ac.`fullname` 姓名,
              ven.`name` AS 所属企业,
              vc.`name` AS 所属学院,
            CASE
                WHEN ena.`states` = 1 THEN
                ' 启用 ' ELSE ' 禁用 '
              END AS 用户状态
            FROM
              `vmb_account` ac
              INNER JOIN `vmb_enterpriseaccount` ena ON ena.`accountid` = ac.`accountId`
              AND ena.`enterpriseid` = 1
              INNER JOIN `vmb_member` me ON me.`accountId` = ac.`accountId`
              INNER JOIN vmb_enterprise AS ven ON ven.enterpriseId = me.enterpriseId
              INNER JOIN vmb_collegeorg AS vco ON vco.orgId = me.ordId
              INNER JOIN vmb_college AS vc ON vc.collegeId = vco.collegeId
              -- WHERE ac.`name` = 'km_yanglijun@spdb'
            GROUP BY
              ac.`accountId`
            ) t
            INNER JOIN `vmb_studyrecorde` sd ON sd.`accountid` = t.id
            INNER JOIN `vmb_learningactivity` la ON la.`learningActivityId` = sd.`learningactivityid`
            INNER JOIN vmb_dictionaryitem AS vdi ON vdi.itemId = la.actType
            INNER JOIN `vmb_dictionaryitem` AS vd ON vd.`itemId` = la.`states`
          WHERE
            sd.enterpriseid = 1
        AND sd.`starttime` >= '2019-12-01 00:00:00'
        AND sd.`starttime` < '2020-01-01 00:00:00'
          GROUP BY
            t.id,
          la.`learningActivityId`

2020/1/3
-- 查下这个网站：http://wx_auth.km365.pw/

-- 192.168.1.42	00-50-56-38-50-42



-- 新家项目
ssh://git@g.km365.pw:122/backend/examinations/album-project.git album
ssh://git@g.km365.pw:122/backend/examinations/comment-project.git commentcomment





-- 前端域名：https://elearning.marykay.com.cn

mlk-prod-web1 101.133.154.121
mlk-prod-web2 101.133.145.156
mlk-prod-app1 139.196.9.183
mlk-prod-app2 47.103.156.238


# 创建后端应用

#rancher server -10
 mkdir -p /var/lib/rancher-mysql /var/lib/rancher
 docker run -d -v /var/lib/rancher-mysql:/var/lib/mysql -v /var/lib/rancher:/var/lib/rancher --restart=always  --name=rancher-server -p 8181:8080 rancher/server:v1.6.18

MarykayAdmin
MKadmin@123!



readonly
k4&tc#SLs5SRBmjDtDKyre9g





