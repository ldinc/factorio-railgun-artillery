require("lib.features.all")
require("lib.constant")

local name = ldinc_railgun_artillery.lib.constant.name.power_unit

local cap = ldinc_railgun_artillery.lib.features.energy_per_shot * ldinc_railgun_artillery.lib.features.stack_size
local flow_limit = ldinc_railgun_artillery.lib.features.energy_per_shot * 3 / 60

data:extend({
	{
		type = "electric-energy-interface",
		name = name,

		icon = ldinc_railgun_artillery.lib.constant.path.icon_item,
		icon_size = 64,

		flags = {
			"placeable-off-grid",
			"not-on-map",
			"not-blueprintable",
			"not-deconstructable",
			"not-upgradable",
			"not-repairable",
			"not-flammable",
			"no-copy-paste",
			"not-selectable-in-game",
			"hide-alt-info",
			"not-in-kill-statistics",
			"not-in-made-in",
		},

		hidden = true,
		hidden_in_factoriopedia = true,

		max_health = 500,

		--- an empty collision mask keeps the box for the electric pole coverage check without
		--- colliding with anything
		collision_box = { { -1.2, -1.2 }, { 1.2, 1.2 } },
		collision_mask = { layers = {} },
		selection_box = { { 0, 0 }, { 0, 0 } },
		selectable_in_game = false,
		allow_copy_paste = false,

		tile_width = 3,
		tile_height = 3,

		gui_mode = "none",

		energy_source = {
			type = "electric",
			buffer_capacity = tostring(cap) .. "J",
			usage_priority = "secondary-input",
			input_flow_limit = tostring(flow_limit) .. "J",
			output_flow_limit = "0J",
			drain = "0J",
		},

		energy_production = "0J",
		energy_usage = "0J",

		picture = util.empty_sprite(),
	},
})
