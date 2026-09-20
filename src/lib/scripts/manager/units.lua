if not ldinc_railgun_artillery then ldinc_railgun_artillery = {} end
if not ldinc_railgun_artillery.lib then ldinc_railgun_artillery.lib = {} end
if not ldinc_railgun_artillery.lib.script then ldinc_railgun_artillery.lib.script = {} end
if not ldinc_railgun_artillery.lib.script.manager then ldinc_railgun_artillery.lib.script.manager = {} end

require("lib.features.all")
require("lib.constant")
require("lib.scripts.gui")
require("lib.scripts.manager.visuals")
require("lib.scripts.manager.status")

local visuals = ldinc_railgun_artillery.lib.script.manager.visuals
local status = ldinc_railgun_artillery.lib.script.manager.status

local ARTILLERY_NAME = ldinc_railgun_artillery.lib.constant.name.artillery
local POWER_UNIT_NAME = ldinc_railgun_artillery.lib.constant.name.power_unit
local ENERGY_PER_SHOT = ldinc_railgun_artillery.lib.features.energy_per_shot

local function create_power_unit(railgun)
	---@type LuaSurface.create_entity_param
	local param = {
		name = POWER_UNIT_NAME,
		position = { railgun.position.x, railgun.position.y },
		force = railgun.force,
	}

	local power_unit = railgun.surface.create_entity(param)

	if not power_unit then
		return nil
	end

	power_unit.minable_flag = false
	power_unit.destructible = false

	return power_unit
end

--- [attach_power_unit]
---@param railgun LuaEntity
---@param stored_energy double?
---@return LuaEntity?
local function attach_power_unit(railgun, stored_energy)
	local power_unit = create_power_unit(railgun)

	if not power_unit then
		return nil
	end

	if stored_energy and stored_energy > 0 then
		local buffer = power_unit.electric_buffer_size or stored_energy

		power_unit.energy = math.min(stored_energy, buffer)
	end

	local railgun_id = railgun.unit_number or 0
	local previous_info = storage.railgun.manager.railguns[railgun_id]
	local known = previous_info ~= nil

	storage.railgun.manager.railguns[railgun_id] = {
		entity = railgun,
		electric_interface_id = power_unit.unit_number,
	}

	storage.railgun.manager.electric_interfaces[power_unit.unit_number] = power_unit
	storage.railgun.manager.state.destroyed[railgun_id] = nil

	if railgun.unit_number and not known then
		table.insert(storage.railgun.manager.state.queue, railgun.unit_number)
	end

	if railgun.unit_number then
		script.register_on_object_destroyed(railgun)
	end

	return power_unit
end

---@param railgun LuaEntity
function ldinc_railgun_artillery.lib.script.manager.on_built_entity(railgun)
	if railgun.name ~= ARTILLERY_NAME then
		return
	end

	local power_unit = attach_power_unit(railgun)

	if not power_unit then
		return
	end

	local info = storage.railgun.manager.railguns[railgun.unit_number or 0]

	if info then
		status.disable(railgun, info, power_unit)
	end
end

--- [ensure_power_unit]
--- Returns the power unit of a railgun, recreating it when it went missing.
---@param railgun LuaEntity
---@return LuaEntity?
function ldinc_railgun_artillery.lib.script.manager.ensure_power_unit(railgun)
	if not railgun or not railgun.valid then
		return nil
	end

	if railgun.name ~= ARTILLERY_NAME then
		return nil
	end

	local info = storage.railgun.manager.railguns[railgun.unit_number or 0]

	if info then
		local known_unit = storage.railgun.manager.electric_interfaces[info.electric_interface_id]

		if known_unit and known_unit.valid then
			return known_unit
		end

		storage.railgun.manager.electric_interfaces[info.electric_interface_id] = nil
	end

	--- an orphaned power unit may still sit under the turret, keep its charge
	local stored_energy = nil

	for _, orphan in pairs(railgun.surface.find_entities_filtered({
		name = POWER_UNIT_NAME,
		position = railgun.position,
		radius = 1,
	})) do
		if orphan.valid then
			stored_energy = math.max(stored_energy or 0, orphan.energy)

			storage.railgun.manager.electric_interfaces[orphan.unit_number] = nil

			orphan.destroy()
		end
	end

	local power_unit = attach_power_unit(railgun, stored_energy)

	local fresh_info = storage.railgun.manager.railguns[railgun.unit_number or 0]

	if power_unit and fresh_info then
		status.disable(railgun, fresh_info, power_unit)
	end

	return power_unit
