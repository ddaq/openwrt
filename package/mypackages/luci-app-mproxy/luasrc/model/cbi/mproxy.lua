local SYS  = require "luci.sys"

local m, s, o

if SYS.call("pidof mproxy >/dev/null") == 0 then
	Status = translate("<strong><font color=\"green\">Mproxy is Running</font></strong>")
else
	Status = translate("<strong><font color=\"red\">Mproxy is Not Running</font></strong>")
end

m = Map("mproxy")
m.title	= translate("Mproxy Server")
m.description = translate("A mini HTTP/HTTPS Proxy Server for Something")

s = m:section(TypedSection, "mproxy", "")
s.addremove = false
s.anonymous = true
s.description = translate(string.format("%s<br /><br />", Status))

s:option(Flag, "enabled", translate("Start"))

o = s:option(Value, "local_port", translate("Local Port"))
o.datatype = "port"
o.default = 8080
o.placeholder = 8080

o = s:option(Value, "remote_ip", translate("Remote IP"))
o.datatype = "ipaddr"
o.default = "127.0.0.1"
o.placeholder = "127.0.0.1"

o = s:option(Value, "remote_port", translate("Remote Port"))
o.datatype = "port"
o.default = 1194
o.placeholder = 1194

return m
