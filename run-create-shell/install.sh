#!/bin/bash
#
LINE=13
tail -n +$LINE $0 >/tmp/tctconfig.zip
unzip /tmp/tctconfig.zip -d /usr/local
\cp /usr/local/tctconfig/bin/* /usr/bin/
\cp /usr/local/tctconfig/conf/tct.conf /etc/
echo "PACKAGE_PATH=$HOME/tctconfig" >> /etc/tct.conf
chmod +x -R /usr/bin/
mkdir -pv $HOME/tctconfig
\cp -a /usr/local/tctconfig/package $HOME/tctconfig
exit 0
