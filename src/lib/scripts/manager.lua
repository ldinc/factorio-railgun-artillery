if not ldinc_railgun_artillery then ldinc_railgun_artillery = {} end
if not ldinc_railgun_artillery.lib then ldinc_railgun_artillery.lib = {} end
if not ldinc_railgun_artillery.lib.script then ldinc_railgun_artillery.lib.script = {} end
if not ldinc_railgun_artillery.lib.script.manager then ldinc_railgun_artillery.lib.script.manager = {} end

require("lib.features.all")

---@class Railgun_Info
---@field entity LuaEntity
---@field electric_interface_id integer

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

---@type table<string,  (string|(string|(string)[])[])?>
local loc_strings = {
	l = { "ldinc_railgun_artillery_info", "low" },
	m = { "ldinc_railgun_artillery_info", "mid-level" },
	f = { "ldinc_railgun_artillery_info", "full" },
}



---@param railgun LuaEntity
---@param electric_interface? LuaEntity
local function disable_railgun(railgun, electric_interface)
	if not railgun.valid then
		return
	end

	railgun.active = false
	railgun.custom_status = {
		diode = defines.entity_status_diode.yellow,
		label = { "entity-status.charging" },
	}

	if electric_interface and electric_interface.valid then
		if electric_interface.energy < ldinc_railgun_artillery.lib.features.energy_per_shot then
			railgun.custom_status = {
				diode = defines.entity_status_diode.red,
				label = { "entity-status.low-power" },
			}
		end

		if electric_interface.status == defines.entity_status.no_power then
			railgun.custom_status = {
				diode = defines.entity_status_diode.red,
				label = { "entity-status.no-power" },
			}
		end
	end
end

---@param railgun LuaEntity
local function enable_railgun(railgun)
	railgun.active = true
	railgun.custom_status = {
		diode = defines.entity_status_diode.green,
		label = { "description.ldinc_railgun_artillery_status_ready" }
	}
end

function ldinc_railgun_artillery.lib.script.manager.update()
	if not storage.railgun then return end
	if not storage.railgun.manager then return end

	storage.railgun.manager.state.limit = ldinc_railgun_artillery.lib.features.entities_per_update
end

---@param index int64
local function state_update_for_entity(index)
	local railgun_id = storage.railgun.manager.state.queue[index]

	if storage.railgun.manager.state.destroyed[railgun_id] then
		table.remove(storage.railgun.manager.state.queue, index)
		storage.railgun.manager.state.destroyed[railgun_id] = nil

		return
	end


	local info = storage.railgun.manager.railguns[railgun_id]

	if not info then
		return
	end

	local artillery = info.entity

	if not artillery then
		return
	end

	if not artillery.valid then
		return
	end

	local electric_interface = storage.railgun.manager.electric_interfaces[info.electric_interface_id]

	if not electric_interface or not electric_interface.valid then
		return
	end

	if electric_interface.energy >= ldinc_railgun_artillery.lib.features.energy_per_shot then
		enable_railgun(artillery)
	else
		disable_railgun(artillery, electric_interface)
	end
end

function ldinc_railgun_artillery.lib.script.manager.state_update()
	if not storage.railgun then return end
	if not storage.railgun.manager then return end
	if not storage.railgun.manager.state then return end

	local total_count = #storage.railgun.manager.state.queue

	if total_count == 0 then return end

	local index = storage.railgun.manager.state.current
	local handled = 0

	while true do
		index = index + 1

		if index > total_count then
			index = 1
		end

		state_update_for_entity(index)

		handled = handled + 1

		if handled > storage.railgun.manager.state.limit then
			-- save state
			storage.railgun.manager.state.current = index

			return
		end
	end
end

---@class Railgun_UI_State
---@field player_index integer
---@field progressbar? LuaGuiElement
---@field statusbar? LuaGuiElement
---@field railgun_id integer

--- NOTE:
--- Well. With multiplayer game you need to wait server ack that  gui still opened...
--- So there is anoying lag with adding extra frame to entity. Sad.
--- https://forums.factorio.com/viewtopic.php?t=90795

---@param state Railgun_UI_State
function ldinc_railgun_artillery.lib.script.manager.register_opened_ui(state)
	if not state or not state.progressbar or not state.statusbar then
		return
	end

	if not state.progressbar.valid or not state.statusbar.valid then
		return
	end

	local info = storage.railgun.manager.railguns[state.railgun_id]

	if not info then
		return
	end

	if not storage.railgun.manager.electric_interfaces[info.electric_interface_id] then
		return
	end

	storage.railgun.manager.ui[state.player_index] = {
		player_index = state.player_index,
		railgun_id = state.railgun_id,
		progressbar = state.progressbar,
		statusbar = state.statusbar,
		electric_interface_id = info.electric_interface_id
	}
