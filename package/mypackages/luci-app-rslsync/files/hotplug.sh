#!/bin/sh
. /lib/functions.sh

start_rslsync(){
	#uci set rslsync.config.enable="1"
	uci set rslsync.config.device="$device"
	uci commit rslsync
	if (pidof rslsync > /dev/null); then
		/etc/init.d/rslsync restart
	else
		/etc/init.d/rslsync start
	fi
}

stop_rslsync(){
	#uci set rslsync.config.enable="0"
	uci set rslsync.config.device=""
	uci commit rslsync
	/etc/init.d/rslsync stop
}

device=`basename $DEVPATH`

case "$ACTION" in
	add)
	
       case "$device" in
                sd*) ;;
                md*) ;;
                hd*);;     
                mmcblk*);;  
                *) return;;
        esac   
        
	mountpoint=`sed -ne "s|^[^ ]*/$device ||; T; s/ .*//p" /proc/self/mounts`
	have_path=$(cat /etc/rslsync.conf | grep -c "$mountpoint")
	[ "$have_path" -gt "0" ] && start_rslsync
	;;
	remove)
	have_device=$(uci show rslsync | grep -c "$device")
	[ "$have_device" -gt "0" ] && stop_rslsync
	;;
esac
