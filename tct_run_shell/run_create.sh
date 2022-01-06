#bin/bash

VERSION=2.6.3
#更新程序，将其加载到run文件
zip -r tctconfig.zip tctconfig
cat tct_run.sh tctconfig.zip > tctconfig-$VERSION.run
rm -rf tctconfig.zip
