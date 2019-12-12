#!/usr/bin/python
# -*- coding: utf-8 -*-
# @author lkp
# @date 2019/12/11 22:44

import requests, json, smtplib

# r = requests.get("http://open.iciba.com/dsapi").json()
# print(r)

data = {
    'link': 'http://open.iciba.com/dsapi/',
    'link2': 'http://wthrcdn.etouch.cn/weather_mini?city=',
    'city': '上海',
    'first': '您的小可爱上线啦！\r\n',
    'last': '\r\n\r\n'

}


def get_wether(city, link):
    url = link + city
    r = requests.get(url).json()
    msg = '\r\n亲爱的宝贝，今天天气是' + r['data']['forecast'][0]['type'] + '\r\n温度：' + r['data']['forecast'][0]['high'] + '--' + \
          r['data']['forecast'][0]['low'] + '\r\n风：' + r['data']['forecast'][0]['fengli'][9:-3] + '--' + \
          r['data']['forecast'][0]['fengxiang'] + '\r\n\r\n我到公司啦，么么哒！'

    return str(msg)


# 获取每日一句话
def get_word(link):
    r = requests.get(link).json()
    msg = '\r\n\r\n' + r['content'] + '\r\n\r\n' + r['note']
    return str(msg)


# 构造邮件的文本数据
msg = data['first'] + get_wether(data['city'], data['link2']) + get_word(data['link']) + data['last']
message = """From:From 开平 <990814268@qq.com>
To: To Ivy <649786147@qq.com>
Subject:亲爱的。请点击查收！
This is a e-mail message.
""" + msg

# 发送邮件
smtp = smtplib.SMTP()
smtp.connect('smtp.qq.com', 25)
smtp.login('990814268@qq.com', 'secrect')
# pzyhswadxcctbbdb
smtp.sendmail('990814268@qq.com', '649786147@qq.com', message.encode('utf-8'))
smtp.quit()
