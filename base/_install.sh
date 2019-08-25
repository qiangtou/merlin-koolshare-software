#!/bin/sh

app=$1
bin=$2

echo install ${app}

>/koolshare/installFile_${app}.txt

echo 安装文件清单:

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
		echo ${targetFile}|tee -a /koolshare/installFile_${app}.txt	
	fi
	#创建目录
	if [ -d ${file} ];then
		mkdir -p ${targetFile}
		echo ${targetFile}|tee -a /koolshare/installFile_${app}.txt	
	fi
done

#将卸载脚本添加到/koolshare/scripts/
cp /tmp/${app}/uninstall.sh /koolshare/scripts/uninstall_${app}.sh
if [ -f /koolshare/scripts/uninstall_${app}.sh ];then
	echo /koolshare/scripts/uninstall_${app}.sh|tee -a /koolshare/installFile_${app}.txt
fi
#将脚本添加到启动项
if [ -f /koolshare/scripts/${app}.sh ];then
	rm -rf /koolshare/init.d/S${app}.sh
	ln -s /koolshare/scripts/${app}.sh /koolshare/init.d/S${app}.sh
	
	if [ -f /koolshare/init.d/S${app}.sh ];then
		echo /koolshare/init.d/S${app}.sh|tee -a /koolshare/installFile_${app}.txt
	fi
	
	echo now start app [${app}]...
	sh -x /koolshare/scripts/${app}.sh start
fi

rm -rf /tmp/${app}* >/dev/null 2>&1

chmod -R a+x /koolshare/bin/