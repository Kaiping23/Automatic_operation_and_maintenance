#!/usr/bin/python
# -*- coding: utf-8 -*-
# @author lkp
# @date 2020/4/13 15:13


from selenium import webdriver
import itchat
from lxml import etree
import requests
import re
import os
import datetime
import random
import time


# message = """
#
# 亲爱的{}:
# 早上好，今天是你和kai相恋的第{}天~
# 今天他想对你说的话是：
# {}
# 最后也是最重要的！
#
# """.format("Yao", str(inLoveDays), love_word)


def crawl_Love_words():
    print("正在抓取。。。")
    options = webdriver.FirefoxOptions()
    options.add_argument("-headless")
    browser = webdriver.Firefox(options=options)
    url = "https://www.duanwenxue.com/article/4825657.html"
    browser.get(url)
    html = browser.page_source
    Selector = etree.HTML(html)
    love_words_xpath_str = "//div[@id='content']/p/text()"
    love_words = Selector.xpath(love_words_xpath_str)
    for i in love_words:
        word = i.strip("\n\t\u3000\u3000").strip()  ###\u3000 是全角的空白符
        with open("love_word.txt", "a")as file:
            file.write(word + "\n")
    print("情话抓取完成")


def crawl_love_image():
    print("正在抓取我爱你图片...")
    for i in range(1, 5):
        url = "http://tieba.baidu.com/p/3108805355?pn={}".format(i)
        response = requests.get(url)
        html = response.text
        pattern = re.compile(
            r'<div.*?class="d_post_content j_d_post_content.*?">.*?<img class="BDE_Image" src="(.*?)".*?>.*?</div>',
            re.S)
        image_url = re.findall(pattern, html)
        for j, data in enumerate(image_url):
            pics = requests.get(data)
            mkdir("pic_path")
            fq = open("pic_path" + '\\' + str(i) + "_" + str(j) + '.jpg', 'wb')  # 下载图片，并保存和命名
            fq.write(pics.content)
            fq.close()
    print("图片抓取完成")


def mkdir(path):
    folder = os.path.exists(path)
    if not folder:  ##判断是否存在文件夹如果不存在则创建文件夹
        os.makedirs(path)  ##makedirs创建文件时如果路径不存在会创建这个路径
        print("---new folder---")
        print("--- OK ---")
    else:
        print("正在保存图片中...")


def send_news():
    ###计算相恋的天数
    inLoveDate = datetime.datetime(2014, 2, 14)  ##相恋的时间
    todayDate = datetime.datetime.today()
    inLoveDays = (todayDate - inLoveDate).days
    ####获取情话
    file_path = os.getcwd() + '\\' + "love_word.txt"
    with open(file_path, "r") as file:
        love_word = file.readlines()[random.randint(0, 123)].split('：')[1]  ###这用中文：,因为文件中是以中文：分割的

    itchat.auto_login(hotReload=False)  ##热启动，不需要多次扫码登录
    my_friend = itchat.search_friends(name="橙子")
    girlfriend = my_friend[0]["UserName"]
    print(girlfriend)
    message = """
    亲爱的{}:
    早上好，今天是和你相恋的第{}天~
    今天想对你说的话是：
    {}
    最后也是最重要的！
    """.format("玲玲", str(inLoveDays), love_word)
    itchat.send(message, toUserName=girlfriend)
    pic_path = os.getcwd() + "\\" + "pic_path"
    files = os.listdir(pic_path)
    file = files[random.randint(0, 66)]
    love_image_file = pic_path + "\\" + file
    try:
        itchat.send_image(love_image_file, toUserName=girlfriend)
    except Exception as e:
        print(e)


def main():
    file = os.path.exists("love_word.txt")
    if not file:  ##判断是否存在love_word.txt,没有的话就去爬取
        crawl_love_words()
    img = os.path.exists("pic_path")
    if not img:
        crawl_love_image()
    send_news()


if __name__ == '__main__':
    while True:
        curr_time = time.strftime("%Y-%m-%d %H:%M:%S", time.localtime())
        love_time = curr_time.split(" ")[1]
        if love_time == "19:13:00":
            main()
            time.sleep(60)
        else:
            print("爱你的每一天都是如此美妙，现在时间：" + love_time)
