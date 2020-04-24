#!/usr/bin/python
# -*- coding: utf-8 -*-
# @author lkp
# @date 2020/1/5 16:22


# 发送邮件
import smtplib

from email.mime.text import MIMEText

HOST = "smtp.gmail.com"
SUBJECT = u"Test email from Python 官网流量数据报表"
TO = "15237806127@163.com"
FROM = "990814268@qq.com"
msg = MIMEText("""
<table width="800" border="0" cellspacing="0" cellpadding="4"> 

  <tr> 

    <td bgcolor="#CECFAD" height="20" style="font-size:14px">Website data  官网数据 <a href="monitor.domain.com">more 更多 >></a></td> 

  </tr> 

  <tr> 

    <td bgcolor="#EFEBDE" height="100" style="font-size:13px"> 

    1)day_traffic:<font color=red>152433</font>  traffic:23651 page_traffic:45123 click:545122  data_flow:504Mb<br> 

    2)Status code information<br> 

    &nbsp;&nbsp;500:105  404:3264  503:214<br> 

    3)user information<br> 

    &nbsp;&nbsp;IE:50%  firefox:10% chrome:30% other:10%<br> 

    4)page information<br> 

    &nbsp;&nbsp;/index.php 42153<br> 

    &nbsp;&nbsp;/view.php 21451<br> 

    &nbsp;&nbsp;/login.php 5112<br> 

    </td> 

  </tr> 

</table>""", "html", "utf-8")

msg['Subject'] = SUBJECT
msg['From'] = FROM
msg['To'] = TO


try:
    smtp = smtplib.SMTP()
    smtp.connect('smtp.qq.com', 25)
    smtp.login('990814268@qq.com', 'pzyhswadxcctbbdb')
    # pzyhswadxcctbbdb
    smtp.sendmail('990814268@qq.com', '15237806127@163.com', msg.as_string())
    smtp.sendmail('990814268@qq.com', 'liangkaiping@fulan.com.cn', msg.as_string())
    print("发送成功！")
    smtp.quit()
except Exception as e:
    print("发送失败！")
    print("lose:" + str(e))
