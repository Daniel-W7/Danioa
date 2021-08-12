#!/bin/bash
#
echo "Start to clean tomcat-install.."
sleep 1
ps -ef | grep backup.sh | grep -v grep | awk '{print $2}' | sed -e "s/^/kill -9 /g" | sh - &>null
ps -ef | grep restart.sh| grep -v grep | awk '{print $2}' | sed -e "s/^/kill -9 /g" | sh - &>null
ps -ef | grep update.sh | grep -v grep | awk '{print $2}' | sed -e "s/^/kill -9 /g" | sh - &>null
echo "tomcat-install clean successfully!"
