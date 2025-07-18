return {

	nord = {
		0xff2e3440, -- polar night
		0xff3b4252, -- polar night
		0xff434c5e, -- polar night
		0xff4c566a, -- polar night
		0xffd8dee9, -- snow storm
		0xffe5e9f0, -- snow storm
		0xffeceff4, -- snow storm
		0xff8fbcbb, -- frost
		0xff88c0d0, -- frost
		0xff81a1c1, -- frost
		0xff5e81ac, -- frost
		0xffbf616a, -- aurora
		0xffd08770, -- aurora
		0xffebcb8b, -- aurora
		0xffa3be8c, -- aurora
		0xffb48ead, -- aurora
	},

	black = 0xff181819,
	white = 0xffe2e2e3,
	red = 0xffbf616a, -- aurora
	green = 0xffa3be8c, -- aurora
	blue = 0xff76cce0,
	yellow = 0xffebcb8b, -- aurora
	orange = 0xffd08770, -- aurora
	magenta = 0xffb39df3,
	grey = 0xff7f8490,
	transparent = 0x00000000,

	-- Nord palette
	-- https://www.nordtheme.com/docs/colors-and-palettes

	bar = {
		bg = 0xff2e3440, -- polar night
		border = 0xff3b4252, -- polar night
	},
	popup = {
		bg = 0xc02c2e34,
		border = 0xff7f8490,
	},
	bg1 = 0xff2e3440, -- polar night
	bg2 = 0xff3b4252, -- polar night

	rainbow = {
		0xffff007c,
		0xffc53b53,
		0xffff757f,
		0xff41a6b5,
		0xff4fd6be,
		0xffc3e88d,
		0xffffc777,
		0xff9d7cd8,
		0xffff9e64,
		0xffbb9af7,
		0xff7dcfff,
		0xff7aa2f7,
	},

	with_alpha = function(color, alpha)
		if alpha > 1.0 or alpha < 0.0 then
			return color
		end
		return (color & 0x00ffffff) | (math.floor(alpha * 255.0) << 24)
	end,
}
