local m, s, o

local tracker_lists = {
	"trackers_best",
	"trackers_best_ip",
	"trackers_all",
	"trackers_all_ip",
	"trackers_all_udp",
	"trackers_all_http",
	"trackers_all_https",
	"trackers_all_ws",
}

m=Map("tracker-rss", translate("Tracker RSS"), translate("A shell script which add trackers for Aria2/Transmission."))
s=m:section(TypedSection, "global", translate("Basic Setting"))
s.anonymous = true

o=s:option(Flag, "enabled", translate("Enable"))
o.default=0
o.rmempty=false

o=s:option( ListValue, "time_update", translate("Auto Update"))
for s=0,23 do
	o:value(s,translate("每天"..s.."点"))
end
o.default=0
o.rmempty=false

o=s:option(Button, "update", translate("Manually force update<br />Tracker List"))
o.inputtitle=translate("Update manually")
o.inputstyle="reload"
o.write=function()
	luci.sys.call("/usr/share/tracker-rss/trackerupdate 2>&1 >/dev/null")
	luci.http.redirect(luci.dispatcher.build_url("admin","services","tracker-rss"))
end

s=m:section(TypedSection, "rss_lists", translate("RSS Setting Lists"))
s.anonymous=true
s.addremove=false
s.sortable=true
s.template="cbi/tblsection"

o=s:option(ListValue, "name", translate("Application Name"))
o:value("aria2")
o:value("transmission")
o.addremove=false
o.anonymous=true

o=s:option(Flag, "enabled", translate("Enable"))
o.default=0
o.rmempty=false

o=s:option(ListValue, "tracker_lists", translate("Tracker Lists"))
o.default="trackers_best"
o.rmempty=false
for k,v in ipairs(tracker_lists) do 
	o:value(k-1,translate(v))
end

o=s:option(DummyValue, "time", translate("Update Time"))

return m
