local fs = require "nixio.fs"
local util = require "nixio.util"

local m, s, o

m = Map("domainlist", translate("Domain List"), translate("A shell script which convert gfw/china domain into dnsmasq rules."))
s = m:section(TypedSection, "domainlist", "")
s.anonymous = true

s:tab("basic", translate("Basic Setting"))

o=s:taboption("basic",Flag,"enabled",translate("Enable"))
o.default=0
o.rmempty=false

mode=s:taboption("basic",Value,"mode",translate("Mode"))
mode.default="gfwlist"
mode.rmempty=false
mode:value("gfwlist", translate("GFW Domain List"))
mode:value("chinalist", translate("China Domain List"))

o = s:taboption("basic", Value, "ip", translate("DNS地址"))
o.datatype = "ipaddr"
o.default = "8.8.4.4"
o.placeholder = "8.8.4.4"

o = s:taboption("basic", Value, "port", translate("DNS端口"))
o.datatype = "port"
o.default = 53
o.placeholder = 53

o = s:taboption("basic", Value, "ipset", translate("IP-Set Name"))
o.datatype = "string"
o.placeholder = "gfwlist/chinalist"

o = s:option(Value, "ipset_args", translate("IP-Set Arguments"),
	translate("Passes arguments to ipset. Use with care!"))
o:value("", translate("None"))
o:value("hash:ip timeout 3600")

o = s:taboption("basic", DummyValue, "gfwlist_path", translate("File Path"))
o.value = string.format("/etc/domainlist/gfwlist.conf")
o:depends({mode="gfwlist"})

o = s:taboption("basic", DummyValue, "chinalist_path", translate("File Path"))
o.value = string.format("/etc/domainlist/chinalist.conf")
o:depends({mode="chinalist"})

o = s:taboption("basic",ListValue,"time_update",translate("Auto Update"))
for s=0,23 do
	o:value(s,translate("每天"..s.."点"))
end
o.default=0
o.rmempty=false

generate=s:taboption("basic",Button,"generate",translate("Manual Update"))
generate.inputtitle=translate("Update List")
generate.inputstyle="reload"
generate.write=function()
	luci.sys.call("/usr/share/domainlist/domainlistupdate 2>&1 >/dev/null")
	luci.http.redirect(luci.dispatcher.build_url("admin","services","domainlist"))
end

s:tab("domain", translate("Extra Domain List"))

gfwlist = s:taboption("domain", Value, "gfwlist", nil, translate("User GFW Domain List File"))
gfwlist.template = "cbi/tvalue"
gfwlist.rows = 28
gfwlist.wrap = "off"
gfwlist:depends({mode="gfwlist"})
function gfwlist.cfgvalue(self, section)
	return fs.readfile("/usr/share/domainlist/user-gfwlist.txt") or ""
end
function gfwlist.write(self, section, value)
	if value then
		value = value:gsub("\r\n", "\n")
	else
		value = ""
	end
	fs.writefile("/tmp/user-gfwlist.txt", value)
	if (luci.sys.call("cmp -s /tmp/user-gfwlist.txt /usr/share/domainlist/user-gfwlist.txt") == 1) then
		fs.writefile("/usr/share/domainlist/user-gfwlist.txt", value)
	end
	fs.remove("/tmp/user-gfwlist.txt")
end

chnlist = s:taboption("domain", Value, "chinalist", nil, translate("User China Domain List File"))
chnlist.template = "cbi/tvalue"
chnlist.rows = 28
chnlist.wrap = "off"
chnlist:depends({mode="chinalist"})
function chnlist.cfgvalue(self, section)
	return fs.readfile("/usr/share/domainlist/user-chinalist.txt") or ""
end
function chnlist.write(self, section, value)
	if value then
		value = value:gsub("\r\n", "\n")
	else
		value = ""
	end
	fs.writefile("/tmp/user-chinalist.txt", value)
	if (luci.sys.call("cmp -s /tmp/user-chinalist.txt /usr/share/domainlist/user-chinalist.txt") == 1) then
		fs.writefile("/usr/share/domainlist/user-chinalist.txt", value)
	end
	fs.remove("/tmp/user-chinalist.txt")
end

return m
