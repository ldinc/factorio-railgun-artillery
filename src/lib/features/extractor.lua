if not ldinc_railgun_artillery then ldinc_railgun_artillery = {} end
if not ldinc_railgun_artillery.lib then ldinc_railgun_artillery.lib = {} end
if not ldinc_railgun_artillery.lib.features then ldinc_railgun_artillery.lib.features = {} end
if not ldinc_railgun_artillery.lib.features.startup then ldinc_railgun_artillery.lib.features.startup = {} end

--- [get_int_value_from_startup_setting]
---@param setting_name string
---@param default_value int64?
---@return int64
function ldinc_railgun_artillery.lib.features.startup.get_int_value_from_setting(setting_name, default_value)
	if default_value == nil then
		default_value = 0
	end

	local value = default_value

	local v = settings.startup[setting_name].value

	if type(v) == "number" then
		return v
	end

	return value
end

--- [get_boolean_value_from_setting]
---@param setting_name string
---@param default_value boolean?
---@return boolean
function ldinc_railgun_artillery.lib.features.startup.get_boolean_value_from_setting(setting_name, default_value)
	if default_value == nil then
		default_value = false
	end

	local value = default_value

	local v = settings.startup[setting_name].value

	if type(v) == "boolean" then
		return v
	end

	return value
end