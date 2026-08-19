if not ldinc_railgun_artillery then ldinc_railgun_artillery = {} end
if not ldinc_railgun_artillery.lib then ldinc_railgun_artillery.lib = {} end
if not ldinc_railgun_artillery.lib.script then ldinc_railgun_artillery.lib.script = {} end
if not ldinc_railgun_artillery.lib.script.manager then ldinc_railgun_artillery.lib.script.manager = {} end
if not ldinc_railgun_artillery.lib.script.manager.visuals then ldinc_railgun_artillery.lib.script.manager.visuals = {} end

require("lib.features.all")
require("lib.constant")

local visuals = ldinc_railgun_artillery.lib.script.manager.visuals

local CHARGE_ANIMATION = ldinc_railgun_artillery.lib.constant.name.animation.charge
local DISCHARGE_ANIMATION = ldinc_railgun_artillery.lib.constant.name.animation.discharge
local ANIMATION_ENABLED = ldinc_railgun_artillery.lib.features.charge_animation_enabled

local ALERT_ICON_OFFSET = { 1.05, -1.05 }
local ALERT_ICON_SCALE = 0.45

---@type number?
local viewer_range_sqr = 96 * 96

local alert_enabled = true

--- [animation_enabled]
---@return boolean
local function animation_enabled()
	if not ANIMATION_ENABLED then
		return false
	end

	return not (storage.railgun and storage.railgun.animation_off)
end

visuals.animation_enabled = animation_enabled
ldinc_railgun_artillery.lib.script.manager.animation_enabled = animation_enabled

---@type { surface: uint, x: double, y: double }[]
local viewers = {}

--- [refresh_viewers]
local function refresh_viewers()
	viewers = {}

	for _, player in pairs(game.connected_players) do
		--- player.position follows remote view, which is what is actually on screen
		viewers[#viewers + 1] = {
			surface = player.surface.index,
			x = player.position.x,
			y = player.position.y,
		}
	end
end

---@param railgun LuaEntity?
---@return boolean
local function is_on_screen(railgun)
	if viewer_range_sqr == nil then
		return true
	end

	if not railgun then
		return false
	end

	local surface = railgun.surface.index
	local position = railgun.position

	for i = 1, #viewers do
		local viewer = viewers[i]

		if viewer.surface == surface then
			local dx = viewer.x - position.x
			local dy = viewer.y - position.y

			if dx * dx + dy * dy <= viewer_range_sqr then
				return true
			end
		end
	end

	return false
end

---@param kind string "glows" | "icons"
---@return table<integer, uint64>
local function store(kind)
	if not storage.railgun then
		storage.railgun = {}
	end

	local tracked = storage.railgun.visuals

	if not tracked then
		tracked = { glows = {}, icons = {} }

		storage.railgun.visuals = tracked
	end

	tracked[kind] = tracked[kind] or {}

	return tracked[kind]
end

--- [object_of]
--- nil when the id is unknown or the object is gone, in which case it is simply drawn again.
---@param ids table<integer, uint64>
---@param railgun_id integer
---@return LuaRenderObject?
local function object_of(ids, railgun_id)
	local id = ids[railgun_id]

	if not id then
		return nil
	end

	local object = rendering.get_object_by_id(id)

	if object and object.valid then
		return object
	end

	return nil
end

--- [reset_glows]
function ldinc_railgun_artillery.lib.script.manager.reset_glows()
	local tracked = storage.railgun and storage.railgun.visuals

	if tracked then
		tracked.glows = {}
		tracked.icons = {}
	end

	rendering.clear("ldinc_railgun_artillery")
end

--- [clear_no_power_icons]
---@return integer
function ldinc_railgun_artillery.lib.script.manager.clear_no_power_icons()
	local ids = store("icons")
	local cleared = 0

	for railgun_id in pairs(ids) do
		local object = object_of(ids, railgun_id)

		if object then
			object.destroy()

			cleared = cleared + 1
		end

		ids[railgun_id] = nil
	end

	return cleared
end

---@return integer
function ldinc_railgun_artillery.lib.script.manager.glow_count()
	local ids = store("glows")
	local count = 0

	for railgun_id in pairs(ids) do
		if object_of(ids, railgun_id) then
			count = count + 1
		end
	end

	return count
end

--- [apply_charge_glow]
---@param railgun LuaEntity?
---@param railgun_id integer
---@param wanted boolean
local function apply_charge_glow(railgun, railgun_id, wanted)
	local ids = store("glows")
	local object = object_of(ids, railgun_id)

	if wanted == (object ~= nil) then
		return
	end

	if not wanted then
		if object then
			object.destroy()
		end

		ids[railgun_id] = nil

		return
	end

	if railgun then
		local created = rendering.draw_animation({
			animation = CHARGE_ANIMATION,
			surface = railgun.surface,
			target = { entity = railgun },
			render_layer = "higher-object-above",
			animation_speed = 0.5,
			--- no time_to_live: it runs until the charging state changes
		})

		ids[railgun_id] = created and created.id or nil
	end
end

--- [apply_no_power_icon]
---@param railgun LuaEntity?
---@param railgun_id integer
---@param wanted boolean
local function apply_no_power_icon(railgun, railgun_id, wanted)
	local ids = store("icons")
	local object = object_of(ids, railgun_id)

	if wanted == (object ~= nil) then
		return
	end

	if not wanted then
		if object then
			object.destroy()
		end

		ids[railgun_id] = nil

		return
	end

	if railgun then
		local created = rendering.draw_sprite({
			sprite = "utility/electricity_icon_unplugged",
			surface = railgun.surface,
			target = { entity = railgun, offset = ALERT_ICON_OFFSET },
			render_layer = "entity-info-icon-above",
			x_scale = ALERT_ICON_SCALE,
			y_scale = ALERT_ICON_SCALE,
			--- no time_to_live: it stays until the railgun is powered again
		})

		ids[railgun_id] = created and created.id or nil
	end
end

--- [set_no_power]
---@param railgun LuaEntity
---@param railgun_id integer
---@param connected boolean
function visuals.set_no_power(railgun, railgun_id, connected)
	apply_no_power_icon(
		railgun,
		railgun_id,
		not connected and alert_enabled and is_on_screen(railgun)
	)
end

--- [play_discharge]
---@param railgun LuaEntity
function visuals.play_discharge(railgun)
	if not animation_enabled() then
		return
	end

	if not railgun or not railgun.valid then
		return
	end

	rendering.draw_animation({
		animation = DISCHARGE_ANIMATION,
		surface = railgun.surface,
		target = { entity = railgun },
		render_layer = "higher-object-above",
		animation_speed = 0.5,
		time_to_live = 48,
	})
end

--- [set_charge]
---@param railgun LuaEntity?
---@param railgun_id integer
---@param charging boolean
function visuals.set_charge(railgun, railgun_id, charging)
	apply_charge_glow(railgun, railgun_id, charging and animation_enabled() and is_on_screen(railgun))
end

--- [clear]
---@param railgun_id integer
function visuals.clear(railgun_id)
	apply_charge_glow(nil, railgun_id, false)
	apply_no_power_icon(nil, railgun_id, false)
end

--- [refresh]
function visuals.refresh()
	local radius_setting = settings.global["ldinc_railgun_artillery_animation_radius"]
	local radius = radius_setting and radius_setting.value or 96

	viewer_range_sqr = radius > 0 and radius * radius or nil

	local alert_setting = settings.global["ldinc_railgun_artillery_no_power_alert"]

	alert_enabled = alert_setting == nil or alert_setting.value == true

	refresh_viewers()
end
