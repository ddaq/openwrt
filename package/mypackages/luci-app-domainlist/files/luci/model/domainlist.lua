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

--s:taboption("basic", Flag, "list", translate("生成域名列表"))

o = s:taboption("basic", Value, "ip", translate("DNS地址"))
--o:depends("list", "")
o.datatype = "ipaddr"
o.default = "8.8.4.4"
o.placeholder = "8.8.4.4"

o = s:taboption("basic", Value, "port", translate("DNS端口"))
--o:depends("list", "")
o.datatype = "port"
o.default = 53
o.placeholder = 53

o = s:taboption("basic", Value, "ipset", translate("IP-Set Name"))
--o:depends("list", "")
o.datatype = "string"
o.placeholder = "gfwlist/chinalist"

file1 = s:taboption("basic", DummyValue, "path1", translate("File Path"))
file1.value = string.format("/etc/domainlist/gfwlist.conf")
file1:depends({mode="gfwlist"})

file2 = s:taboption("basic", DummyValue, "path2", translate("File Path"))
file2.value = string.format("/etc/domainlist/chinalist.conf")
file2:depends({mode="chinalist"})

o = s:taboption("basic",ListValue,"time_update",translate("Auto Update"))
for s=0,23 do
	o:value(s,translate("每天"..s.."点"))
end
o.default=0
o.rmempty=false

generate=s:taboption("basic",Button,"generate",translate("Manually force update<br />gfw/china domain list"))
generate.inputtitle=translate("Update manually")
generate.inputstyle="reload"
generate.write=function()
	luci.sys.call("/usr/share/domainlist/domainlistupdate 2>&1 >/dev/null")
	luci.http.redirect(luci.dispatcher.build_url("admin","services","domainlist"))
end

s:tab("domain", translate("Extra Domain List"))

conf1 = s:taboption("domain", Value, "editconf1", nil, translate("User GFW Domain List File"))
conf1.template = "cbi/tvalue"
conf1.rows = 20
conf1.wrap = "off"
conf1:depends({mode="gfwlist"})
function conf1.cfgvalue(self, section)
	return fs.readfile("/usr/share/domainlist/user-gfwlist.txt") or ""
end
function conf1.write(self, section, value)
	if value then
		value = value:gsub("\r\n?", "\n")
		fs.writefile("/tmp/user-gfwlist.txt", value)
		if (luci.sys.call("cmp -s /tmp/user-gfwlist.txt /usr/share/domainlist/user-gfwlist.txt") == 1) then
			fs.writefile("/usr/share/domainlist/user-gfwlist.txt", value)
		end
		fs.remove("/tmp/user-gfwlist.txt")
	end
end

conf2 = s:taboption("domain", Value, "editconf2", nil, translate("User China Domain List File"))
conf2.template = "cbi/tvalue"
conf2.rows = 20
conf2.wrap = "off"
conf2:depends({mode="chinalist"})
function conf2.cfgvalue(self, section)
	return fs.readfile("/usr/share/domainlist/user-chinalist.txt") or ""
end
function conf2.write(self, section, value)
	if value then
		value = value:gsub("\r\n?", "\n")
		fs.writefile("/tmp/user-chinalist.txt", value)
		if (luci.sys.call("cmp -s /tmp/user-chinalist.txt /usr/share/domainlist/user-chinalist.txt") == 1) then
			fs.writefile("/usr/share/domainlist/user-chinalist.txt", value)
		end
		fs.remove("/tmp/user-chinalist.txt")
	end
end

return m
