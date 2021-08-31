#!/bin/bash
#
#Auther：Daniel
#Date&Time：2021年8月16日
#Discription：实现通过脚本自动备份，重启，更新tomcat系统
#定义Tomcat的安装目录，需要根据自己的部署位置调整
#配置多线程处理，避免因为脚本的退出导致tomcat自动退出的情况
set -m
#获取运行的程序名
PRONAME=`basename $0`
#获取文件运行的当前目录
TCTPATH=$(cd "$(dirname "$0")"; pwd)
MODE=COMMON
#配置选项，如果没有输入选项直接进入提示页面
case $1 in
	-b|--backup)
		CONFIGURATION=b
		MODE=PRO;;
		#TOMCATVERSION=$2
		#TOMCATPATH=`cat $TCTPATH/conf/tct.conf | grep $TOMCATVERSION | awk -F':' '{ print $2 }'`
		#ROOTPATH=`cat $TCTPATH/conf/tct.conf | grep $TOMCATVERSION | awk -F':' '{ print $3 }'`;;
	-tb|--testbackup)
		CONFIGURATION=tb
		MODE=PRO;;
		#TOMCATVERSION=$2
                #TOMCATPATH=`cat $TCTPATH/conf/tct.conf | grep $TOMCATVERSION | awk -F':' '{ print $2 }'`
                #ROOTPATH=`cat $TCTPATH/conf/tct.conf | grep $TOMCATVERSION | awk -F':' '{ print $3 }'`;;
	-r|--restart)
		CONFIGURATION=r
		MODE=PRO;;
        	#TOMCATVERSION=$2
		#TOMCATPATH=`cat $TCTPATH/conf/tct.conf | grep $TOMCATVERSION | awk -F':' '{ print $2 }'`
		#ROOTPATH=`cat $TCTPATH/conf/tct.conf | grep $TOMCATVERSION | awk -F':' '{ print $3 }'`;;
	-u|--update)
		CONFIGURATION=u
		MODE=PRO;;
		#TOMCATVERSION=$2
		#TOMCATPATH=`cat $TCTPATH/conf/tct.conf | grep $TOMCATVERSION | awk -F':' '{ print $2 }'`
		#ROOTPATH=`cat $TCTPATH/conf/tct.conf | grep $TOMCATVERSION | awk -F':' '{ print $3 }'`;;
	-tu|--testupdate)
                CONFIGURATION=tu
		MODE=PRO;;
                #TOMCATVERSION=$2
                #TOMCATPATH=`cat $TCTPATH/conf/tct.conf | grep $TOMCATVERSION | awk -F':' '{ print $2 }'`
                #ROOTPATH=`cat $TCTPATH/conf/tct.conf | grep $TOMCATVERSION | awk -F':' '{ print $3 }'`;;
	-sh|--shutdown)
		CONFIGURATION=sh
		MODE=PRO;;
	-st|--startup)
		CONFIGURATION=st
		MODE=PRO;;
	-l|--log)
		CONFIGURATION=l
		MODE=PRO;;
                #TOMCATVERSION=$2
                #TOMCATPATH=`cat $TCTPATH/conf/tct.conf | grep $TOMCATVERSION | awk -F':' '{ print $2 }'`
                #ROOTPATH=`cat $TCTPATH/conf/tct.conf | grep $TOMCATVERSION | awk -F':' '{ print $3 }'`;;
	-i|--install)
		CONFIGURATION=i
		#MODE=PRO
		INSTALLPATH=/opt
		INSTALLOPTION=full
		echo "Hello,please choose your path to install:"
                read -p "The PATH to install:(ex:/opt):" INSTALLPATH
		read -p "The option to install:(full|redis|tomcat|jdk):" INSTALLOPTION;;
	-h|--help):
		echo "Usage:tctconf.sh | tctconf.sh -b|--backup|-tb|--testbackup|-r|--restart|-u|--update|-tu|--testupdate|-sh|--shutdown|-st|--startup|-l|--log|-i|--install|-h|--help TOMCATVERSION"
		exit 0;;
	*)
		#MODE=COMMON
 		echo "Hello,please choose your tomcat to configure(ht|gfzq|waibao|tuoguan|zx|hx|xcgf|dsq|zs|zyjj|df|xcgf|dsq|qhyxh|Tomcat|q for quit):"
		echo "Your choice(ht|gfzq|waibao|tuoguan|zx|hx|zs|zyjj|xcgf|dsq|Tomcat):"
		read -p "Your choice:" TOMCATVERSION
		echo "Please chose your configuration:(b|backup|r|restart|u|update|q for quit):"
		read -p "Your configuration:" CONFIGURATION
		#read -p "Your choice(ht|gfzq|waibao|tuoguan|zx|hx|zs|zyjj|xcgf|dsq|Tomcat):" TOMCATVERSION
		TOMCATPATH=`cat $TCTPATH/conf/tct.conf | grep $TOMCATVERSION | awk -F':' '{ print $2 }'`
		ROOTPATH=`cat $TCTPATH/conf/tct.conf | grep $TOMCATVERSION | awk -F':' '{ print $3 }'`
		echo "Usage:tctconfig.sh | tctconfig.sh -b|--backup|-tb|--testbackup|-r|--restart|-u|--update|-tu|--testupdate|-sh|--shutdown|-st|--startup|-l|--log|-i|--install|-h|--help TOMCATVERSION";;
