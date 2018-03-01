#!/bin/sh

rm -f /usr/share/adbyby/data/*.bak

[ ! -s "/tmp/lazy.txt" ] && wget-ssl --no-check-certificate -O /tmp/lazy.txt https://raw.githubusercontent.com/adbyby/xwhyc-rules/master/lazy.txt
[ ! -s "/tmp/video.txt" ] && wget-ssl --no-check-certificate -O /tmp/video.txt https://raw.githubusercontent.com/adbyby/xwhyc-rules/master/video.txt

[ -s "/tmp/lazy.txt" ] && ( ! cmp -s /tmp/lazy.txt /usr/share/adbyby/data/lazy.txt ) && mv /tmp/lazy.txt /usr/share/adbyby/data/lazy.txt	
[ -s "/tmp/video.txt" ] && ( ! cmp -s /tmp/video.txt /usr/share/adbyby/data/video.txt ) && mv /tmp/video.txt /usr/share/adbyby/data/video.txt	
[ -s "/tmp/user.action" ] && ( ! cmp -s /tmp/user.action /usr/share/adbyby/user.action ) && mv /tmp/user.action /usr/share/adbyby/user.action	

rm -f /tmp/lazy.txt /tmp/video.txt /tmp/user.action

/etc/init.d/adbyby restart
