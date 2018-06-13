wget https://raw.githubusercontent.com/cokebar/gfwlist2dnsmasq/master/gfwlist2dnsmasq.sh -O files/root/usr/sbin/gfwlist2dnsmasq.sh
wget https://raw.githubusercontent.com/cokebar/openwrt-scripts/master/generate_dnsmasq_chinalist.sh -O files/root/usr/sbin/generate_dnsmasq_chinalist.sh
cp files/root/usr/sbin/gfwlist2dnsmasq.sh ./
chmod +x gfwlist2dnsmasq.sh
