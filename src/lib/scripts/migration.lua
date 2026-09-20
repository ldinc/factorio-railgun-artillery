if not ldinc_railgun_artillery then ldinc_railgun_artillery = {} end
if not ldinc_railgun_artillery.lib then ldinc_railgun_artillery.lib = {} end
if not ldinc_railgun_artillery.lib.script then ldinc_railgun_artillery.lib.script = {} end
if not ldinc_railgun_artillery.lib.script.migration then ldinc_railgun_artillery.lib.script.migration = {} end

require("lib.features.all")
require("lib.constant")
require("lib.scripts.manager")

local MOD_NAME = "ldinc_railgun_artillery"

local migration = ldinc_railgun_artillery.lib.script.migration

---@param message string
local function report(message)
	log("[" .. MOD_NAME .. "] " .. message)
end

--- [version_as_number]
--- "0.1.10" -> 10010, so versions can be compared without string parsing at every call site.
---@param version string?
---@return integer
local function version_as_number(version)
	if type(version) ~= "string" then
		return 0
	end

	local major, minor, patch = string.match(version, "^(%d+)%.(%d+)%.(%d+)")

	if not major then
		return 0
	end

	return tonumber(major) * 1000000 + tonumber(minor) * 10000 + tonumber(patch)
end

function migration.normalize()
	if not storage.railgun then
		storage.railgun = {}
	end

	--- <= 0.1.8 kept the manager in a top level key for a while
	if not storage.railgun.manager and storage.railgun_manager then
		storage.railgun.manager = storage.railgun_manager

		report("moved legacy storage.railgun_manager into storage.railgun.manager")
	end

	storage.railgun_manager = nil

	if not storage.railgun.manager then
		ldinc_railgun_artillery.lib.script.manager.new()
	end

	--- render object ids, see manager/visuals
	storage.railgun.visuals = storage.railgun.visuals or { glows = {}, icons = {} }
	storage.railgun.visuals.glows = storage.railgun.visuals.glows or {}
	storage.railgun.visuals.icons = storage.railgun.visuals.icons or {}
	storage.railgun.tooltips = storage.railgun.tooltips or {}
	storage.railgun.tooltip_fields = nil

	local m = storage.railgun.manager

	m.railguns = m.railguns or {}
	m.electric_interfaces = m.electric_interfaces or {}
	m.ui = m.ui or {}

	m.state = m.state or {}
	m.state.queue = m.state.queue or {}
	m.state.destroyed = nil
	m.state.current = m.state.current or 0
	m.state.limit = ldinc_railgun_artillery.lib.features.entities_per_update
end

function migration.to_0_1_9()
	migration.normalize()

	local m = storage.railgun.manager
	local count = 0

	for _, info in pairs(m.railguns) do
		--- render objects are not kept in storage any more
		info.charge_animation = nil

		--- fields added in 0.1.9
		info.charging = nil
		info.status_key = nil
		info.tooltip_field_id = nil

		count = count + 1
	end

	--- redetected on the first hover
	storage.railgun.tooltip_fields = nil

	report(string.format(
		"0.1.9: cleaned %d railgun record(s), buffers start empty because the old accumulator entities were dropped with their prototype",
		count
	))
end

--- [on_configuration_changed]
---@param event ConfigurationChangedData
function migration.on_configuration_changed(event)
	migration.normalize()

	local change = event and event.mod_changes and event.mod_changes[MOD_NAME]
	local from = change and change.old_version or storage.railgun.version
	local to = script.active_mods[MOD_NAME]

	if from and version_as_number(from) < version_as_number(to) then
		report(string.format("updating from %s to %s", tostring(from), tostring(to)))
	end

	if event and event.mod_startup_settings_changed then
		report("startup settings changed, power units are rebuilt")
	end

	ldinc_railgun_artillery.lib.script.manager.rebuild()

	storage.railgun.version = to
end

--- [on_init]
function migration.on_init()
	migration.normalize()

	storage.railgun.version = script.active_mods[MOD_NAME]
end
