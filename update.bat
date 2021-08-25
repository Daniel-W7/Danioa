:scp -r -P 2015 .\package xbrl@192.168.18.243:/home/xbrl/install
:putty -P 2015 xbrl@192.168.18.243 -pw 123456
:start
scp -r .\package\update\* root@192.168.77.3:/root/tctinstall/package/update/

rmdir /s/q  .\package\update

ssh root@192.168.77.3 '/root/tctconfig/tctconfig.sh'
pause