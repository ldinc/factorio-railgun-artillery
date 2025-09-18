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
