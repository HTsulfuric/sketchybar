local colors = require("colors")
local icons = require("icons")

return {
	paddings = 3,
	group_paddings = 3,
	modes = {
		main = {
			icon = icons.apple,
			color = colors.nord[6],
		},
		service = {
			icon = icons.nuke,
			color = colors.nord[7],
		},
	},
	bar = {
		height = 25,
		padding = {
			x = 10,
			y = 0,
		},
		background = colors.bar.bg,
	},
	items = {
		height = 23,
		gap = 2,
		padding = {
			right = 7,
			left = 8,
			top = 0,
			bottom = 0,
		},
		default_color = function(workspace)
			return colors.nord[6]
		end,
		highlight_color = function(workspace)
			return colors.nord[9]
		end,
		colors = {
			background = colors.bg1,
		},
		corner_radius = 6,
	},

	icons = "sketchybar-app-font:Regular:12.0", -- alternatively available: NerdFont
	font = {
		text = "HackGen NF",
		numbers = "HackGen NF", -- Used for numbers
		style_map = {
			["Regular"] = "Regular",
			["Semibold"] = "Medium",
			["Bold"] = "SemiBold",
			["Heavy"] = "Bold",
			["Black"] = "ExtraBold",
		},
	},
}
