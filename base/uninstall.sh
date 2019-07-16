#!/bin/sh
app=$(basename `dirname $0`)
echo uninstall
cat /koolshare/installFile_${app}.txt|xargs -ti rm {}
rm /koolshare/installFile_${app}.txt