#!/usr/bin/python3
# -*- coding: utf-8 -*-
# @author lkp
# @date 2019/11/18 17:07

from dns import resolver
import os
import httplib2

iplist = []  # 定义域名ip列表变量
# appdomain = "www.baidu.com"  # 定义业务域名
appdomain = "www.google.com.hk"  # 定义业务域名
# appdomain = "km.vmobel.com"  # 定义业务域名


def get_iplist(domain=""):  # 域名解析函数，解析成功IP将被追加到iplist
    try:
        A = resolver.query(domain, 'A')
    except Exception as e:
        print("dns resolver error:" + str(e))
        return
    for i in A:
        iplist.append(i)  # 追加到iplist
        return True


def checkip(ip):
    checkurl = str(ip) + ":80"
    getcontent = ""
    httplib2.socket.setdefaulttimeout(5)  # 定义http连接的超时时间为5s
    conn = httplib2.HTTPConnectionWithTimeout(checkurl)  # 创建http连接对象
    try:
        conn.request("GET", "/", headers={"Host": appdomain})  # 添加URL请求，添加host主机头
        r = conn.getresponse()
        print("r=",r)
        getcontent = r.read(15)
        print("getcontent=%s" % getcontent)
        # print("response=%s" % response)

    finally:
        print("getcontent=", getcontent)
        if getcontent == b"<!DOCTYPE html>":
            print(str(ip) + " [OK]")
        else:
            print(str(ip) + " [Error]")


if __name__ == '__main__':
    if get_iplist(appdomain) and len(iplist) > 0:
        for ip in iplist:
            checkip(ip)
    else:
        print("dns resolver error.")
