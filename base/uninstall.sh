#!/bin/sh
app=$(basename `dirname $0`)
echo uninstall
cat /koolshare/res/installFile_${app}.txt|xargs -ti rm {}
rm /koolshare/res/installFile_${app}.txt