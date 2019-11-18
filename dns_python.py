#!/usr/bin/python
# -*- coding: utf-8 -*-
# @author lkp
# @date 2019/11/18 17:07

import dns.resolver

domain = input('请输入域名地址:')

# （1） A记录， 将主机转换为IP地址
A = dns.resolver.query(domain, 'A')

print("A:", A)

for i in A.response.answer:
    print("i:", i)
    print("i.items:", i.items)
    for j in i.items:
        if j.rdtype == 1:
            print(j.address)
            print(j.rdtype)
        print(j)

print(j.address)

print(A.response.answer)
print(dns.resolver.query('www.baidu.com', 'A'))
