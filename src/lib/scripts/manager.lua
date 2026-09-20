if not ldinc_railgun_artillery then ldinc_railgun_artillery = {} end
if not ldinc_railgun_artillery.lib then ldinc_railgun_artillery.lib = {} end
if not ldinc_railgun_artillery.lib.script then ldinc_railgun_artillery.lib.script = {} end
if not ldinc_railgun_artillery.lib.script.manager then ldinc_railgun_artillery.lib.script.manager = {} end

require("lib.features.all")
require("lib.constant")
require("lib.scripts.manager.visuals")
require("lib.scripts.manager.status")
require("lib.scripts.manager.state")
require("lib.scripts.manager.ui")
require("lib.scripts.manager.units")

---@class Railgun_Info
---@field entity LuaEntity
---@field electric_interface_id integer
---@field last_energy double?
---@field charging boolean?
---@field status_key string?
---@field skip integer?
---@field tooltip_tick uint?
---@field tooltip_value string?

---@class Railgun_UI_UpdateInfo
---@field player_index integer
---@field railgun_id integer
---@field progressbar LuaGuiElement
---@field statusbar LuaGuiElement
---@field electric_interface_id integer

function ldinc_railgun_artillery.lib.script.manager.new()
	local manager = {
		state = {
			---@type integer[]
			queue = {},
			---@type table<integer, boolean>
			destroyed = {},
			---@type int64
			current = 0,
			limit = ldinc_railgun_artillery.lib.features.entities_per_update,
		},

		---@type table<integer, Railgun_Info>
		railguns = {},

		---@type table<integer, LuaEntity>
		electric_interfaces = {},

		---@type table<integer, Railgun_UI_UpdateInfo>
		ui = {},
	}

	if not storage.railgun then storage.railgun = {} end

	storage.railgun.manager = manager
	ldinc_railgun_artillery.lib.script.manager.update()
end

function ldinc_railgun_artillery.lib.script.manager.update()
	if not storage.railgun then return end
	if not storage.railgun.manager then return end

	storage.railgun.manager.state.limit = ldinc_railgun_artillery.lib.features.entities_per_update
end
