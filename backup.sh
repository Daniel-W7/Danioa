#!/bin/bash
#
#Auther：Daniel
#Date&Time：2021年8月9日
#Discription：实现通过脚本自动部署系统

#定义Tomcat的安装目录，及系统的部署名称，需要根据自己的部署情况调整
#echo "Hello,please choose your system to backup:"
#read -p "Your choice(ht|gfzq|waibao|tuoguan|zx|hx|zs|zyjj|xcgf|dsq|Tomcat):" TOMCATVERSION
case $1 in
        ht)             SYSPATH=/opt/webserver/tomcat8-hthof/webapps/
			ROOTPATH=hthof;;
        gfzq)           SYSPATH=/opt/webserver/tomcat8-gfzqhof/webapps/
			ROOTPATH=gfzqhof;;
        waibao)         SYSPATH=/opt/webserver/tomcat8-waibao/webapps/
			ROOTPATH=243waibao;;
        tuoguan)        SYSPATH=/opt/webserver/tomcat8-tuoguan/webapps/
			ROOTPATH=243tuoguan;;
        zx)             SYSPATH=/opt/webserver/tomcat8-zxhof/webapps/
			ROOTPATH=zxhof;;
        hx)             SYSPATH=/opt/webserver/tomcat-hxhof/webapps/
			ROOTPATH=hxhof;;
        zs)             SYSPATH=/opt/webserver/tomcat8-zsfusion/webapps/
			ROOTPATH=zs;;
        zyjj)           SYSPATH=/opt/webserver/tomcat8-zyjjfusion/webapps/
			ROOTPATH=zyjj;;
        xcgf)           SYSPATH=/home/xbrl/tomcat8-xcgf/webapps/
			ROOTPATH=sc_hof;;
        dsq)            SYSPATH=/home/xbrl/tomcat8-dsq/webapps/
			ROOTPATH=dsq;;
        Tomcat)         SYSPATH=/opt/webserver/Tomcat-8.5.63/webapps/
			ROOTPATH=ROOT;;
	-h)		echo "Usage:backup.sh ht|gfzq|waibao|tuoguan|zx|hx|zs|zyjj|xcgf|dsq|Tomcat,backup.sh -h for help"
                        exit 0;;

	*)		echo "Usage:backup.sh ht|gfzq|waibao|tuoguan|zx|hx|zs|zyjj|xcgf|dsq|Tomcat"
			exit 2;;
esac

#将对应的版本下的系统文件进行压缩备份
cd $SYSPATH
#if [ -e $ROOTPATH`date +%Y%m%d`.zip ]; then
#	for I in {1..5};do
#		if [ -e $ROOTPATH`date +%Y%m%d`（$I）.zip ]; then
#			$I++
#			shift 1
#		else
#			zip -r $ROOTPATH`date +%Y%m%d`（$I）.zip $ROOTPATH
#			exit 0		
#		fi
#	done
#else
zip -r $ROOTPATH`date +%Y-%m-%d-%H:%M:%S`.zip $ROOTPATH
#fi
