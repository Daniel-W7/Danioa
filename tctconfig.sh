#!/bin/bash
#
#Name:tctconfig
#Version:2.1
#Auther：Daniel
#Date&Time：2021年9月14日
#Discription：实现通过脚本自动备份，重启，更新tomcat系统
#定义Tomcat的安装目录，需要根据自己的部署位置调整
#配置多线程处理，避免因为脚本的退出导致tomcat自动退出的情况
set -m
#获取运行的程序名
PRONAME=`basename $0`
#获取文件运行的当前目录
TCTPATH=$(cd "$(dirname "$0")"; pwd)
#定义程序的运行模式，单用户模式或者多用户模式
PROGRAM_MODE=`cat $TCTPATH/conf/tct.conf | grep PROGRAM_MODE | awk -F'=' '{ print $2 }'`
#配置选项，如果没有输入选项直接进入提示页面
case $1 in
	-b|--backup)
		CONFIGURATION=b
		CONFIG_MODE=PRO;;
	-tb|--testbackup)
		CONFIGURATION=tb
		CONFIG_MODE=PRO;;
	-r|--restart)
		CONFIGURATION=r
		CONFIG_MODE=PRO;;
	-u|--update)
		CONFIGURATION=u
		CONFIG_MODE=PRO;;
	-tu|--testupdate)
                CONFIGURATION=tu
		CONFIG_MODE=PRO;;
	-tg|--tgupdate)
		CONFIGURATION=tg
		CONFIG_MODE=COMMON;;
	-sh|--shutdown)
		CONFIGURATION=sh
		CONFIG_MODE=PRO;;
	-st|--startup)
		CONFIGURATION=st
		CONFIG_MODE=PRO;;
	-l|--log)
		CONFIGURATION=l
		CONFIG_MODE=PRO;;
	-i|--install)
		CONFIGURATION=i
		echo "Hello,please choose your path to install:"
                read -p "The PATH to install:(default:/opt):" INSTALLPATH
		if [ $INSTALLPATH -n ];then
			INSTALLPATH=/opt;
		fi
		read -p "The option to install:(full|redis|tomcat|jdk,default:full):" INSTALLOPTION
		if [ $INSTALLOPTION -n ];then
			INSTALLOPTION=full;
		fi;;
	-c|--clean)
		CONFIGURATION=c;;
	-h|--help)
		echo "Usage:tctconf.sh [-b|--backup|-tb|--testbackup|-r|--restart|-u|--update|-tu|--testupdate|-sh|--shutdown|-st|--startup|-l|--log|-i|--install|-c|--clean|-h|--help] [TOMCATVERSION]"
		exit 0;;
	*)
		CONFIG_MODE=COMMON
 		if [ $PROGRAM_MODE == multi ];then
			echo "Hello,please choose your tomcat to configure(ht|gfzq|waibao|tuoguan|zx|hx|xcgf|dsq|zs|zyjj|df|qhyxh|vm):"
			echo "Your choice(ht|gfzq|waibao|tuoguan|zx|hx|xcgf|dsq|zs|zyjj|df|qhyxh|vm):"
			read -p "Your choice:" TOMCATVERSION
		fi
		echo "Please chose your configuration:(b|backup|r|restart|u|update|l|log|c|clean|q for quit):"
		read -p "Your configuration:" CONFIGURATION
		if [ $CONFIGURATION = q ];then
			echo "exiting...";
			exit 0;
		fi
esac

#备份对应系统
backup() {
        #echo "Start to backup $TOMCATVERSION..."
        cd $TOMCATPATH/webapps/
	echo -e "\033[33mStart to backup $TOMCATPATH/webapps/$ROOTPATH\033[0m" 2>&1| tee -a  $TCTPATH/logs/tctconfig-`date +%Y-%m-%d`.log
        zip -r $ROOTPATH`date +%Y-%m-%d-%H:%M`.zip $ROOTPATH >>$TCTPATH/logs/tctconfig-`date +%Y-%m-%d`.log
	echo -e "\033[32m$TOMCATPATH/webapps/$ROOTPATH backup successfully.\033[0mThe back file is $TOMCATPATH/webapps/$ROOTPATH`date +%Y-%m-%d-%H:%M`.zip" 2>&1|tee -a $TCTPATH/logs/tctconfig-`date +%Y-%m-%d`.log
	#echo "$TOMCATVERSION backup successfully!!!"

}

