module("luci.controller.chnroute", package.seeall)

function index()
	if not nixio.fs.access("/etc/config/chnroute") then
		return
	end
	local page
	page = entry({"admin", "services", "chnroute"}, cbi("chnroute"), _("China Routes"), 100)
	page.i18n = "chnroute"
	page.dependent = true
end
