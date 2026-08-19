require("util")
require("lib.constant")

data:extend({
	{
		type = "animation",
		name = ldinc_railgun_artillery.lib.constant.name.animation.charge,
		filename = "__base__/graphics/entity/accumulator/accumulator-charge.png",
		priority = "high",
		width = 178,
		height = 210,
		line_length = 6,
		frame_count = 24,
		animation_speed = 0.5,
		draw_as_glow = true,
		shift = util.by_pixel(0, -22),
		scale = 0.5,
	},
	{
		type = "animation",
		name = ldinc_railgun_artillery.lib.constant.name.animation.discharge,
		filename = "__base__/graphics/entity/accumulator/accumulator-discharge.png",
		priority = "high",
		width = 174,
		height = 214,
		line_length = 6,
		frame_count = 24,
		animation_speed = 0.5,
		draw_as_glow = true,
		shift = util.by_pixel(-1, -23),
		scale = 0.5,
	},
})