#测试之前的完整备份
testbackup() {
        #echo "Start to backup $TOMCATVERSION before test..."
        cd $TOMCATPATH/webapps/
	echo -e "\033[33mStart to backup $TOMCATPATH/webapps/$ROOTPATH before test...\033[0m" 2>&1 | tee -a $TCTPATH/logs/tctconfig-`date +%Y-%m-%d`.log
        zip -r $ROOTPATH`date +%Y-%m-%d-%H:%M`TB.zip $ROOTPATH >>$TCTPATH/logs/tctconfig-`date +%Y-%m-%d`.log
	echo -e "\033[32m$TOMCATPATH/webapps/$ROOTPATH backup before test successfully.\033[0mThe back file is $TOMCATPATH/webapps/$ROOTPATH`date +%Y-%m-%d-%H:%M`TB.zip" 2>&1 | tee -a $TCTPATH/logs/tctconfig-`date +%Y-%m-%d`.log
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
	$TOMCATPATH/bin/startup.sh >>$TCTPATH/logs/tctconfig-`date +%Y-%m-%d`.log
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
	mkdir -p $TCTPATH/package/backup/$TOMCATVERSION/`date +%Y-%m-%d-%H:%M`/
        mv $TCTPATH/package/update/* $TCTPATH/package/backup/$TOMCATVERSION/`date +%Y-%m-%d-%H:%M`/ 2>&1| tee -a $TCTPATH/logs/tctconfig-`date +%Y-%m-%d`.log
	sleep 3
	#echo "$TOMCATVERSION is updated successfully!"
	echo -e "\033[34m$TOMCATPATH/webapps/$ROOTPATH update successfully\033[0m" 2>&1| tee -a $TCTPATH/logs/tctconfig-`date +%Y-%m-%d`.log
        #重启tomcat
        echo "Start to restart $TOMCATPATH/webapps/$ROOTPATH..." 2>&1| tee -a $TCTPATH/logs/tctconfig-`date +%Y-%m-%d`.log
	sleep 2
tctrestart
}
#配置同时更新多个tomcat
tgupdate(){
#备份对应系统
$TCTPATH/tctconfig.sh -b zs
$TCTPATH/tctconfig.sh -b zyjj
#同时更新两个对应系统
if [ -z "`ls -A $TCTPATH/package/update`" ];then
        echo -e "\033[31merror\033[0m,Update files don't exist,Please put it in $TCTPATH/package/update/";
        exit 4
else
        echo -e "\033[34mStart to update tg\033[0m" 2>&1| tee -a $TCTPATH/logs/tctconfig-`date +%Y-%m-%d`.log;
        sleep 2;
        \cp -a $TCTPATH/package/update/* /opt/webserver/tomcat8-zsfusion/webapps/zs 2>&1| tee -a $TCTPATH/logs/tctconfig-`date +%Y-%m-%d`.log;
        \cp -a $TCTPATH/package/update/* /opt/webserver/tomcat8-zyjjfusion/webapps/zyjj 2>&1| tee -a $TCTPATH/logs/tctconfig-`date +%Y-%m-%d`.log;
fi
#删除本次更新文件
mkdir -p $TCTPATH/package/backup/$TOMCATVERSION/`date +%Y-%m-%d-%H:%M`/
mv $TCTPATH/package/update/* $TCTPATH/package/backup/$TOMCATVERSION/`date +%Y-%m-%d-%H:%M`/ 2>&1| tee -a $TCTPATH/logs/tctconfig-`date +%Y-%m-%d`.log
sleep 3
#echo "$TOMCATVERSION is updated successfully!"
echo -e "\033[34mtg update successfully\033[0m" 2>&1| tee -a $TCTPATH/logs/tctconfig-`date +%Y-%m-%d`.log
#重启tomcat
echo "Start to restart tg" 2>&1| tee -a $TCTPATH/logs/tctconfig-`date +%Y-%m-%d`.log
$TCTPATH/tctconfig.sh -r zs
$TCTPATH/tctconfig.sh -r zyjj
}
#清理参与进程,日志及备份文件
clean(){
	#ps -ef | grep tctconfig.sh | grep -v grep | awk '{print $2}' | sed -e "s/^/kill -9 /g" | sh - &>/dev.null
	read -p "Do you want to clean the logs in $TCTPATH/logs?(y for yes/n for no)" CLOG
	case $CLOG in
        	y)
                	rm -rf $TCTPATH/logs/*
                	echo "Clean logs successfully";;
        	n)
                	echo "Done nothing";;
	esac
	read -p "Do you want to clean the backups in $TCTPATH/package/backup?(y for yes/n for no)" CBAK
	case $CBAK in
        	y)
                	rm -rf $TCTPATH/package/backup/*
                	echo "Clean backup successfully";;
        	n)
                	echo "Done nothing";;
	esac
	echo "Clean complete,exiting..."
	sleep 1
	ps -ef | grep tctconfig.sh | grep -v grep | awk '{print $2}' | sed -e "s/^/kill -15 /g" | sh - &>/dev.null
}
#安装部署解压
#部署tomcat,redis,jdk
tctinstall(){
	echo -e "\033[33mStart to install tomcat,the INSTALLPATH is $INSTALLPATH,please waiting\033[0m" 2>&1| tee -a $TCTPATH/logs/tctconfig-`date +%Y-%m-%d`.log
	#判断目的地址是否存在相同的应用
       	if [ -e $INSTALLPATH/tomcat8 ];then
		read -p "There is a tomcat8 in $INSTALLPATH,dou you want to remove it?(y/n)" TCTOPTION 
		case $TCTOPTION in
			y)
				#cd $INSTALLPATH
				mkdir -p $TCTPATH/package/backup/$INSTALLOPTION/`date +%Y-%m-%d-%H:%M`/
				mv $INSTALLPATH/tomcat8 $TCTPATH/package/backup/$INSTALLOPTION-`date +%Y-%m-%d-%H:%M`/
				echo "The old $INSTALLOPTION have been moved to $TCTPATH/package/backup/$INSTALLOPTION-`date +%Y-%m-%d-%H:%M`/" 2>&1| tee -a $TCTPATH/logs/tctconfig-`date +%Y-%m-%d`.log
				echo "start to install a new $INSTALLOPTION,please waiting..." 2>&1| tee -a $TCTPATH/logs/tctconfig-`date +%Y-%m-%d`.log;;
			n)
				echo "You choosed no,we have done noting,exiting" 2>&1| tee -a $TCTPATH/logs/tctconfig-`date +%Y-%m-%d`.log

				exit 1;;
		esac
	fi
	cd $TCTPATH/package/install/
	unzip -d $INSTALLPATH `ls $TCTPATH/package/install/ | grep -i tomcat` >> $TCTPATH/logs/tctconfig-`date +%Y-%m-%d`.log
	echo -e "\033[34mTomcat installed successfully!!!\033[0m" 2>&1| tee -a $TCTPATH/logs/tctconfig-`date +%Y-%m-%d`.log
}
redisinstall(){
	#判断目的地址是否存在相同的应用
        if [ -e $INSTALLPATH/redis ];then
                read -p "There is a redis in $INSTALLPATH,dou you want to remove it?(y/n)" TCTOPTION
                case $TCTOPTION in
                        y)
                                #cd $INSTALLPATH
                                mkdir -p $TCTPATH/package/backup/$INSTALLOPTION/`date +%Y-%m-%d-%H:%M`/
                                mv $INSTALLPATH/redis $TCTPATH/package/backup/$INSTALLOPTION-`date +%Y-%m-%d-%H:%M`/
                                echo "The old $INSTALLOPTION have been moved to $TCTPATH/package/backup/$INSTALLOPTION-`date +%Y-%m-%d-%H:%M`/" 2>&1| tee -a $TCTPATH/logs/tctconfig-`date +%Y-%m-%d`.log
                                echo "start to install a new $INSTALLOPTION,please waiting..." 2>&1| tee -a $TCTPATH/logs/tctconfig-`date +%Y-%m-%d`.log;;
                        n)
                                echo "You choosed no,we have done noting,exiting" 2>&1| tee -a $TCTPATH/logs/tctconfig-`date +%Y-%m-%d`.log

                                exit 2;;
                esac
        fi
	cd $TCTPATH/package/install/
	echo -e "\033[33mStart to install redis,the INSTALLPATH is $INSTALLPATH,please waiting\033[0m" 2>&1| tee -a $TCTPATH/logs/tctconfig-`date +%Y-%m-%d`.log
 	#\cp -a ./package/install/redis.zip $INSTALLPATH
       	unzip -d $INSTALLPATH `ls $TCTPATH/package/install/ | grep -i redis` >> $TCTPATH/logs/tctconfig-`date +%Y-%m-%d`.log
       	#$INSTALLPATH/redis/bin/redis-server  $INSTALLPATH/redis/conf/6379.conf
	echo -e "\033[34mRedis installed successfully!!!\033[0m" 2>&1| tee -a $TCTPATH/logs/tctconfig-`date +%Y-%m-%d`.log
}
jdkinstall(){
	#判断目的地址是否存在相同的应用
        if [ -e $INSTALLPATH/jdk1.8.0_131 ];then
                read -p "There is a jdk1.8.0_131 in $INSTALLPATH,dou you want to remove it?(y/n)" TCTOPTION
                case $TCTOPTION in
                        y)
                                #cd $INSTALLPATH
                                mkdir -p $TCTPATH/package/backup/$INSTALLOPTION-`date +%Y-%m-%d-%H:%M`/
                                mv $INSTALLPATH/jdk1.8.0_131 $TCTPATH/package/backup/$INSTALLOPTION-`date +%Y-%m-%d-%H:%M`/
                                echo "The old $INSTALLOPTION have been moved to $TCTPATH/package/backup/$INSTALLOPTION-`date +%Y-%m-%d-%H:%M`/" 2>&1| tee -a $TCTPATH/logs/tctconfig-`date +%Y-%m-%d`.log
                                echo "start to install a new $INSTALLOPTION,please waiting..." 2>&1| tee -a $TCTPATH/logs/tctconfig-`date +%Y-%m-%d`.log;;
                        n)
                                echo "You choosed no,we have done noting,exiting" 2>&1| tee -a $TCTPATH/logs/tctconfig-`date +%Y-%m-%d`.log
                                exit 3;;
                esac
        fi
	cd $TCTPATH/package/install/
	echo -e "\033[33mStart to install jdk,the INSTALLPATH is $INSTALLPATH,please waiting\033[0m" 2>&1| tee -a $TCTPATH/logs/tctconfig-`date +%Y-%m-%d`.log
	#\cp -a ./package/install/jdk1.8.0_131.zip $INSTALLPATH
       	unzip -d $INSTALLPATH `ls $TCTPATH/package/install/ | grep -i jdk` >> $TCTPATH/logs/tctconfig-`date +%Y-%m-%d`.log
	echo -e "\033[34mJDK installed successfully!!!\033[0m" 2>&1| tee -a $TCTPATH/logs/tctconfig-`date +%Y-%m-%d`.log
}
		#cat "export JAVA_HOME=$INSTALLPATH/jdk1.8.0_131" >> $INSTALLPATH/tomcat8/bin/catalina.out
        	#cat "export JRE_HOME=$INSTALLPATH/jdk1.8.0_131/jre" >> $INSTALLPATH/tomcat8/bin/catalina.out
        	#cat ""JAVA_OPTS="-Xms2048m -Xmx2048m -XX:PermSize=512M -XX:MaxNewSize=1024m -XX:MaxPermSize=512m  -Djava.awt.headless=true  -noverify -Dfastjson.parser.safeMode=true" >> $INSTALLPATH/tomcat8/bin/catalina.out
install(){
case $INSTALLOPTION in
	tomcat)
		tctinstall;;
	redis)
		redisinstall;;
	jdk)
		jdkinstall;;
	full)
		INSTALLOPTION=tomcat
		tctinstall
		INSTALLOPTION=redis
		redisinstall
		INSTALLOPTION=jdk
		jdkinstall;;
esac
}
CONFIGURE(){
		
	case $CONFIGURATION in
	
		b)
			backup;;
        	tb)
                	testbackup;;
        	r)
                	tctrestart;;
        	u)
                	backup
			if [ -z "`ls -A $TCTPATH/package/update`" ];then
				echo -e "\033[31merror\033[0m,Update files don't exist,Please put it in $TCTPATH/package/update/";
				exit 4
			else 
				update;
			fi;;
        	tu)
                	if [ -z "`ls -A $TCTPATH/package/update`" ];then
                                echo -e "\033[31merror\033[0m,Update files don't exist,Please put it in $TCTPATH/package/update/";
                        	exit 5;
			else
                                update;
                        fi;;
        	sh)
			tctshut;;
		st)
			tctstart;;
		l)
                	tail -1000f $TOMCATPATH/logs/catalina.out;;
		i)
			install;;
		c)
			clean;;

		*)
			echo "Usage:tctconf.sh [-b|--backup|-tb|--testbackup|-r|--restart|-u|--update|-tu|--testupdate|-sh|--shutdown|-st|--startup|-l|--log|-i|--install|-c|--clean|-h|--help] [TOMCATVERSION]"
                exit 6;;		
	esac
	rm -rf $TCTPATH/tee
        rm -rf $TOMCATPATH/webapps/tee

}
#同时更新多个tomcat
if [ $CONFIGURATION == tg ];then
	tgupdate;
	exit 0
fi

if [ $CONFIG_MODE == PRO ];then
	 if [ $PROGRAM_MODE == single ];then
                TOMCATVERSION=`cat $TCTPATH/conf/tct.conf | grep SINGLE_PATH | awk -F':' '{ print $2 }'`;
                TOMCATPATH=`cat $TCTPATH/conf/tct.conf | grep SINGLE_PATH | awk -F':' '{ print $3 }'`;
                ROOTPATH=`cat $TCTPATH/conf/tct.conf | grep SINGLE_PATH | awk -F':' '{ print $4 }'`;

        else
                TOMCATVERSION=TOMCAT_$2;
		if [ -z $TOMCATVERSION ];then
                        echo "error,Please choose a system to configure";
                        exit 7;
                fi
                if [ `cat $TCTPATH/conf/tct.conf | grep $TOMCATVERSION | wc -l` -gt 1 ];then
                        echo "The $TOMCATVERSION is repetitive in $TCTPATH/conf/tct.conf,Please change its name";
                        exit 8;
                else
                        TOMCATPATH=`cat $TCTPATH/conf/tct.conf | grep $TOMCATVERSION | awk -F':' '{ print $2 }'`;
                        ROOTPATH=`cat $TCTPATH/conf/tct.conf | grep $TOMCATVERSION | awk -F':' '{ print $3 }'`;
                fi;
        fi;
	CONFIGURE;
else
	if [ $PROGRAM_MODE == single ];then
                TOMCATVERSION=`cat $TCTPATH/conf/tct.conf | grep SINGLE_PATH | awk -F':' '{ print $2 }'`;
                TOMCATPATH=`cat $TCTPATH/conf/tct.conf | grep SINGLE_PATH | awk -F':' '{ print $3 }'`;
                ROOTPATH=`cat $TCTPATH/conf/tct.conf | grep SINGLE_PATH | awk -F':' '{ print $4 }'`;
	else
	 	if [ -z $TOMCATVERSION ];then
                        echo "error,Please choose a system to configure";
                        exit 7;
         	fi; 
		TOMCATVERSION=TOMCAT_$TOMCATVERSION;
	 	if [ `cat $TCTPATH/conf/tct.conf | grep $TOMCATVERSION | wc -l` -eq 1 ];then
                	echo "The $TOMCATVERSION is wrong,please check it.";
                	exit 8;
         	else
                	TOMCATPATH=`cat $TCTPATH/conf/tct.conf | grep $TOMCATVERSION | awk -F':' '{ print $2 }'`;
                	ROOTPATH=`cat $TCTPATH/conf/tct.conf | grep $TOMCATVERSION | awk -F':' '{ print $3 }'`;
	 	fi;
	fi;
	CONFIGURE;
fi
