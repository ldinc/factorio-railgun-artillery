---@type data.TechnologyPrototype
local technology = {
	type = "technology",
	name = "ldinc-railgun-artillery",
	icon = "__ldinc_railgun_artillery__/graphics/technology/railgun-artillery.png",
	icon_size = 256,
	effects = {
		{
			type = "unlock-recipe",
			recipe = ldinc_railgun_artillery.lib.constant.name.artillery,
		}
		--- TODO: add ammos here
	},
	prerequisites = {
		"artillery",
		"space-science-pack",
	},
	unit = {
		ingredients = {
			{ "automation-science-pack", 1 },
			{ "logistic-science-pack",   1 },
			{ "chemical-science-pack",   1 },
			{ "military-science-pack",   1 },
			{ "utility-science-pack",    1 },
			{ "space-science-pack",      1 }
		},
		time = 50,
		count = 2000,
	},
}

if mods["space-age"] then
	technology.prerequisites = {
		"artillery",
		"railgun",
	}

	technology.unit.ingredients = {
		{ "automation-science-pack",      1 },
		{ "logistic-science-pack",        1 },
		{ "chemical-science-pack",        1 },
		{ "military-science-pack",        1 },
		{ "utility-science-pack",         1 },
		{ "space-science-pack",           1 },
		{ "metallurgic-science-pack",     1 },
		{ "electromagnetic-science-pack", 1 },
		{ "agricultural-science-pack",    1 },
		{ "cryogenic-science-pack",       1 }
	}
end

data:extend({ technology })
