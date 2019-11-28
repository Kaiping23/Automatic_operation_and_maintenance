#!/usr/bin/env bash

for i in eureka aliyun assignment certificate config course customproject enroll esearch exam gateway job live log manage message point research shenwanhongyuan sign site statistics student studylog system trainning vote wechat lecturer;
do

sed "s/base/$i/" base.rancher.yaml >$i.rancher.yaml

done