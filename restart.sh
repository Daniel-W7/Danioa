#!/bin/bash
#
#Auther：Daniel
#Date&Time：2021年8月9日
#Discription：实现通过脚本自动重启tomcat
set -m
#定义Tomcat的安装目录，需要根据自己的部署位置调整
#echo "Hello,please choose your tomcat to restart:"
#read -p "Your choice(ht|gfzq|waibao|tuoguan|zx|hx|zs|zyjj|xcgf|dsq|Tomcat):" TOMCATVERSION
case $1 in
	ht)		TOMCATPATH=/opt/webserver/tomcat8-hthof;;
	gfzq)		TOMCATPATH=/opt/webserver/tomcat8-gfzqhof;;
	waibao)		TOMCATPATH=/opt/webserver/tomcat8-waibao;;
	tuoguan)	TOMCATPATH=/opt/webserver/tomcat8-tuoguan;;
	zx)		TOMCATPATH=/opt/webserver/tomcat8-zxhof;;
	hx)		TOMCATPATH=/opt/webserver/tomcat-hxhof;;
	zs)		TOMCATPATH=/opt/webserver/tomcat8-zsfusion;;
	zyjj)		TOMCATPATH=/opt/webserver/tomcat8-zyjjfusion;;
	xcgf)		TOMCATPATH=/home/xbrl/tomcat8-xcgf;;
	dsq)		TOMCATPATH=/home/xbrl/tomcat8-dsq;;
	Tomcat)		TOMCATPATH=/opt/webserver/Tomcat-8.5.63;;
	-h)		echo "Usage:restart.sh ht|gfzq|waibao|tuoguan|zx|hx|zs|zyjj|xcgf|dsq|Tomcat,restart.sh -h for help"
                        exit 0;;
	*)		echo "Usage:restart.sh ht|gfzq|waibao|tuoguan|zx|hx|zs|zyjj|xcgf|dsq|Tomcat"
			exit 1;;
esac

#关闭对应的tomcat
echo "$1 is shuting..."
$TOMCATPATH/bin/shutdown.sh &>/dev/null
sleep 3
ps -ef | grep $TOMCATPATH | grep -v grep | awk '{print $2}' | sed -e "s/^/kill -9 /g" | sh -
sleep 1

#启动tomcat,并查看对应日志
echo "$1 shut successfully,$1 is starting..." 
sleep 1
$TOMCATPATH/bin/startup.sh &>/dev/null
tail -f $TOMCATPATH/logs/catalina.out
ps -ef | grep restart.sh | grep -v grep | awk '{print $2}' | sed -e "s/^/kill -9 /g" | sh -

