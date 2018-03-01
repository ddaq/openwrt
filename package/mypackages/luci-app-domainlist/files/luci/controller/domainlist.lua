module("luci.controller.domainlist", package.seeall)

function index()
	if not nixio.fs.access("/etc/config/domainlist") then
		return
	end
	local page
	page = entry({"admin", "services", "domainlist"}, cbi("domainlist"), _("Domain List"), 100)
	page.i18n = "domainlist"
	page.dependent = true
end
