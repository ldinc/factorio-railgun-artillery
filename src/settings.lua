--- [startup settings]
---@type table<string, ModSetting>
local startup = {
	{
		type = "int-setting",
		name = "ldinc_railgun_artillery_energy_per_shot",
		setting_type = "startup",
		default_value = 10,
		minimum_value = 1,
		maximum_value = 100,
		order = "ba_a",
	},
	{
		type = "int-setting",
		name = "ldinc_railgun_artillery_stack_size",
		setting_type = "startup",
		default_value = 10,
		minimum_value = 1,
		maximum_value = 200,
		allowed_values = { 1, 2, 5, 10, 20, 50, 100, 200 },
		order = "ba_a",
	},
	{
		type = "int-setting",
		name = "ldinc_railgun_artillery_entities_per_update",
		setting_type = "startup",
		default_value = 50,
		minimum_value = 1,
		maximum_value = 500,
		order = "pa_a",
	},
	{
		type = "int-setting",
		name = "ldinc_railgun_artillery_ticks_per_entities_update",
		setting_type = "startup",
		default_value = 20,
		minimum_value = 1,
		maximum_value = 100,
		order = "pa_a",
	},
	{
		type = "int-setting",
		name = "ldinc_railgun_artillery_ticks_per_gui_update",
		setting_type = "startup",
		default_value = 5,
		minimum_value = 1,
		maximum_value = 60,
		order = "pa_a",
	},
	{
		type = "bool-setting",
		name = "ldinc_railgun_artillery_alt_sounds",
		setting_type = "startup",
		default_value = false,
		order = "sa_a",
	},
	{
		type = "int-setting",
		name = "ldinc_railgun_artillery_damage_scale",
		setting_type = "startup",
		default_value = 5,
		minimum_value = 1,
		maximum_value = 1000,
		order = "ba_a",
	},
	{
		type = "int-setting",
		name = "ldinc_railgun_artillery_recipe_scale",
		setting_type = "startup",
		default_value = 3,
		minimum_value = 1,
		maximum_value = 1000,
		order = "ba_a",
	},
	{
		type = "int-setting",
		name = "ldinc_railgun_artillery_base_radius",
		setting_type = "startup",
		default_value = 400,
		minimum_value = 250,
		maximum_value = 1000,
		order = "ba_a",
	}
}

--- TODO: adding settings for damage & specs for artillery - radius and etc

data:extend(startup)
