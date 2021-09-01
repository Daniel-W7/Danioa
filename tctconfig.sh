#!/bin/bash
#
#Name:tctconfig
#Version:1.8
#Auther：Daniel
#Date&Time：2021年9月1日
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
        #echo "Start to backup $TOMCATVERSION..."
        cd $TOMCATPATH/webapps/
	echo -e "\033[33mStart to backup $TOMCATPATH/webapps/$ROOTPATH\033[0m" 2>&1| tee -a  $TCTPATH/logs/tctconfig-`date +%Y-%m-%d`.log
        zip -r $ROOTPATH`date +%Y-%m-%d-%H:%M:%S`.zip $ROOTPATH >>$TCTPATH/logs/tctconfig-`date +%Y-%m-%d`.log
	echo -e "\033[32m$TOMCATPATH/webapps/$ROOTPATH backup successfully.The back file is $TOMCATPATH/webapps/$ROOTPATH`date +%Y-%m-%d-%H:%M:%S`.zip\033[0m" 2>&1|tee -a $TCTPATH/logs/tctconfig-`date +%Y-%m-%d`.log
	#echo "$TOMCATVERSION backup successfully!!!"

}

#测试之前的完整备份
testbackup() {
        #echo "Start to backup $TOMCATVERSION before test..."
        cd $TOMCATPATH/webapps/
	echo -e "\033[33mStart to backup $TOMCATPATH/webapps/$ROOTPATH before test...\033[0m" 2>&1 | tee -a $TCTPATH/logs/tctconfig-`date +%Y-%m-%d`.log
        zip -r $ROOTPATH`date +%Y-%m-%d-%H:%M:%S`TB.zip $ROOTPATH >>$TCTPATH/logs/tctconfig-`date +%Y-%m-%d`.log
	echo -e "\033[32m$TOMCATPATH/webapps/$ROOTPATH backup before test successfully.The back file is $TOMCATPATH/webapps/$ROOTPATH`date +%Y-%m-%d-%H:%M:%S`TB.zip\033[0m" 2>&1 | tee -a $TCTPATH/logs/tctconfig-`date +%Y-%m-%d`.log
	#echo "$TOMCATVERSION backup before test successfully!!!"
}
#关闭对应tomcat
tctshut(){
	#echo "Start to shutdown $TOMCATVERSION..."
        #关闭对应的tomcat
        #echo "$TOMCATVERSION is shuting..."
	echo -e "\033[36mStart to shut $TOMCATPATH/webapps/$ROOTPATH\033[0m" 2>&1| tee -a $TCTPATH/logs/tctconfig-`date +%Y-%m-%d`.log
	$TOMCATPATH/bin/shutdown.sh &>$TCTPATH/logs/tctconfig-`date +%Y-%m-%d`.log
        ps -ef | grep $TOMCATPATH | grep -v grep | awk '{print $2}' | sed -e "s/^/kill -9 /g" | sh -
	echo -e "\033[33m$TOMCATPATH/webapps/$ROOTPATH is shutted successfully\033[0m" 2>&1|tee -a $TCTPATH/logs/tctconfig-`date +%Y-%m-%d`.log
	#echo "$TOMCATVERSION is shutted successfully..."
	sleep 1
}
#开启对应tomcat
tctstart(){
 	#启动tomcat,并查看对应日志
        #echo "$TOMCATVERSION is starting..." 
        #sleep 1
	echo -e "\033[32mStarting $TOMCATPATH/webapps/$ROOTPATH ...\033[0m" 2>&1| tee -a $TCTPATH/logs/tctconfig-`date +%Y-%m-%d`.log
	$TOMCATPATH/bin/startup.sh >>tee -a $TCTPATH/logs/tctconfig-`date +%Y-%m-%d`.log
	#echo -e "\033[31m$TOMCATPATH/webapps/$ROOTPATH start successfully\033[0m" 2>&1| tee -a $TCTPATH/logs/tctconfig-`date +%Y-%m-%d`.log
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
        #echo "Start to update $TOMCATVERSION..."
	echo -e "\033[34mStart to update $TOMCATPATH/webapps/$ROOTPATH\033[0m" 2>&1| tee -a $TCTPATH/logs/tctconfig-`date +%Y-%m-%d`.log
        #sleep 2
        \cp -a $TCTPATH/package/update/* $TOMCATPATH/webapps/$ROOTPATH 2>&1| tee -a $TCTPATH/logs/tctconfig-`date +%Y-%m-%d`.log
        #删除本次更新文件
	mkdir -p $TCTPATH/package/backup/$TOMCATVERSION/`date +%Y-%m-%d-%H:%M:%S`/
        mv $TCTPATH/package/update/* $TCTPATH/package/backup/$TOMCATVERSION/`date +%Y-%m-%d-%H:%M:%S`/ 2>&1| tee -a $TCTPATH/logs/tctconfig-`date +%Y-%m-%d`.log
	sleep 3
	#echo "$TOMCATVERSION is updated successfully!"
	echo -e "\033[34m$TOMCATPATH/webapps/$ROOTPATH update successfully\033[0m" 2>&1| tee -a $TCTPATH/logs/tctconfig-`date +%Y-%m-%d`.log
        #重启tomcat
        echo "Start to restart $TOMCATPATH/webapps/$ROOTPATH..." 2>&1| tee -a $TCTPATH/logs/tctconfig-`date +%Y-%m-%d`.log
	sleep 2
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
		echo -e "\033[33mStart to install tomcat,the INSTALLPATH is $INSTALLPATH,please waiting\033[0m" 2>&1| tee -a $TCTPATH/logs/tctconfig-`date +%Y-%m-%d`.log
		#\cp -a ./package/install/tomcat8.zip $INSTALLPATH
        	#mv $TCTPATH/package/install/* $TCTPATH/package/backup/$TOMCATVERSION/`date +%Y-%m-%d-%H`/
        	unzip -d $INSTALLPATH `ls $TCTPATH/package/install/ | grep -i tomcat` >> $TCTPATH/logs/tctconfig-`date +%Y-%m-%d`.log
		echo -e "\033[34mTomcat installed successfully,the INSTALLPATH is $INSTALLPATH!!!\033[0m" 2>&1| tee -a $TCTPATH/logs/tctconfig-`date +%Y-%m-%d`.log;; 
	redis)
		cd $TCTPATH/package/install/
		echo -e "\033[33mStart to install redis,the INSTALLPATH is $INSTALLPATH,please waiting\033[0m" 2>&1| tee -a $TCTPATH/logs/tctconfig-`date +%Y-%m-%d`.log
	 	#\cp -a ./package/install/redis.zip $INSTALLPATH
        	unzip -d $INSTALLPATH `ls $TCTPATH/package/install/ | grep -i redis` >> $TCTPATH/logs/tctconfig-`date +%Y-%m-%d`.log
        	#$INSTALLPATH/redis/bin/redis-server  $INSTALLPATH/redis/conf/6379.conf
		echo -e "\033[34mRedis installed successfully,the INSTALLPATH is $INSTALLPATH\033[0m" 2>&1| tee -a $TCTPATH/logs/tctconfig-`date +%Y-%m-%d`.log;;
	jdk)
		cd $TCTPATH/package/install/
		echo -e "\033[33mStart to install jdk,the INSTALLPATH is $INSTALLPATH,please waiting\033[0m" 2>&1| tee -a $TCTPATH/logs/tctconfig-`date +%Y-%m-%d`.log
		#\cp -a ./package/install/jdk1.8.0_131.zip $INSTALLPATH
        	unzip -d $INSTALLPATH `ls $TCTPATH/package/install/ | grep -i jdk` >> $TCTPATH/logs/tctconfig-`date +%Y-%m-%d`.log
               	echo -e "\033[34mJDK installed successfully!!!\033[0m" 2>&1| tee -a $TCTPATH/logs/tctconfig-`date +%Y-%m-%d`.log;;
	full)
		cd $TCTPATH/package/install/
		echo -e "\033[33mStart to fullinstall,the INSTALLPATH is $INSTALLPATH,please waiting\033[0m" 2>&1| tee -a $TCTPATH/logs/tctconfig-`date +%Y-%m-%d`.log
        	#\cp -a ./package/install/* $INSTALLPATH
        	#unzip `ls $INSTALLPATH/*`
        	unzip -d $INSTALLPATH $TCTPATH/package/install/tomcat8.zip >> $TCTPATH/logs/tctconfig-`date +%Y-%m-%d`.log
		unzip -d $INSTALLPATH $TCTPATH/package/install/redis.zip >> $TCTPATH/logs/tctconfig-`date +%Y-%m-%d`.log
		#$INSTALLPATH/redis/bin/redis-server  $INSTALLPATH/redis/conf/6379.conf
		unzip -d $INSTALLPATH $TCTPATH/package/install/jdk1.8.0_131.zip >> $TCTPATH/logs/tctconfig-`date +%Y-%m-%d`.log
		#cat "export JAVA_HOME=$INSTALLPATH/jdk1.8.0_131" >> $INSTALLPATH/tomcat8/bin/catalina.out
        	#cat "export JRE_HOME=$INSTALLPATH/jdk1.8.0_131/jre" >> $INSTALLPATH/tomcat8/bin/catalina.out
        	#cat ""JAVA_OPTS="-Xms2048m -Xmx2048m -XX:PermSize=512M -XX:MaxNewSize=1024m -XX:MaxPermSize=512m  -Djava.awt.headless=true  -noverify -Dfastjson.parser.safeMode=true" >> $INSTALLPATH/tomcat8/bin/catalina.out
        	echo -e "\033[34mSystem installed successfully,the INSTALLPATH is $INSTALLPATH" 2>&1| tee -a $TCTPATH/logs/tctconfig-`date +%Y-%m-%d`.log\033[0m;;
esac
}

CONFIGURE(){

	case $CONFIGURATION in
	
		b)
			backup
                	echo "exiting..." 2>&1| tee -a $TCTPATH/logs/tctconfig-`date +%Y-%m-%d`.log
                	sleep 1;;
        	tb)
                	testbackup
                	echo "exiting..." 2>&1| tee -a $TCTPATH/logs/tctconfig-`date +%Y-%m-%d`.log
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
