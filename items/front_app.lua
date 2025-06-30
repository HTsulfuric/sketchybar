local colors = require("colors")
local settings = require("settings")
local app_icons = require("helpers.app_icons")

local front_app = sbar.add("item", "front_app", {
	display = "active",
	icon = {
		drawing = false,
	},
	label = {
		font = settings.icons,
		padding_right = settings.items.padding.right,
	},
	updates = true,
})

front_app:subscribe("front_app_switched", function(env)
	local icon = app_icons[env.INFO] or app_icons.default
	front_app:set({
		label = {
			string = icon,
			font = {
				size = 15.0,
			},
		},
	})
end)

front_app:subscribe("mouse.clicked", function(env)
	sbar.trigger("swap_menus_and_spaces")
end)
