require("lib.features.all")

local eu = table.deepcopy(data.raw["accumulator"]["accumulator"])

local cap = ldinc_railgun_artillery.lib.features.energy_per_shot * ldinc_railgun_artillery.lib.features.stack_size
local flow_limit = ldinc_railgun_artillery.lib.features.energy_per_shot * 3 / 60

eu.name = "ldinc-railgun-artillery-power-unit"

eu.icon = ldinc_railgun_artillery.lib.constant.path.icon_item
eu.icons = nil

eu.energy_source.buffer_capacity = tostring(cap) .. "J"
eu.energy_source.drain = "0J"
eu.energy_source.input_flow_limit = tostring(flow_limit) .. "J"
eu.energy_source.output_flow_limit = "0J"

eu.tile_width = 3
eu.tile_height = 3

eu.selection_box = { { 0, 0 }, { 0, 0 } }
eu.circuit_connector = nil

eu.chargable_graphics.picture = nil
eu.chargable_graphics.discharge_animation.layers = {
	{
		filename = "__base__/graphics/entity/accumulator/accumulator-discharge.png",
		priority = "high",
		width = 174,
		height = 214,
		line_length = 6,
		frame_count = 24,
		draw_as_glow = true,
		shift = util.by_pixel(-1, -23),
		scale = 0.5
	}
}
eu.chargable_graphics.charge_animation.layers = {
	{
		filename = "__base__/graphics/entity/accumulator/accumulator-charge.png",
		priority = "high",
		width = 178,
		height = 210,
		line_length = 6,
		frame_count = 24,
		draw_as_glow = true,
		shift = util.by_pixel(0, -22),
		scale = 0.5
	}
}
eu.water_reflection = nil

data.extend({ eu })
