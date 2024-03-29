#!/bin/sh

app=$1
bin=$2

echo install ${app}

echo 安装文件清单:

# 卸载脚本复制
cp /tmp/${app}/uninstall.sh /koolshare/scripts/uninstall_${app}.sh
echo "sh /koolshare/scripts/${app}.sh stop">>/koolshare/scripts/uninstall_${app}.sh

#排除安装,卸载脚本,列出所有文件
for file in $(find /tmp/${app}/|grep -v install.sh$)
do
	#将源文件前缀"/tmp/插件名/"替换成"/koolshare/",得到目标文件路径
	targetFile=$(echo ${file}|sed "s#^/tmp/${app}/#/koolshare/#g")	
	#复制文件
	if [ -f ${file} ];then
		targetFileDir=$(dirname ${targetFile})
		if [ ! -d ${targetFileDir} ];then
			mkdir -p ${targetFileDir}
		fi	
		cp ${file} ${targetFile}
		echo ${targetFile}
		echo rm -f ${targetFile}>>/koolshare/scripts/uninstall_${app}.sh
	fi
	#创建目录
	if [ -d ${file} ];then
		mkdir -p ${targetFile}	
	fi
done



#将脚本添加到启动项
if [ -f /koolshare/scripts/${app}.sh ];then
	rm -rf /koolshare/init.d/S${app}.sh
	ln -s /koolshare/scripts/${app}.sh /koolshare/init.d/S${app}.sh
	echo /koolshare/init.d/S${app}.sh
	echo rm -f /koolshare/init.d/S${app}.sh>>/koolshare/scripts/uninstall_${app}.sh	
	echo now start app [${app}]...
	sh /koolshare/scripts/${app}.sh start
	echo now start app [${app}] ok...
fi

# 卸载时删除自己
echo rm -f /koolshare/scripts/uninstall_${app}.sh>>/koolshare/scripts/uninstall_${app}.sh

rm -rf /tmp/${app}* >/dev/null 2>&1

chmod -R a+x /koolshare/bin/