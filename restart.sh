#!/bin/bash
#
#作者：王海迪
#日期：2021年8月8日
#脚本描述：Tomcat程序实现脚本自动重启

#定义Tomcat的安装目录，需要根据自己的部署位置调整
echo "Tomcat is shuting..."
TOMCATPATH=/opt/webserver/Tomcat-8.5.63

#关闭对应的tomcat
ps -ef | grep tomcat | grep -v grep | awk '{print $2}' | sed -e "s/^/kill -9 /g" | sh -
sleep 1

#启动tomcat
echo "Tomcat is shut successfully,tomcat starting..." 
$TOMCATPATH/bin/startup.sh
#判断tomcat是否正常启动,并查看对应日志
tail -f /opt/webserver/Tomcat-8.5.63/logs/catalina.out

