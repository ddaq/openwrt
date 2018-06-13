#!/bin/sh

wget http://ftp.apnic.net/apnic/stats/apnic/delegated-apnic-latest -O- | awk -F\| '/CN\|ipv4/ { printf("%s/%d\n", $4, 32-log($5)/log(2)) }' > files/root/etc/chnroute.list
