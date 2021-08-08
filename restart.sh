#!/bin/bash
#
echo "restarting..."
#关闭对应的tomcat
/opt/webserver/Tomcat-8.5.63/bin/shutdown.sh &>/dev/null
#等待5s
sleep 5
#判断tomcat是否正常关闭，未正常关闭的话直接kill掉
ps -ef | grep Tomcat |grep -v grep | awk '{print $2}' | xargs kill -9 &>/dev/null
echo "restart successfully,starting..." 
#启动tomcat
/opt/webserver/Tomcat-8.5.63/bin/startup.sh &>/dev/null
#sleep 30
#判断tomcat是否正常启动
tail -f /opt/webserver/Tomcat-8.5.63/logs/catalina.out | grep error
tail -f /opt/webserver/Tomcat-8.5.63/logs/catalina.out | grep org.apache.catalina.startup.Catalina.start
#echo "Congrarulations! Start successfully!"
#echo "exiting..."
#sleep 2
#exit

