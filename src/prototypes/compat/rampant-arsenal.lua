--- generate items

require("lib.scripts.gen")

local list = {
	{
		source = "bio-artillery-ammo-rampant-arsenal",
		target = "ldinc-railgun-ammo-loaded-bio",
		icon = "shell-body-icon-rampant-bio.png",
	},
	{
		source = "he-artillery-ammo-rampant-arsenal",
		target = "ldinc-railgun-ammo-loaded-he",
		icon = "shell-body-icon-rampant-he.png",
	},
	{
		source = "incendiary-artillery-ammo-rampant-arsenal",
		target = "ldinc-railgun-ammo-loaded-incendiary",
		icon = "shell-body-icon-rampant-incendiary.png"
	},
	{
		source = "nuclear-artillery-ammo-rampant-arsenal",
		target = "ldinc-railgun-ammo-loaded-nuclear",
		icon = "shell-body-icon-rampant-nuclear.png"
	}
}

for _, el in ipairs(list) do
	if data.raw["ammo"][el.source] then
		data:extend({
			ldinc_railgun_artillery.lib.script.gen.shell_item(
				el.target,
				el.icon
			)
		})
	end

	if data.raw["recipe"][el.source] then
		data:extend({
			ldinc_railgun_artillery.lib.script.gen.shell_recipe(
				el.target,
				{
					{
						type = "item",
						name = el.source,
						amount = 1,
					},
				}
			)
		})
	end
end

--- add to  technology
local tech = data.raw["technology"]["ldinc-railgun-artillery"]

if tech then
	for _, el in ipairs(list) do
		---@type data.UnlockRecipeModifier
		value = {
			type = "unlock-recipe",
			recipe = el.target,
		}

		table.insert(tech.effects, value)
	end

	local prereqs = {
		"rampant-arsenal-technology-bio-artillery-shells",
		"rampant-arsenal-technology-he-artillery-shells",
		"rampant-arsenal-technology-nuclear-artillery-shells",
		"rampant-arsenal-technology-incendiary-artillery-shells",
	}

	for _, prereq in ipairs(prereqs) do
		if data.raw["technology"][prereq] then
			table.insert(tech.prerequisites, prereq)
		end
	end
end

local damage_buff = data.raw["technology"]["rampant-arsenal-technology-artillery-shell-damage-1"]

if damage_buff then
	table.insert(
		damage_buff.effects,
		{
			type = "ammo-damage",
			ammo_category = ldinc_railgun_artillery.lib.constant.name.category,
			modifier = 0.4
		}
	)
end

local turret_damage = data.raw["technology"]["rampant-arsenal-technology-artillery-turret-damage-1"]

if turret_damage then
	table.insert(
		turret_damage.effects,
		{
			type = "turret-attack",
			turret_id = ldinc_railgun_artillery.lib.constant.name.artillery,
			modifier = 0.4
		}
	)
end
