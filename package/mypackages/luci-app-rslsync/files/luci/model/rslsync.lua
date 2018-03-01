local fs = require "nixio.fs"
local util = require "nixio.util"

local m, s, o

local running=(luci.sys.call("pidof rslsync > /dev/null") == 0)
if running then
	Status = translate("<strong><font color=\"green\">Resilio Sync is Running</font></strong>")
else
	Status = translate("<strong><font color=\"red\">Resilio Sync is Not Running</font></strong>")
end

m = Map("rslsync")
m.title	= translate("Resilio Sync")
m.description = translate("A fast, reliable, and simple file sync and share solution")

s = m:section(TypedSection, "rslsync", "")
s.addremove = false
s.anonymous = true
s.description = translate(string.format("%s<br /><br />", Status))

s:tab("basic", translate("Basic Setting"))
s:taboption("basic", Flag, "enable", translate("Enable"))
s:taboption("basic", DummyValue,"opennewwindow" ,"<br /><p align=\"justify\"><script type=\"text/javascript\"></script><input type=\"button\" class=\"cbi-button cbi-button-apply\" value=\"Resilio Sync Web Page\" onclick=\"window.open('http://'+window.location.host+':8888')\" /></p>", detailInfo)


s:tab("config", translate("Config File"))
conf = s:taboption("config", Value, "editconf", nil, translate("开头的双斜线（//）的每一行被视为注释；删除（//）启用指定选项。"))
conf.template = "cbi/tvalue"
conf.rows = 20
conf.wrap = "off"
function conf.cfgvalue(self, section)
	return fs.readfile("/etc/rslsync.conf") or ""
end
function conf.write(self, section, value)
	if value then
		value = value:gsub("\r\n?", "\n")
		fs.writefile("/tmp/rslsync.conf", value)
		if (luci.sys.call("cmp -s /tmp/rslsync.conf /etc/rslsync.conf") == 1) then
			fs.writefile("/etc/rslsync.conf", value)
		end
		fs.remove("/tmp/rslsync.conf")
	end
end

--[[
s:tab("logs", translate("View the logs"))
log = s:taboption("logs", TextValue, "", nil, translate("BTSYNC Logs"))
log.rows = 20
log.wrap = "off"
log.cfgvalue = function(self, section)
	return fs.readfile("/var/log/rslsync.log") or ""
end
log.write = function(self, section, value)
end
]]

return m