esac
#读取tct.conf文件获取对应tomcat路径和系统名称的信息
#TOMCATPATH=`cat $TCTPATH/conf/tct.conf | grep $TOMCATVERSION | awk -F':' '{ print $2 }'`
#ROOTPATH=`cat $TCTPATH/conf/tct.conf | grep $TOMCATVERSION | awk -F':' '{ print $3 }'`
#单个tomcat的情况，此处直接填写即可
#TOMCATVERSION=
#TOMCATPATH=
#ROOTPARH=
#备份对应系统
backup() {
        echo "Start to backup $TOMCATVERSION..."
        cd $TOMCATPATH/webapps/
        zip -r $ROOTPATH`date +%Y-%m-%d-%H:%M:%S`.zip $ROOTPATH >>$TCTPATH/logs/backup-`date +%Y-%m-%d`.log
	echo "$TOMCATVERSION backup successfully!!!"

}

#测试之前的完整备份
testbackup() {
        echo "Start to backup $TOMCATVERSION before test..."
        cd $TOMCATPATH/webapps/
        zip -r $ROOTPATH`date +%Y-%m-%d-%H:%M:%S`TB.zip $ROOTPATH >>$TCTPATH/logs/testbackup-`date +%Y-%m-%d`.log
	echo "$TOMCATVERSION backup before test successfully!!!"
}
#关闭对应tomcat
tctshut(){
	#echo "Start to shutdown $TOMCATVERSION..."
        #关闭对应的tomcat
        echo "$TOMCATVERSION is shuting..."
	sleep 1
        $TOMCATPATH/bin/shutdown.sh >>$TCTPATH/logs/tctshut-`date +%Y-%m-%d`.log
        ps -ef | grep $TOMCATPATH | grep -v grep | awk '{print $2}' | sed -e "s/^/kill -9 /g" | sh -
	echo "$TOMCATVERSION is shutted successfully..."
	sleep 1
}
#开启对应tomcat
tctstart(){
 	#启动tomcat,并查看对应日志
        echo "$TOMCATVERSION is starting..." 
        sleep 1
        $TOMCATPATH/bin/startup.sh >>$TCTPATH/logs/tctstart-`date +%Y-%m-%d`.log
        tail -f $TOMCATPATH/logs/catalina.out
        #ps -ef | grep tctconfig.sh | grep -v grep | awk '{print $2}' | sed -e "s/^/kill -9 /g" | sh -
}
tctrestart(){
	tctshut
	tctstart
}
#进行日常更新
update() {
	#切换到当前应用程序的目录
	#cd $TCTPATH
        #进行文件更新
        echo "Start to update $TOMCATVERSION..."
        sleep 2
        \cp -a $TCTPATH/package/update/* $TOMCATPATH/webapps/$ROOTPATH
        #删除本次更新文件
	mkdir -p $TCTPATH/package/backup/$TOMCATVERSION/`date +%Y-%m-%d-%H:%M:%S`/
        mv $TCTPATH/package/update/* $TCTPATH/package/backup/$TOMCATVERSION/`date +%Y-%m-%d-%H:%M:%S`/
	echo "$TOMCATVERSION is updated successfully!"
        #重启tomcat
        echo "Start to restart $TOMCATVERSION..."
	sleep 1
tctrestart
}
#清理参与进程
clean(){
	ps -ef | grep tctconfig.sh | grep -v grep | awk '{print $2}' | sed -e "s/^/kill -9 /g" | sh - &>/dev.null
}
#安装部署解压
#unzip(){
	#切换到当前应用程序的目录
 #       cd $TCTPATH
        #解压文件
	#echo "Start to extract files,please waiting..."
#	PACKAGENAME=`ls ./package/install/`
	
	#echo "$PACKAGENAME"
	#mv ./package/install/$PACKAGENAME ./package/install/install.zip
#	unzip -o ./package/install/$PACKAGENAME.zip
	#sleep 2
	#mkdir -p $TCTPATH/package/old/$PACKAGENAME/`date +%Y-%m-%d-%H`/
	#mv $TCTPATH/package/install/$PACKAGENAME $TCTPATH/package/old/$PACKAGENAME/`date +%Y-%m-%d-%H`/
        #echo "Extract successfully,start to install system..."
#	sleep 2
#}
#部署tomcat,redis,jdk
install(){
#mkdir $TCTPATH/package/backup/$TOMCATVERSION/`date +%Y-%m-%d-%H`/
case $INSTALLOPTION in

	tomcat)
		cd $TCTPATH/package/install/
		echo "Start to install tomcat,please waiting"
		#\cp -a ./package/install/tomcat8.zip $INSTALLPATH
        	#mv $TCTPATH/package/install/* $TCTPATH/package/backup/$TOMCATVERSION/`date +%Y-%m-%d-%H`/
        	unzip -d $INSTALLPATH `ls $TCTPATH/package/install/ | grep -i tomcat` >>$TCTPATH/logs/install-`date +%Y-%m-%d`.log
		echo "Tomcat installed successfully!!!";;
	redis)
		cd $TCTPATH/package/install/
		echo "Start to install redis,please waiting"
	 	#\cp -a ./package/install/redis.zip $INSTALLPATH
        	unzip -d $INSTALLPATH `ls $TCTPATH/package/install/ | grep -i redis` >>$TCTPATH/logs/install-`date +%Y-%m-%d`.log
        	#$INSTALLPATH/redis/bin/redis-server  $INSTALLPATH/redis/conf/6379.conf
		echo "Redis installed successfully!!!";;
	jdkinstall)
		cd $TCTPATH/package/install/
		echo "Start to install jdk,please waiting"
		#\cp -a ./package/install/jdk1.8.0_131.zip $INSTALLPATH
        	unzip -d $INSTALLPATH `ls $TCTPATH/package/install/ | grep -i jdk` >>$TCTPATH/logs/install-`date +%Y-%m-%d`.log
               	echo "JDK installed successfully!!!";;
	full)
		cd $TCTPATH/package/install/
		echo "Start to fullinstall,please waiting"
        	#\cp -a ./package/install/* $INSTALLPATH
        	#unzip `ls $INSTALLPATH/*`
        	unzip -d $INSTALLPATH $TCTPATH/package/install/tomcat8.zip >>$TCTPATH/logs/install-`date +%Y-%m-%d`.log
		unzip -d $INSTALLPATH $TCTPATH/package/install/redis.zip >>$TCTPATH/logs/install-`date +%Y-%m-%d`.log
		#$INSTALLPATH/redis/bin/redis-server  $INSTALLPATH/redis/conf/6379.conf
		unzip -d $INSTALLPATH $TCTPATH/package/install/jdk1.8.0_131.zip >>$TCTPATH/logs/install-`date +%Y-%m-%d`.log
		#cat "export JAVA_HOME=$INSTALLPATH/jdk1.8.0_131" >> $INSTALLPATH/tomcat8/bin/catalina.out
        	#cat "export JRE_HOME=$INSTALLPATH/jdk1.8.0_131/jre" >> $INSTALLPATH/tomcat8/bin/catalina.out
        	#cat ""JAVA_OPTS="-Xms2048m -Xmx2048m -XX:PermSize=512M -XX:MaxNewSize=1024m -XX:MaxPermSize=512m  -Djava.awt.headless=true  -noverify -Dfastjson.parser.safeMode=true" >> $INSTALLPATH/tomcat8/bin/catalina.out
        	echo "System installed successfully!!!";;
esac
}

CONFIGURE(){

	case $CONFIGURATION in
	
		b)
			backup
                	echo "exiting..."
                	sleep 1;;
        	tb)
                	testbackup
                	echo "exiting..."
                	sleep 1;;
        	r)
                	tctrestart;;
        	u)
                	backup
                	update;;
        	tu)
                	update;;
        	sh)
			tctshut;;
		st)
			tctstart;;
		l)
                	tail -1000f $TOMCATPATH/logs/catalina.out;;
		i)
			install;;
	esac
}

if [ $MODE = PRO ];then
	TOMCATVERSION=$2;
    	TOMCATPATH=`cat $TCTPATH/conf/tct.conf | grep $TOMCATVERSION | awk -F':' '{ print $2 }'`;
	ROOTPATH=`cat $TCTPATH/conf/tct.conf | grep $TOMCATVERSION | awk -F':' '{ print $3 }'`;
	CONFIGURE;
else
	CONFIGURE;		
fi
