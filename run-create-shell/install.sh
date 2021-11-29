#!/bin/bash
#
LINE=28
#配置tctconfig-xx.run以software模式或者是script模式来安装
case $1 in
	-sw|--software)
		tail -n +$LINE $0 >/tmp/tctconfig.zip
		unzip /tmp/tctconfig.zip -d /usr/local
		sed -i s/INSTALL_OPTION=/INSTALL_OPTION=software/g /usr/local/tctconfig/bin/*
		\cp /usr/local/tctconfig/bin/* /usr/bin/
		\cp /usr/local/tctconfig/conf/tct.conf /etc/
		chmod +x -R /usr/bin/
		mkdir -pv $HOME/tctconfig
		\cp -a /usr/local/tctconfig/package $HOME/tctconfig
		rm -rf $HOME/tctconfig/package/update/*
		echo "tctconfig is installed successfully!";;
	-sc|--script)
		tail -n +$LINE $0 >/tmp/tctconfig.zip
                unzip /tmp/tctconfig.zip -d $HOME
		echo PATH='$PATH':$HOME/tctconfig/bin >> $HOME/.bashrc
                chmod +x -R $HOME/tctconfig/bin
                rm -rf $HOME/tctconfig/package/update/*
                sed -i s/INSTALL_OPTION=/INSTALL_OPTION=script/g $HOME/tctconfig/bin/*
		echo "tctconfig is installed successfully,please relogin!";;
	     *)
		echo "Usage:bash tctconfig-xx.run -sw|--software|-sc|--script";;
esac
exit 0
