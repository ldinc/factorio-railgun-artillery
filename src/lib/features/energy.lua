if not ldinc_railgun_artillery then ldinc_railgun_artillery = {} end
if not ldinc_railgun_artillery.lib then ldinc_railgun_artillery.lib = {} end
if not ldinc_railgun_artillery.lib.features then ldinc_railgun_artillery.lib.features = {} end
if not ldinc_railgun_artillery.lib.features.energy then ldinc_railgun_artillery.lib.features.energy = {} end

local energy = ldinc_railgun_artillery.lib.features.energy

---@type { [1]: number, [2]: string }[]
local UNITS = {
	{ 1e15, "PJ" },
	{ 1e12, "TJ" },
	{ 1e9,  "GJ" },
	{ 1e6,  "MJ" },
	{ 1e3,  "kJ" },
}

--- [scale]
--- Picks one unit for a whole range of values, so that a pair like "46.6 / 500 MJ" is written
--- with a single unit instead of mixing kJ and MJ.
---@param reference double
---@return number divisor
---@return string unit
---@return string number_format one decimal below 100 units, none above
function energy.scale(reference)
	local divisor = 1
	local unit = "J"

	for index = 1, #UNITS do
		if reference >= UNITS[index][1] then
			divisor = UNITS[index][1]
			unit = UNITS[index][2]

			break
		end
	end

	return divisor, unit, reference / divisor >= 100 and "%.0f" or "%.1f"
end

--- [format]
--- Single value with its own unit
---@param value double
---@return string
function energy.format(value)
	local divisor, unit, number_format = energy.scale(value)

	return string.format(number_format .. " %s", value / divisor, unit)
end

---@param value double
---@param reference double
---@return string
function energy.format_pair(value, reference)
	local divisor, unit, number_format = energy.scale(reference)

	return string.format(
		number_format .. "/" .. number_format .. " %s",
		value / divisor,
		reference / divisor,
		unit
	)
end
