local new_tech = {
	type = "technology",
	name = "apm_crusher_machine_0",
	icon = "__apm_resource_pack_ldinc__/graphics/technologies/apm_crusher_machine_0.png",
	icon_size = 128,
	effects =
	{
		{
			type = "unlock-recipe",
			recipe = "lab"
		},
	},
	research_trigger =
	{
		type = "mine-entity",
		entity = "stone"
	}
}

data:extend({new_tech})

-- local tech = data.raw["technology"]["steam-power"]
-- tech.research_trigger.item = "stone"
