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

rm -rf /tmp/${app}* >/dev/null 2>&1

chmod -R a+x /koolshare/bin/