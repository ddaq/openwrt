#!/bin/sh

# Below is a command that will get a list of trackers with one tracker per line
# command can be 'cat /some/path/trackers.txt' for a static list

URL="$1"
#LIVE_TRACKERS_LIST_CMD='curl -fs --url https://raw.githubusercontent.com/ngosang/trackerslist/master/trackers_best_ip.txt' 
LIVE_TRACKERS_LIST_CMD="curl -fs --url $URL" 
TRACKER_LIST=`$LIVE_TRACKERS_LIST_CMD`

if [ $? -ne 0 ] || [ -z "$TRACKER_LIST" ]; then

	TRACKER_LIST="udp://tracker.skyts.net:6969/announce
udp://tracker.safe.moe:6969/announce
udp://tracker.piratepublic.com:1337/announce
udp://tracker.pirateparty.gr:6969/announce
udp://tracker.leechers-paradise.org:6969/announce
udp://tracker.coppersurfer.tk:6969/announce
udp://allesanddro.de:1337/announce
udp://9.rarbg.com:2710/announce
http://p4p.arenabg.com:1337/announce
udp://packages.crunchbangplusplus.org:6969/announce
udp://p4p.arenabg.com:1337/announce
http://tracker.opentrackr.org:1337/announce
udp://tracker.opentrackr.org:1337/announce
udp://wambo.club:1337/announce
udp://trackerxyz.tk:1337/announce
udp://tracker4.itzmx.com:2710/announce
udp://tracker2.christianbro.pw:6969/announce
udp://tracker1.xku.tv:6969/announce
udp://tracker1.wasabii.com.tw:6969/announce
udp://tracker.zer0day.to:1337/announce"

fi

ARIA2_TRACKERS=$(
echo "$TRACKER_LIST" | while read TRACKER
do
	if [ ! -z "$TRACKER" ]; then
		echo -n "${TRACKER},"
	fi
done)

uci delete aria2.main.bt_tracker
uci add_list aria2.main.bt_tracker="$ARIA2_TRACKERS"
uci commit aria2
