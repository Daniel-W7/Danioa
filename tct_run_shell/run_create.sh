#bin/bash

VERSION=2.6.3
#更新程序，将其部署到run文件
zip -r tctconfig.zip tctconfig
cat tct_run.sh tctconfig.zip > tctconfig-$VERSION.run
#更新程序内部的run文件
cp tctconfig-$VERSION.run tctconfig
zip -r tctconfig.zip tctconfig
cat tct_run.sh tctconfig.zip > tctconfig-$VERSION.run

