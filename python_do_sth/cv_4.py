#!/usr/bin/python3
# _*_coding=utf-8 _*_
# @author lkp
# @date 2020/3/31 18:14

import time
import os
import cv2
import re


def resort(list):
    for i in range(len(list) - 1):
        for j in range(len(list) - 1):
            if int(re.findall(r'\d+', list[j])[0]) > int(re.findall(r'\d+', list[j + 1])[0]):
                list[j], list[j + 1] = list[j + 1], list[j]

    return list


def picvideo(path, size):
    filelist = os.listdir(path)
    filelist = resort(filelist)
    """
    fps:帧率：1秒钟有n张图片写进去控制一张图片停留5秒钟，那就是帧率为1，重复播放这张图片5次
    如果文件夹下有50张534*300的照片，这里设置一秒钟播放5张，那么这个视频的时长就是10秒
    """
    fps = 24
    file_path = 'video/new.mp4'
    fourcc = cv2.VideoWriter_fourcc('D', 'I', 'V', 'X')
    video = cv2.VideoWriter(file_path, fourcc, fps, size)
    for item in filelist:
        if item.endswith('jpg'):
            item = path + '/' + item
            img = cv2.imread(item)
            video.write(img)

    video.release()


picvideo(r'new', (960, 544))
