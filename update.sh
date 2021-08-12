#!/bin/bash
#
#Auther：Daniel
#Date&Time：2021年8月9日
#Discription：实现通过脚本自动部署系统

#定义Tomcat的安装目录，需要根据自己的部署位置调整
echo "Hello,please choose your tomcat to update:"
read -p "Your choice(ht|gfzq|waibao|tuoguan|zx|hx|zs|zyjj|xcgf|dsq|Tomcat):" TOMCATVERSION
case $TOMCATVERSION in
        ht)             UPDATEPATH=/opt/webserver/tomcat8-hthof/webapps/hthof;;
        gfzq)           UPDATEPATH=/opt/webserver/tomcat8-gfzqhof/webapps/gfzqhof;;
        waibao)         UPDATEPATH=/opt/webserver/tomcat8-waibao/webapps/243waibao;;
        tuoguan)        UPDATEPATH=/opt/webserver/tomcat8-tuoguan/webapps/243tuoguan;;
        zx)             UPDATEPATH=/opt/webserver/tomcat8-zxhof/webapps/zxhof;;
        hx)             UPDATEPATH=/opt/webserver/tomcat-hxhof/webapps/hxhof;;
        zs)             UPDATEPATH=/opt/webserver/tomcat8-zsfusion/webapps/zs;;
        zyjj)           UPDATEPATH=/opt/webserver/tomcat8-zyjjfusion/webapps/zyjj;;
        xcgf)           UPDATEPATH=/home/xbrl/tomcat8-xcgf/webapps/sc_hof;;
        dsq)            UPDATEPATH=/home/xbrl/tomcat8-dsq/webapps/dsq;;
        Tomcat)         UPDATEPATH=/opt/webserver/Tomcat-8.5.63/webapps/ROOT;;
	*)              echo "Usage:update.sh ht|gfzq|waibao|tuoguan|zx|hx|zs|zyjj|xcgf|dsq|Tomcat"
			exit 3;;
esac
#备份初始系统
echo "Start to backup our system..."
sleep 2
./backup.sh $TOMCATVERSION
#进行文件更新
echo "Start to update system..."
sleep 2 
\cp -a ./package/upload/* $UPDATEPATH
#删除本次更新文件
rm -rf ./package/upload/*
#重启tomcat
echo "Start to restart system..."
./restart.sh $TOMCATVERSION
