#!/usr/bin/python3
# _*_coding=utf-8 _*_
# @author lkp
# @date 2020/4/28 下午4:40


def read_log(logname, keyword):
    tell = 0  # 文件指针
    i = 1  # 行号
    while True:
        f = open(logname)
        f.seek(tell)  # 移动文件指针
        res = []  # 存所有的结果

        for line in f:
            if keyword in line:
                print(line)
                res.append('行号【%s】 内容：%s \n' % (i, line))

            i += 1

        tell = f.tell()

        f1 = open('res.txt', 'a')
        f1.writelines(res)
        f1.flush()


read_log('catalina.out', 'ERROR')
