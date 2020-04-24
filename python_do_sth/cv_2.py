#!/usr/bin/python3
# _*_coding=utf-8 _*_
# @author lkp
# @date 2020/3/31 17:24

import cv2

vidcap = cv2.VideoCapture('D:\work\my_code\Automatic_operation_and_maintenance\python_do_sth\video\video.avi')
success, image = vidcap.read()
count = 0
success = True
while success:
    success, image = vidcap.read()
    # save frame as JPEG file
    cv2.imwrite("D:\work\my_code\Automatic_operation_and_maintenance\python_do_sth\pic\frame%d.jpg" % count, image)
    if cv2.waitKey(10) == 27:
        break
    count += 1
