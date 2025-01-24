---@type data.RecipePrototype
local recipe = {
	type = "recipe",
	name = ldinc_railgun_artillery.lib.constant.name.artillery,
	enabled = false,
	energy_required = 50,
	ingredients = {
		{ type = "item", name = "steel-plate",          amount = 100 },
		{ type = "item", name = "copper-cable",         amount = 100 },
		{ type = "item", name = "electric-engine-unit", amount = 30 },
		{ type = "item", name = "concrete",             amount = 60 },
		{ type = "item", name = "iron-gear-wheel",      amount = 60 },
		{ type = "item", name = "processing-unit",      amount = 50 }
	},
	results = { { type = "item", name = ldinc_railgun_artillery.lib.constant.name.artillery, amount = 1 } }
}

if mods["space-age"] then
	recipe.ingredients = {}
end

data:extend({ recipe })
