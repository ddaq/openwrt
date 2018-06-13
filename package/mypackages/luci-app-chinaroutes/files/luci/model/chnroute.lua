local fs = require "nixio.fs"
local util = require "nixio.util"

local m, s, o

local week_days = {
	"Sun",
	"Mon",
	"Tue",
	"Wed",
	"Thu",
	"Fri",
	"Sat",
}

m = Map("chnroute", translate("China Routes"), translate("A shell script update China Routes List."))
s = m:section(TypedSection, "chnroute", translate("Basic Setting"))
s.anonymous = true

o=s:option(Flag, "enabled", translate("Enable"))
o.default=0
o.rmempty=false

o=s:option(Value, "file", translate("File Path"))
o.datatype = "string"
o.placeholder = "/etc/chnroute.list"

o=s:option(ListValue, "day_update", translate("Auto Update"))
o.default=0
o.rmempty=false
for k,v in ipairs(week_days) do 
	o:value(k-1,translate(v))
	--o:value(k-1,translate("Every"..v))
end
--[[
o=s:taboption("basic",ListValue,"hour_update",translate(""))
for s=0,23 do
	o:value(s,translate(s.."点"))
end
o.default=0
o.rmempty=false
--]]

o=s:option(Button,"generate",translate("Manual Update"))
o.inputtitle=translate("Update List")
o.inputstyle="reload"
o.write=function()
	luci.sys.call("/usr/sbin/chnroute 2>&1 >/dev/null")
	luci.http.redirect(luci.dispatcher.build_url("admin","services","chnroute"))
end

return m
