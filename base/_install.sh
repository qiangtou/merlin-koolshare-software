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

find /tmp/${app} -type f>/koolshare/res/installFile_${app}.txt


rm -rf /tmp/${app}* >/dev/null 2>&1

chmod -R a+x /koolshare/bin/