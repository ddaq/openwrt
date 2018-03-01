module("luci.controller.rslsync", package.seeall)

function index()
	if not nixio.fs.access("/etc/config/rslsync") then
		return
	end
	local page
	page = entry({"admin", "services", "rslsync"}, cbi("rslsync"), _("Resilio Sync"), 100)
	page.dependent = true
end
