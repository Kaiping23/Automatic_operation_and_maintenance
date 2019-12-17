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
    购买相同配置服务器选择 包年包月 华东2 可用区B 自定义镜像 16c 64G 存储 系统盘 SSD云盘100G 数据盘高效云盘 400G 专有网络wmy-prod 交换机wmy-prod-vs
    分配公网ip 带宽计费模式 按流量使用 带宽峰值 100M 安全组 弹性网卡wmy-prod-vs 实例名称 主机名
    app-add-images-base 加入到默认资源组 专用网络
    oss挂载
    添加服务eureka


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



