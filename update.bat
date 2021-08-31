:scp -r -P 2015 .\package xbrl@192.168.18.243:/home/xbrl/install
:putty -P 2015 xbrl@192.168.18.243 -pw 123456
:start
scp -r .\package\update\* root@192.168.77.3:/root/tctconfig/package/update/

rmdir /s/q  .\package\update
:mv .\package\update .\package\backup\update%date:~6,4%%date:~0,2%%date:~3,2%\
:mv .\package\update
md  .\package\update
ssh root@192.168.77.3 '/root/tctconfig/tctconfig.sh'
pause