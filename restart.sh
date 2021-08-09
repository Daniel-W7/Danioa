#!/bin/bash
#
#Auther：Daniel
#Date&Time：2021年8月9日
#Discription：实现通过脚本自动重启tomcat

#定义Tomcat的安装目录，需要根据自己的部署位置调整
echo "Hello,please choose your tomcat to restart:"
read -p "Your choice(ht,gfzq,waibao,tuoguan,zx,hx,zs,zyjj,xcgf,dsq,Tomcat):" TOMCATVERSION
case $TOMCATVERSION in
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
esac

#关闭对应的tomcat
echo "$TOMCATVERSION is shuting..."
$TOMCATPATH/bin/shutdown.sh &>/dev/null
sleep 3
ps -ef | grep $TOMCATVERSION | grep -v grep | awk '{print $2}' | sed -e "s/^/kill -9 /g" | sh -
sleep 1

#启动tomcat,并查看对应日志
echo "$TOMCATVERSION shut successfully,$TOMCATVERSION is starting..." 
sleep 1
$TOMCATPATH/bin/startup.sh &>/dev/null
tail -f $TOMCATPATH/logs/catalina.out