end

---@param player_index integer
function ldinc_railgun_artillery.lib.script.manager.register_closed_ui(player_index)
	storage.railgun.manager.ui[player_index] = nil
end

--- check if ui updates > 256... drop table?
function ldinc_railgun_artillery.lib.script.manager.update_ui()
	local stack_size = ldinc_railgun_artillery.lib.features.stack_size
	local energy_per_shot = ldinc_railgun_artillery.lib.features.energy_per_shot
	local energy_limit = energy_per_shot * stack_size

	for player_index, state in pairs(storage.railgun.manager.ui) do
		if not state then
			ldinc_railgun_artillery.lib.script.manager.register_closed_ui(player_index)

			goto continue
		end

		if not game.get_player(player_index) then
			ldinc_railgun_artillery.lib.script.manager.register_closed_ui(player_index)

			goto continue
		end

		local electric_interface = storage.railgun.manager.electric_interfaces[state.electric_interface_id]

		if not electric_interface or not electric_interface.valid then goto continue end

		local progress = electric_interface.energy / energy_limit

		if state.progressbar and state.progressbar.valid then
			state.progressbar.value = progress

			local color = ldinc_railgun_artillery.lib.constant.colors.red

			if electric_interface.energy > energy_per_shot then
				color = ldinc_railgun_artillery.lib.constant.colors.yellow
			end

			if electric_interface.energy > energy_limit / 2 then
				color = ldinc_railgun_artillery.lib.constant.colors.green
			end

			state.progressbar.style.color = color
		end

		if not state.statusbar and not state.statusbar.valid then goto continue end

		state.statusbar.caption = string.format("%.1f/%.1f MJ", electric_interface.energy / 1000000, energy_limit / 1000000)

		::continue::
	end
end

---@param railgun LuaEntity
function ldinc_railgun_artillery.lib.script.manager.on_built_entity(railgun)
	if railgun.name ~= "ldinc-railgun-artillery" then
		return
	end

	---@type string|integer|LuaForce
	local force = railgun.force
	local current_surface = railgun.surface

	---@type LuaSurface.create_entity_param
	local param = {
		name = "ldinc-railgun-artillery-power-unit",
		position = { railgun.position.x, railgun.position.y },
		force = force,
	}

	local electric_interface = current_surface.create_entity(param)

	if not electric_interface then
		return
	end

	electric_interface.minable = false
	electric_interface.destructible = false

	local railgun_id = railgun.unit_number

	disable_railgun(railgun, electric_interface)

	local info = {
		entity = railgun,
		electric_interface_id = electric_interface.unit_number,
	}

	storage.railgun.manager.railguns[railgun_id or 0] = info

	if railgun_id then
		table.insert(storage.railgun.manager.state.queue, railgun_id)
	end

	storage.railgun.manager.electric_interfaces[electric_interface.unit_number] = electric_interface
end

---@param railgun LuaEntity
function ldinc_railgun_artillery.lib.script.manager.on_destroy_entity(railgun)
	if not railgun then
		return
	end

	if railgun.name ~= "ldinc-railgun-artillery" then
		return
	end

	local info = storage.railgun.manager.railguns[railgun.unit_number]

	if not info then
		return
	end

	local electric_interface = storage.railgun.manager.electric_interfaces[info.electric_interface_id]

	if electric_interface then
		storage.railgun.manager.electric_interfaces[electric_interface.unit_number] = nil

		electric_interface.destroy()
	end

	storage.railgun.manager.railguns[railgun.unit_number] = nil
	storage.railgun.manager.state.destroyed[railgun.unit_number] = true
end

---@param railgun? LuaEntity
function ldinc_railgun_artillery.lib.script.manager.on_trigger_fired_artillery(railgun)
	if not railgun or not railgun.valid then
		return
	end

	if railgun.name ~= "ldinc-railgun-artillery" then
		return
	end

	local info = storage.railgun.manager.railguns[railgun.unit_number]

	if not info then
		return
	end

	local electric_interface = storage.railgun.manager.electric_interfaces[info.electric_interface_id]

	if not electric_interface or not electric_interface.valid then
		return
	end

	electric_interface.energy = math.max(
		0,
		electric_interface.energy - ldinc_railgun_artillery.lib.features.energy_per_shot
	)

	if electric_interface.energy < ldinc_railgun_artillery.lib.features.energy_per_shot then
		disable_railgun(railgun, electric_interface)
	end
end
