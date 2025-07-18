local icons = require("icons")
local colors = require("colors")

local whitelist = {
	["Spotify"] = true,
	["Music"] = true,
}

local media_item = sbar.add("item", "media_item", {
	position = "left",
	drawing = true,
	padding_left = 3,
	padding_right = 0,
	background = {
		image = {
			string = "media.artwork",
			scale = 0.85,
		},
		color = colors.transparent,
	},
	icon = {
		string = "🎵",
		drawing = true,
	},
	label = {
		string = "No Media",
		font = {
			size = 10,
		},
		width = "dynamic",
		max_chars = 12,
		scroll_texts = true,
		scroll_duration = 120,
		y_offset = 0,
	},
	script = "~/.config/sketchybar/helpers/update_media.sh",
	update_freq = 2,
	popup = {
		align = "center",
		horizontal = true,
	},
})

sbar.add("item", "media_back", {
	position = "popup." .. media_item.name,
	icon = {
		string = icons.media.back,
	},
	label = {
		drawing = false,
	},
	click_script = "~/.config/sketchybar/helpers/media_control.sh previous",
})
sbar.add("item", "media_play", {
	position = "popup." .. media_item.name,
	icon = {
		string = icons.media.play_pause,
	},
	label = {
		drawing = false,
	},
	click_script = "~/.config/sketchybar/helpers/media_control.sh playpause",
})
sbar.add("item", "media_next", {
	position = "popup." .. media_item.name,
	icon = {
		string = icons.media.forward,
	},
	label = {
		drawing = false,
	},
	click_script = "~/.config/sketchybar/helpers/media_control.sh next",
})

-- Removed animation and mouse hover effects

media_item:subscribe("mouse.clicked", function(env)
	media_item:set({
		popup = {
			drawing = "toggle",
		},
	})
end)

media_item:subscribe("mouse.exited.global", function(env)
	media_item:set({
		popup = {
			drawing = false,
		},
	})
end)

-- Health check item (invisible, for sleep recovery)
sbar.add("item", "media_health_check", {
	position = "left",
	drawing = false,
	script = "~/.config/sketchybar/helpers/health_check.sh",
	update_freq = 10,
})