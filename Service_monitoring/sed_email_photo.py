#!/usr/bin/python
# -*- coding: utf-8 -*-
# @author lkp
# @date 2020/1/5 16:22


# 发送邮件
import smtplib
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText
from email.mime.image import MIMEImage

HOST = "smtp.gmail.com"
SUBJECT = u"业务性能数据报表"
TO = "15237806127@163.com"
FROM = "990814268@qq.com"


def addimg(src, imagid):
    fp = open(src, 'rb')
    msgImage = MIMEImage(fp.read())
    fp.close()
    msgImage.add_header('Content-ID', imagid)
    return msgImage


msg = MIMEMultipart('related')

msgtext = MIMEText("""
<table width="600" border="0" cellspacing="0" cellpadding="4">
<tr bgcolor="#CECFAD" height="20" style="font-size:14px">
<td colspan=2>*Website performance data <a href="monitor.domain.com">more>></a></td>
</tr>
<tr bgcolor="#EFEBDE" height="100" style="font-size:13px">
<td>
<img src="cid:io"></td><td>
<img src="cid:key_hit"></td>
</tr>
<tr bgcolor="#EFEBDE" height="100" style="font-size:13px">
<td>
<img src="cid:men"></td><td>
<img src="cid:swap"></td>
</tr>
</table>""", "html", "utf-8")

msg.attach(msgtext)
msg.attach(addimg("D:\work\my_code\Automatic_operation_and_maintenance\Service_monitoring\img\ytes_io.png", "io"))

msg.attach(addimg("D:\work\my_code\Automatic_operation_and_maintenance\Service_monitoring\img\myisam_key_hit.png", "key_hit"))
msg.attach(addimg("D:\work\my_code\Automatic_operation_and_maintenance\Service_monitoring\img\os_mem.png", "men"))
msg.attach(addimg("D:\work\my_code\Automatic_operation_and_maintenance\Service_monitoring\img\os_swap.png", "swap"))
msg['Subject'] = SUBJECT  # subject
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
