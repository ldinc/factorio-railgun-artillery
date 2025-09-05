---@type data.RecipePrototype
local recipe = {
	type = "recipe",
	name = "ldinc-railgun-artillery-control-unit-loading",
	icon = "__base__/graphics/icons/fluid/basic-oil-processing.png",
	category = "ldinc-railgun-artillery-control-unit",
	hide_from_player_crafting = true,
	enabled = true,
	ingredients = {
		{
			type = "item",
			name = "artillery-shell",
			amount = 1,
		},
		-- {
		-- 	type = "fluid",
		-- 	name = "fluoroketone-cold",
		-- 	amount = 25,
		-- },
	},
	main_product = "ldinc-railgun-ammo-loaded",
	results = {
		{
			type = "item",
			name = "ldinc-railgun-ammo-loaded",
			amount = 1,
		},
		-- {
		-- 	type = "fluid",
		-- 	name = "fluoroketone-hot",
		-- 	amount = 25,
		-- }
	},
	energy_required = 2,
	hide_from_stats = true,

}

data.raw["ammo"]["artillery-shell"].ammo_type.action.action_delivery.trigger_fired_artillery = false

data:extend({ recipe })
