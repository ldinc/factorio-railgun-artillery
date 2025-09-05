if not ldinc_railgun_artillery then ldinc_railgun_artillery = {} end
if not ldinc_railgun_artillery.lib then ldinc_railgun_artillery.lib = {} end
if not ldinc_railgun_artillery.lib.features then ldinc_railgun_artillery.lib.features = {} end

-- require("util")
require("lib.features.extractor")

local get_int = ldinc_railgun_artillery.lib.features.startup.get_int_value_from_setting

--- MJ -> J
ldinc_railgun_artillery.lib.features.energy_per_shot = get_int(
	"ldinc_railgun_artillery_energy_per_shot",
	10
) * 1000000

ldinc_railgun_artillery.lib.features.stack_size = get_int(
	"ldinc_railgun_artillery_stack_size",
	10
)

ldinc_railgun_artillery.lib.features.entities_per_update = get_int(
	"ldinc_railgun_artillery_entities_per_update",
	50
)

ldinc_railgun_artillery.lib.features.ticks = {
	gui = get_int("ldinc_railgun_artillery_ticks_per_gui_update", 5),
	update = get_int("ldinc_railgun_artillery_ticks_per_entities_update", 20),
}
