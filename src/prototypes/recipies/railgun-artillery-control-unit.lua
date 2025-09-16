---@type data.RecipePrototype
local recipe = {
	type = "recipe",
	name = ldinc_railgun_artillery.lib.constant.name.shell.body,
	icon = "__ldinc_railgun_artillery__/graphics/entity/shell/shell-body-icon.png",
	category = "crafting",
	ingredients = {
		{
			type = "item",
			name = "low-density-structure",
			amount = 1,
		},
		{
			type = "item",
			name = "copper-cable",
			amount = 100,
		},
	},
	main_product = ldinc_railgun_artillery.lib.constant.name.shell.body,
	results = {
		{
			type = "item",
			name = ldinc_railgun_artillery.lib.constant.name.shell.body,
			amount = 1,
		},
	},
	energy_required = 2,
}

data:extend({ recipe })

---@type data.RecipePrototype
recipe = {
	type = "recipe",
	name = ldinc_railgun_artillery.lib.constant.name.shell.base,
	icon = "__ldinc_railgun_artillery__/graphics/entity/shell/shell-body.png",
	ingredients = {
		{
			type = "item",
			name = "artillery-shell",
			amount = 1,
		},
		{
			type = "item",
			name = ldinc_railgun_artillery.lib.constant.name.shell.body,
			amount = 1,
		},
	},
	main_product = ldinc_railgun_artillery.lib.constant.name.shell.base,
	results = {
		{
			type = "item",
			name = ldinc_railgun_artillery.lib.constant.name.shell.base,
			amount = 1,
		},
	},
	energy_required = 2,
}

-- data.raw["ammo"]["artillery-shell"].ammo_type.action.action_delivery.trigger_fired_artillery = false

data:extend({ recipe })
