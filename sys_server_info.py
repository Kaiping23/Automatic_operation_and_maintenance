#!/usr/bin/python
# -*- coding: utf-8 -*-
# @author lkp
# @date 2019/11/18 19:38

# import psutil, datetime
#
# print "hello"
# print "python --version"
#
# var1 = 'Hello World!'
# var2 = "Python Runoob"
#
# print "var1[0]: ", var1[0]
# print "var2[1:5]: ", var2[1:5]
#
# # cpu
# percpu = True
# print psutil.cpu_times()  # cpu完整信息
# print psutil.cpu_times().user  # 用户user的cpu时间
# # print psutil.cpu_count()    #cpu逻辑个数
# print psutil.cpu_count(logical=False)  # cpu物理个数
# print psutil.cpu_times(percpu=True)
#
# # mem
# mem = psutil.virtual_memory()
# print "mem:", mem
# print mem.total, mem.used, mem.free
# print "swap_memory:", psutil.swap_memory()
#
# # disk
# # 完整信息
# print psutil.disk_partitions()
# # 分区使用情况
# print psutil.disk_usage('/')
#
# # io个数，读写信息（总）
# print psutil.disk_io_counters()
# print psutil.disk_io_counters(perdisk=True)
#
# # 网络信息
# print psutil.net_io_counters()
#
# # 其他系统信息
# print psutil.users()
# print psutil.boot_time()
# print datetime.datetime.fromtimestamp(psutil.boot_time()).strftime("%Y-%m-%d %H:%M:%S")
#
# # 进程信息
# print psutil.pids()
#
# p = psutil.Process(13973)
# print p.name()
# print p.exe()
# print p.cwd()
# print p.status()
# print datetime.datetime.fromtimestamp(p.create_time()).strftime("%Y-%m-%d %H:%M:%S")
# print p.uids()
# print p.gids()
# print p.cpu_times()
# print p.cpu_affinity()
# print p.memory_percent()
# print p.memory_info()
# print p.io_counters()
# print p.connections()
#
# # popen类使用
# from subprocess import PIPE
#
# q = psutil.Popen(["/usr/bin/python", "-c", "print('hello')"], stdout=PIPE)
# print "q:", q
# print q.name()
# print q.username()
# print q.communicate()
# # print q.cpu_times()
#
#
# a = 10
# b = 5
# c = a // b
# print "7 - c 的值为：", c
#
# from IPy import IP
#
# print IP('10.0.0.0/8').version()
# print IP('::1').version()
# ip = IP('192.168.0.0/16')
# print ip.len()
# # for x in ip:
# # print x
#
# ip_new = IP('192.168.1.20')
# print ip_new.reverseNames()
# print ip_new.iptype()
# print IP('8.8.8.8').iptype()
# print IP('8.8.8.8').int()
# print IP('8.8.8.8').strHex()
# print IP('8.8.8.8').strBin()
# print IP(0x8080808)
#
# # 支持网络地址转换
# print (IP('192.168.1.0').make_net('255.255.255.0'))
# print (IP('192.168.1.0/255.255.255.0', make_net=True))
#
# private_ipaddr = IP('192.168.0.0/24')
# public_ipaddr = IP('123.150.204.166')
# print(public_ipaddr.make_net('255.255.0.0'))  # 查询IP所在的网段
# print(public_ipaddr.reverseNames())  # 查看该IP地址的反向解析
# print(private_ipaddr.version())  # 查看IP地址的版本
# print(public_ipaddr.iptype())
#
# # #######################ip地址格式转换#####################
#
#
# print(private_ipaddr.int())  # 转换成整型格式            3232235520
# print(private_ipaddr.strBin())  # 把IP地址转换成二进制格式  11000000101010000000000000000000
# print(private_ipaddr.strHex())  # 把IP地址转换成16进制格式  0xc0a80000


# import nmap
#
# nm = nmap.PortScanner()
# result = nm.scan('192.168.1.0/24', arguments="-sP").get('scan')  #
#
# for k, v in result.items():  # result返回1个大字典{'nmap': '本次扫描元信息描述','scan':'扫描结果'}
#     print(k, v)