end

---@param railgun_id integer?
---@return boolean removed
function ldinc_railgun_artillery.lib.script.manager.forget(railgun_id)
	if not railgun_id then
		return false
	end

	local info = storage.railgun.manager.railguns[railgun_id]

	if not info then
		return false
	end

	local electric_interface = storage.railgun.manager.electric_interfaces[info.electric_interface_id]

	if electric_interface then
		storage.railgun.manager.electric_interfaces[info.electric_interface_id] = nil

		if electric_interface.valid then
			electric_interface.destroy()
		end
	end

	visuals.clear(railgun_id)

	status.tooltip_ids()[railgun_id] = nil

	storage.railgun.manager.railguns[railgun_id] = nil
	storage.railgun.manager.state.destroyed[railgun_id] = true

	return true
end

---@param railgun LuaEntity
function ldinc_railgun_artillery.lib.script.manager.on_destroy_entity(railgun)
	if not railgun or not railgun.valid then
		return
	end

	if railgun.name ~= ARTILLERY_NAME then
		return
	end

	ldinc_railgun_artillery.lib.script.manager.forget(railgun.unit_number)
end

---@param event EventData.on_object_destroyed
function ldinc_railgun_artillery.lib.script.manager.on_object_destroyed(event)
	if event.type ~= defines.target_type.entity then
		return
	end

	ldinc_railgun_artillery.lib.script.manager.forget(event.useful_id)
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

	info.last_energy = electric_interface.energy
	info.charging = false
	info.status_key = nil
	info.skip = nil

	visuals.clear(railgun.unit_number)

	visuals.play_discharge(railgun)

	if electric_interface.energy < ENERGY_PER_SHOT then
		status.disable(railgun, info, electric_interface, electric_interface.energy)
	end
end

--- [rebuild]
--- Rebuilds the whole manager state. Used on mod / setting changes: when the power unit
--- prototype changes its type the old hidden entities are dropped by the game, so every
--- railgun needs a fresh one.
function ldinc_railgun_artillery.lib.script.manager.rebuild()
	if not storage.railgun or not storage.railgun.manager then
		ldinc_railgun_artillery.lib.script.manager.new()
	end

	ldinc_railgun_artillery.lib.script.manager.reset_glows()

	local m = storage.railgun.manager

	---@type table<integer, double>
	local saved_energy = {}

	for railgun_id, info in pairs(m.railguns or {}) do
		if info.last_energy and info.last_energy > 0 then
			saved_energy[railgun_id] = info.last_energy
		end
	end

	for _, player in pairs(game.players) do
		ldinc_railgun_artillery.lib.script.gui.destroy_extension(player)
	end

	m.railguns = {}
	m.electric_interfaces = {}
	m.ui = {}
	m.state = {
		queue = {},
		destroyed = {},
		current = 0,
		limit = ldinc_railgun_artillery.lib.features.entities_per_update,
	}

	local railgun_count = 0
	local orphan_count = 0
	local tooltip_count = 0

	for _, surface in pairs(game.surfaces) do
		for _, railgun in pairs(surface.find_entities_filtered({ name = ARTILLERY_NAME })) do
			tooltip_count = tooltip_count + status.clear_charge_tooltips(railgun)

			local power_unit = ldinc_railgun_artillery.lib.script.manager.ensure_power_unit(railgun)

			if power_unit and power_unit.valid then
				railgun_count = railgun_count + 1

				local restore = saved_energy[railgun.unit_number or 0]

				if restore and power_unit.energy <= 0 then
					local buffer = power_unit.electric_buffer_size or restore

					power_unit.energy = math.min(restore, buffer)
				end
			end
		end

		for _, unit in pairs(surface.find_entities_filtered({ name = POWER_UNIT_NAME })) do
			if unit.valid and not m.electric_interfaces[unit.unit_number] then
				unit.destroy()

				orphan_count = orphan_count + 1
			end
		end
	end

	log(string.format(
		"[ldinc_railgun_artillery] rebuild: %d railgun(s) registered, %d orphaned power unit(s) removed, %d charge tooltip row(s) cleared",
		railgun_count,
		orphan_count,
		tooltip_count
	))
end
