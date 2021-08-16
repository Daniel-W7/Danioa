#!/bin/bash
#
#Auther：Daniel
#Date&Time：2021年8月16日
#Discription：实现通过脚本自动备份，重启，更新tomcat系统
#Version：1.4
#定义Tomcat的安装目录，需要根据自己的部署位置调整
set -m
case $1 in
	-b|--backup)
		CONFIGURATION=b
		TOMCATVERSION=$2;;
	-r|--restart)
		CONFIGURATION=r
        	TOMCATVERSION=$2;;
	-u|--update)
		CONFIGURATION=u
		TOMCATVERSION=$2;;
	-h|--help)
		echo "Usage:tctconf.sh | tctconf.sh -b|--backup|-r|--restart|-u|--update|-h|--help TOMCATVERSION"
		exit 0;;
	*)
		echo "Hello,please choose your tomcat to configure(ht|gfzq|waibao|tuoguan|zx|hx|zs|zyjj|xcgf|dsq|Tomcat|q for quit):"
		#echo "Your choice(ht|gfzq|waibao|tuoguan|zx|hx|zs|zyjj|xcgf|dsq|Tomcat):"
		read -p "Your choice:" TOMCATVERSION
		echo "Please chose your configuration:(b|backup|r|restart|u|update|q for quit):"
		read -p "Your configuration:" CONFIGURATION
		#read -p "Your choice(ht|gfzq|waibao|tuoguan|zx|hx|zs|zyjj|xcgf|dsq|Tomcat):" TOMCATVERSION
		echo "Usage:tctconf.sh | tctconf.sh -b|--backup|-r|--restart|-u|--update|-h|--help TOMCATVERSION";;
esac

case $TOMCATVERSION in
        ht)            
			TOMCATPATH=/opt/webserver/tomcat8-hthof
			ROOTPATH=hthof;;

        gfzq)         
			TOMCATPATH=/opt/webserver/tomcat8-gfzqhof
			ROOTPATH=gfzqhof;;

	waibao)      
			TOMCATPATH=/opt/webserver/tomcat8-waibao
                        ROOTPATH=243waibao;;

        tuoguan)    
			TOMCATPATH=/opt/webserver/tomcat8-tuoguan
                        ROOTPATH=243tuoguan;;

        zx)       
			TOMCATPATH=/opt/webserver/tomcat8-zxhof
                        ROOTPATH=zxhof;;

        hx)      
			TOMCATPATH=/opt/webserver/tomcat8-hxhof
                        ROOTPATH=hxhof;;

        zs)     
			TOMCATPATH=/opt/webserver/tomcat8-zs
                        ROOTPATH=zs;;

        zyjj)  
			TOMCATPATH=/opt/webserver/tomcat8-zyjjfusion
                        ROOTPATH=zyjj;;

        xcgf) 
			TOMCATPATH=/opt/webserver/tomcat8-xcgf
                        ROOTPATH=sc_hof;;

        dsq) 
			TOMCATPATH=/opt/webserver/tomcat8-dsq
                        ROOTPATH=dsq;;

        Tomcat)
			TOMCATPATH=/opt/webserver/Tomcat-8.5.63
                        ROOTPATH=ROOT;;

	q)		echo "quitting"
			exit 0;;
	*)              echo "error !Please input a right choice"
			exit 1;;

esac
backup() {
        #备份对应系统
        echo "start to backup system..."
        cd $TOMCATPATH/webapps/
        zip -r $ROOTPATH`date +%Y-%m-%d-%H:%M:%S`.zip $ROOTPATH
}
restart() {
        #重启tomcat
        echo "Start to restart system..."
        #关闭对应的tomcat
        echo "$TOMCATVERSION is shuting..."
        $TOMCATPATH/bin/shutdown.sh &>/dev/null
        sleep 3
        ps -ef | grep $TOMCATPATH | grep -v grep | awk '{print $2}' | sed -e "s/^/kill -9 /g" | sh -
        sleep 1
        #启动tomcat,并查看对应日志
        echo "$TOMCATVERSION shut successfully,$TOMCATVERSION is starting..." 
        sleep 1
        $TOMCATPATH/bin/startup.sh &>/dev/null
        tail -f $TOMCATPATH/logs/catalina.out
}
update() {
backup
        #进行文件更新
        echo "Start to update system..."
        sleep 2
        \cp -a ./package/upload/* $TOMCATPATH/webapps/$ROOTPATH
        #删除本次更新文件
        rm -rf ./package/upload/*
        #重启tomcat
        echo "Start to restart system..."
restart
}

case $CONFIGURATION in
	
	b|backup)
		backup;;
	r|restart)
		restart;;
	u|update)
		update;;
	q)	
		echo "quitting"
		exit 0;;

	*)
		echo "error! Please input a right configuration";;

esac

