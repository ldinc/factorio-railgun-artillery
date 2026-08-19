if not ldinc_railgun_artillery then ldinc_railgun_artillery = {} end
if not ldinc_railgun_artillery.lib then ldinc_railgun_artillery.lib = {} end
if not ldinc_railgun_artillery.lib.script then ldinc_railgun_artillery.lib.script = {} end
if not ldinc_railgun_artillery.lib.script.manager then ldinc_railgun_artillery.lib.script.manager = {} end
if not ldinc_railgun_artillery.lib.script.manager.status then ldinc_railgun_artillery.lib.script.manager.status = {} end

require("lib.features.all")
require("lib.constant")
require("lib.features.energy")

local status = ldinc_railgun_artillery.lib.script.manager.status

local ARTILLERY_NAME = ldinc_railgun_artillery.lib.constant.name.artillery
local ENERGY_LIMIT = ldinc_railgun_artillery.lib.features.energy_per_shot
		* ldinc_railgun_artillery.lib.features.stack_size
local ENERGY_PER_SHOT = ldinc_railgun_artillery.lib.features.energy_per_shot

local ENERGY_DIVISOR, ENERGY_UNIT, ENERGY_FORMAT = ldinc_railgun_artillery.lib.features.energy.scale(ENERGY_LIMIT)

local CHARGE_FORMAT = string.format(
	"[img=virtual-signal.%%s] [color=%%s]%%s[/color][color=#3b3b3b]%%s[/color]\n%s / %s %s (%%.0f%%%%)",
	ENERGY_FORMAT,
	ENERGY_FORMAT,
	ENERGY_UNIT
)

local TOOLTIP_TICKS = 30

local BAR_GLYPH = "█"
local BAR_SEGMENTS = 12

local COLOR_LOW = "#DA0801"
local COLOR_MID = "#FFD249"
local COLOR_FULL = "#00EB00"

--- [charge_value]
---@param energy double
---@return string
local function charge_value(energy)
	local ratio = energy / ENERGY_LIMIT

	if ratio < 0 then ratio = 0 end
	if ratio > 1 then ratio = 1 end

	local icon = "signal-battery-mid-level"
	local color = COLOR_MID

	if energy < ENERGY_PER_SHOT then
		icon = "signal-battery-low"
		color = COLOR_LOW
	elseif ratio >= 0.999 then
		icon = "signal-battery-full"
		color = COLOR_FULL
	end

	local filled = math.floor(ratio * BAR_SEGMENTS + 0.5)

	if filled == 0 and energy > 0 then
		filled = 1
	end

	return string.format(
		CHARGE_FORMAT,
		icon,
		color,
		string.rep(BAR_GLYPH, filled),
		string.rep(BAR_GLYPH, BAR_SEGMENTS - filled),
		energy / ENERGY_DIVISOR,
		ENERGY_LIMIT / ENERGY_DIVISOR,
		ratio * 100
	)
end

--- [status_label]
---@param label LocalisedString
---@param energy double?
---@return LocalisedString
local function status_label(label, energy)
	if energy == nil then
		return label
	end

	if storage.railgun and storage.railgun.tooltip_fields ~= false then
		return label
	end

	return { "", label, "  ", charge_value(energy) }
end

--- [set_status]
---@param railgun LuaEntity
---@param info Railgun_Info
---@param key string
---@param diode defines.entity_status_diode
---@param label LocalisedString
---@param energy double?
local function set_status(railgun, info, key, diode, label, energy)
	local cache_key = key

	if energy ~= nil and storage.railgun and storage.railgun.tooltip_fields == false then
		cache_key = key .. string.format(":%.0f", energy / ENERGY_DIVISOR)
	end

	if info.status_key == cache_key then
		return
	end

	info.status_key = cache_key

	railgun.custom_status = {
		diode = diode,
		label = status_label(label, energy),
	}
end

---@param railgun LuaEntity
---@param info Railgun_Info
---@param electric_interface? LuaEntity
---@param energy double?
---@param connected boolean? already known by the caller, queried here when omitted
function status.disable(railgun, info, electric_interface, energy, connected)
	if not railgun.valid then
		return
	end

	railgun.disabled_by_script = true

	if electric_interface and electric_interface.valid then
		if connected == nil then
			connected = electric_interface.is_connected_to_electric_network()
		end

		if not connected then
			set_status(railgun, info, "no-power", defines.entity_status_diode.red,
				{ "entity-status.no-power" }, energy)

			return
		end

		if electric_interface.energy < ENERGY_PER_SHOT then
			set_status(railgun, info, "low-power", defines.entity_status_diode.red,
				{ "entity-status.low-power" }, energy)

			return
		end
	end

	set_status(railgun, info, "charging", defines.entity_status_diode.yellow,
		{ "entity-status.charging" }, energy)
end

---@param railgun LuaEntity
---@param info Railgun_Info
---@param energy double?
function status.enable(railgun, info, energy)
	railgun.disabled_by_script = false

	set_status(railgun, info, "ready", defines.entity_status_diode.green,
		{ "description.ldinc_railgun_artillery_status_ready" }, energy)
end

--- [update_charge_tooltip]
---@param railgun LuaEntity
---@param info Railgun_Info
---@param energy double
local function update_charge_tooltip(railgun, info, energy)
	if info.tooltip_field_id == false then
		return
	end

	if not railgun.valid then
		return
	end

	if info.tooltip_tick and game.tick - info.tooltip_tick < TOOLTIP_TICKS then
		return
	end

	info.tooltip_tick = game.tick

	local value = charge_value(energy)

	if info.tooltip_value == value then
		return
	end

	info.tooltip_value = value

	--- NOTE: reading a non existing property of a LuaObject raises an error, so the whole
	--- call is wrapped instead of checking for the method.
	local ok, id = pcall(function()
		return railgun.set_tooltip_field({
			id = info.tooltip_field_id,
			name = { "ldinc_railgun_artillery_charge" },
			value = value,
			order = 1,
		})
	end)

	if not storage.railgun.tooltip_fields then
		storage.railgun.tooltip_fields = ok
	end

	if ok and type(id) == "number" then
		info.tooltip_field_id = id
	else
		info.tooltip_field_id = false
	end
end

--- [update_tooltips]
function ldinc_railgun_artillery.lib.script.manager.update_tooltips()
	for _, player in pairs(game.connected_players) do
		local selected = player.selected

		if selected and selected.valid and selected.name == ARTILLERY_NAME then
			local info = storage.railgun.manager.railguns[selected.unit_number or 0]

			if info then
				local unit = storage.railgun.manager.electric_interfaces[info.electric_interface_id]

				if unit and unit.valid then
					update_charge_tooltip(selected, info, unit.energy)
				end
			end
		end
	end
end
