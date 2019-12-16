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
    oss挂载
    eureka添加服务

sit环境cleverbee服务域名:
sit.authzmenu.kmelearning.com

sudo yum install -y curl policycoreutils-pythonopenssh-server
sudo systemctl enable sshd

sudo systemctl start sshd

220.248.15.46


