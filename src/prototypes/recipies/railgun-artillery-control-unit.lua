require("lib.scripts.gen")
require("lib.features.all")

local lds_count = math.max(1, math.ceil(ldinc_railgun_artillery.lib.features.scale.recipe / 3))
local copper_cable_count = 30 * ldinc_railgun_artillery.lib.features.scale.recipe

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
			amount = lds_count,
		},
		{
			type = "item",
			name = "copper-cable",
			amount = copper_cable_count,
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

data:extend({
	ldinc_railgun_artillery.lib.script.gen.shell_recipe(
		ldinc_railgun_artillery.lib.constant.name.shell.base,
		{
			{
				type = "item",
				name = "artillery-shell",
				amount = 1,
			},
		}
	)
})
