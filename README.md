# tomcat-install

tomcat自动重启配置脚本，之后会试着加上一些系统配置相关的内容

# v1.3

update.sh里面添加目录切换命令，直接切换到此程序根目录，可直接调用根目录shell脚本
update.sh输出内容调整，以适应Windows1界面的显示
update.bat添加清理本地upload文件夹下内容的功能，避免重复更新，并添加登录linux系统之后直接执行update.sh的功能，可实现自动更新

# v1.2

添加backup.sh,用于备份之前的系统文件，可重复备份

添加update.sh,用于更新，更新之前进行对应安装目录的备份

添加update.bat,用于Windows向linux自动上传更新补丁，补丁位置./package/upload/

添加clean.sh,用于清理可能遗留的shell进程

restart.sh里面添加set -m命令，用于分线程进行脚本执行，避免出现shell脚本关闭，tomcat也被一并关闭的情况

修改tomcat-restart为tomcat-install

调整了一下版本发布方式

# v1.1

加上选项功能，可以进行多个tomcat的管理

# v1.0

重启脚本基础版，仅添加重启单个tomcat功能
