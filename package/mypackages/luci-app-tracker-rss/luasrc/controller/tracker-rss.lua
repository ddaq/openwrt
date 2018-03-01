module("luci.controller.tracker-rss", package.seeall)

function index()
	if not nixio.fs.access("/etc/config/tracker-rss") then
		return
	end
	local page
	page = entry({"admin", "services", "tracker-rss"}, cbi("tracker-rss"), _("Tracker RSS"), 100)
	page.i18n = "tracker-rss"
	page.dependent = true
end
