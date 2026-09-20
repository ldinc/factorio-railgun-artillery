if not ldinc_railgun_artillery then ldinc_railgun_artillery = {} end
if not ldinc_railgun_artillery.lib then ldinc_railgun_artillery.lib = {} end
if not ldinc_railgun_artillery.lib.script then ldinc_railgun_artillery.lib.script = {} end
if not ldinc_railgun_artillery.lib.script.manager then ldinc_railgun_artillery.lib.script.manager = {} end
if not ldinc_railgun_artillery.lib.script.manager.state then ldinc_railgun_artillery.lib.script.manager.state = {} end

require("lib.features.all")
require("lib.constant")
require("lib.scripts.manager.visuals")
require("lib.scripts.manager.status")

local visuals = ldinc_railgun_artillery.lib.script.manager.visuals
local status = ldinc_railgun_artillery.lib.script.manager.status

local ENERGY_LIMIT = ldinc_railgun_artillery.lib.features.energy_per_shot
		* ldinc_railgun_artillery.lib.features.stack_size
local ENERGY_PER_SHOT = ldinc_railgun_artillery.lib.features.energy_per_shot

--- how many update passes a railgun that is full and connected is allowed to sleep
local IDLE_SKIP = 2

---@param index int64
local function state_update_for_entity(index)
	local state = storage.railgun.manager.state
	local railgun_id = state.queue[index]

	if not railgun_id then
		return
	end

	local info = storage.railgun.manager.railguns[railgun_id]

	if not info then
		local last = #state.queue

		state.queue[index] = state.queue[last]
		state.queue[last] = nil

		return
	end

	if info.skip then
		if info.skip > 1 then
			info.skip = info.skip - 1

			return
		end

		info.skip = nil
	end

	local artillery = info.entity

	if not artillery or not artillery.valid then
		ldinc_railgun_artillery.lib.script.manager.forget(railgun_id)

		return
	end

	---@type LuaEntity?
	local electric_interface = storage.railgun.manager.electric_interfaces[info.electric_interface_id]

	if not electric_interface or not electric_interface.valid then
		electric_interface = ldinc_railgun_artillery.lib.script.manager.ensure_power_unit(artillery)

		if not electric_interface or not electric_interface.valid then
			return
		end
	end

	local energy = electric_interface.energy
	local previous = info.last_energy or 0

	info.last_energy = energy
	info.charging = energy > previous + 1 and energy < ENERGY_LIMIT - 1

	local connected = info.charging or electric_interface.is_connected_to_electric_network()

	visuals.set_charge(artillery, railgun_id, info.charging)

	visuals.set_no_power(artillery, railgun_id, connected)

	if energy >= ENERGY_PER_SHOT then
		status.enable(artillery, info, energy)
	else
		status.disable(artillery, info, electric_interface, energy, connected)
	end

	if connected and not info.charging and energy >= ENERGY_LIMIT - 1 then
		info.skip = IDLE_SKIP
	end
end

function ldinc_railgun_artillery.lib.script.manager.state_update()
	if not storage.railgun then return end
	if not storage.railgun.manager then return end
	if not storage.railgun.manager.state then return end

	local state = storage.railgun.manager.state
	local total_count = #state.queue

	if total_count == 0 then return end

	local budget = state.limit

	if budget > total_count then
		budget = total_count
	end

	visuals.refresh()

	local index = state.current

	for _ = 1, budget do
		index = index + 1

		if index > total_count then
			index = 1
		end

		state_update_for_entity(index)
	end

	state.current = index
end
