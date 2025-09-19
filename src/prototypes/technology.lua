require("lib.constant")

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
		},
		{
			type = "unlock-recipe",
			recipe = ldinc_railgun_artillery.lib.constant.name.shell.body
		},
		{
			type = "unlock-recipe",
			recipe = ldinc_railgun_artillery.lib.constant.name.shell.base
		}
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

local inf_tech = data.raw["technology"]["artillery-shell-damage-1"]

if inf_tech then
	table.insert(inf_tech.effects,
		{
			type = "ammo-damage",
			ammo_category = ldinc_railgun_artillery.lib.constant.name.category,
			modifier = 0.1
		}
	)
end

local speed_tech = data.raw["technology"]["artillery-shell-speed-1"]

if speed_tech then
	table.insert(speed_tech.effects,
		{
			type = "gun-speed",
			ammo_category = ldinc_railgun_artillery.lib.constant.name.category,
			icon = ldinc_railgun_artillery.lib.constant.path.icon,
			modifier = 1
		}
	)
end

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
