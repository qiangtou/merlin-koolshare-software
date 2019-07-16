#!/bin/sh

app=$1
bin=$2

echo install ${app}

if [ ! -d /koolshare/${app} ]; then
   mkdir -p /koolshare/${app}
else
   rm -rf /koolshare/${app}
fi

mycp(){
	myPath=$1
	myDir=$(basename ${myPath})
	if [ -d $myPath ];then
		if [ $(ls ${myPath}|wc -l) -ne 0 ];then
			cp -rf ${myPath}/* /koolshare/${myDir}/
		else
			echo ${myPath}/ is empty!!
		fi
	else
		echo warnning:${myPath} is not exist!!
	fi
}
mycp /tmp/${app}/scripts
mycp /tmp/${app}/webs
mycp /tmp/${app}/res
mycp /tmp/${app}/bin

find /tmp/${app}/|grep -v install.sh$|sed "s#^/tmp/${app}/#/koolshare/#g" >/koolshare/installFile_${app}.txt
installfiles=$(cat /koolshare/installFile_${app}.txt)
>/koolshare/installFile_${app}.txt
echo 安装文件清单:
for line in $installfiles
do
	if [ -f ${line} ];then
		echo ${line}|tee -a /koolshare/installFile_${app}.txt
	fi
done

rm -rf /tmp/${app}* >/dev/null 2>&1

chmod -R a+x /koolshare/bin/