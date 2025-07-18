local settings = require("settings")

local mode_indicator = sbar.add("item", "mode_indicator", {
	label = {
		string = "main",
		font = {
			family = settings.font.text,
			style = "Bold",
			size = 10.0,
		},
		width = 50,
		align = "center",
		padding_right = 8,
		padding_left = 1,
	},
	background = {
		color = settings.items.colors.background,
		corner_radius = settings.items.corner_radius,
		height = settings.items.height,
	},
	padding_left = 0,
	padding_right = 4,
	drawing = true,
})

-- AeroSpace mode change イベントを監視
mode_indicator:subscribe("aerospace_mode_change", function(env)
	local mode = env["MODE"]
	if mode then
		mode_indicator:set({
			label = {
				string = mode,
			},
		})
	end
end)