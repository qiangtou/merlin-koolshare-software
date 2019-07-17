#!/bin/sh
app=$(basename `dirname $0`)
echo uninstall
for file in $(cat /koolshare/installFile_${app}.txt)
do
	#路径一定要是/koolshare/前缀开头,并且不等于/koolshare/,防止整个/koolshare/被删
	if [ "$file" == "$(echo ${file}|grep ^/koolshare/.)" ];then 
		if [ -f $file ];then
			rm -f $file
		fi
		if [ -d $file ];then
			rm -rf $file
		fi
	fi
done

rm /koolshare/installFile_${app}.txt