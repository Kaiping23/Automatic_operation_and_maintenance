#!/usr/bin/env bash
rm -rf /etc/nginx
rsync  -a 47.101.138.12:/opt/nginx/conf/ /etc/nginx
rm -rf /etc/nginx/conf.d/swhy.api.kmelearing.com.conf
mkdir -p /usr/share/nginx/logs
mkdir -p /var/log/nginx/heart_check