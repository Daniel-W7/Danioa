:scp -r -P 2015 .\package xbrl@192.168.18.243:/home/xbrl/install
:putty -P 2015 xbrl@192.168.18.243 -pw 123456
:start
scp -r .\package\upload\* root@192.168.77.3:/root/tomcat-install/package/upload/
ssh root@192.168.77.3 'cd /root/tomcat-install/;./update.sh'
pause