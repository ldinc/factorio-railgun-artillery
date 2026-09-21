--- [tips and tricks]
--- One category: a title entry and three children, taught in the order a player meets them.
---
--- NOTE: every simulation lists this mod in `mods`. That loads control.lua inside the
--- simulation, so a railgun built there gets its power unit and the energy gate is the real
--- one. Without it the simulated turret would never be disabled and would fire for free.

require("lib.constant")

local MOD = "__ldinc_railgun_artillery__"
local CATEGORY = "ldinc-railgun-artillery"

local ARTILLERY = ldinc_railgun_artillery.lib.constant.name.artillery
local SHELL = ldinc_railgun_artillery.lib.constant.name.shell.base

local SIMULATION_MODS = { "ldinc_railgun_artillery" }

--- [simulation]
--- Every field left out here is optional in the game and falls back to its default. Some LuaLS
--- definitions mark them as required anyway (`save` and `game_view_settings` have no neutral
--- value that could be filled in), hence the one suppression below instead of one per tip.
---@param scene string init script in simulations/
---@param update string? update script in simulations/, run every tick
---@param warmup uint32 ticks simulated before the scene is shown
---@return SimulationDefinition
local function simulation(scene, update, warmup)
	---@diagnostic disable-next-line: missing-fields
	return {
		mods = SIMULATION_MODS,
		init_file = MOD .. "/simulations/" .. scene .. ".lua",
		update_file = update and (MOD .. "/simulations/" .. update .. ".lua") or nil,
		init_update_count = warmup,
	}
end

data:extend({
	{
		type = "tips-and-tricks-item-category",
		name = CATEGORY,
		order = "z[ldinc-railgun-artillery]",
	},

	--- what it is and what it needs; shown when the technology is researched
	{
		type = "tips-and-tricks-item",
		name = "ldinc-railgun-artillery",
		category = CATEGORY,
		order = "a",
		is_title = true,
		tag = "[entity=" .. ARTILLERY .. "]",
		trigger = { type = "research", technology = "ldinc-railgun-artillery" },
		simulation = simulation("overview", "flares", 60),
	},

	--- the one rule that differs from vanilla artillery; shown on the first railgun built
	{
		type = "tips-and-tricks-item",
		name = "ldinc-railgun-artillery-charging",
		category = CATEGORY,
		order = "b",
		indent = 1,
		tag = "[virtual-signal=signal-battery-mid-level]",
		trigger = { type = "build-entity", entity = ARTILLERY },
		simulation = simulation("power", "flares", 240),
	},

	--- which ammo fits; suggested once the overview has been read
	{
		type = "tips-and-tricks-item",
		name = "ldinc-railgun-artillery-shells",
		category = CATEGORY,
		order = "c",
		indent = 1,
		tag = "[item=" .. SHELL .. "]",
		dependencies = { "ldinc-railgun-artillery" },
		trigger = { type = "dependencies-met" },
		simulation = simulation("shells", nil, 120),
	},

	--- brownouts; only once there is a battery of turrets and the network has actually dipped
	{
		type = "tips-and-tricks-item",
		name = "ldinc-railgun-artillery-power-planning",
		category = CATEGORY,
		order = "d",
		indent = 1,
		tag = "[entity=accumulator]",
		dependencies = { "ldinc-railgun-artillery-charging" },
		trigger = {
			type = "and",
			triggers = {
				{ type = "build-entity", entity = ARTILLERY, count = 4 },
				{ type = "low-power" },
			},
		},
	},
})
