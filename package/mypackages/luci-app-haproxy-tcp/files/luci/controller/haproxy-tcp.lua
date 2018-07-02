module("luci.controller.haproxy-tcp", package.seeall)

function index()
	if not nixio.fs.access("/etc/config/haproxy-tcp") then
		return
	end
	entry({"admin", "services", "haproxy-tcp"}, cbi("haproxy-tcp"), _("HAProxy-TCP"), 55).dependent = true
end
