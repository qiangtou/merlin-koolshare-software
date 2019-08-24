plugin=$(basename $0 .sh)
action=$1
case "$action" in
    start)
         /koolshare/bin/vhusbdarm -b
		 if [ $? -eq 0 ]; then
			logger ${plugin} is start ok!!
			else 
			logger ${plugin} is start fail!!
		 fi
        ;;
    *)
        logger not support action $action !!
        ;;
esac