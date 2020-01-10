#!/usr/bin/python
# -*- coding: utf-8 -*-
# @author lkp
# @date 2020/1/5 16:22


# 发送邮件
import smtplib

import string

HOST = "smtp.gmail.com"
SUBJECT = "Test email from Python"
TO = "15237806127@163.com"
FROM = "990814268@qq.com"
text = "Python rules them all!"
BODY = string.join((
    "From:%s" % FROM,
    "To:%s" % TO,
    "Subject:%s" % SUBJECT,
    "",
    text
), "\r\n")
server=smtplib

smtp = smtplib.SMTP()
smtp.connect('smtp.qq.com', 25)
smtp.login('990814268@qq.com', 'pzyhswadxcctbbdb')
# pzyhswadxcctbbdb
# smtp.sendmail('990814268@qq.com', '15237806127@163.com', message.encode('utf-8'))
smtp.sendmail('990814268@qq.com', '649786147@qq.com', message.encode('utf-8'))
smtp.quit()
