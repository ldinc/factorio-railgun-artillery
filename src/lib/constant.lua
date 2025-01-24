if not ldinc_railgun_artillery then ldinc_railgun_artillery = {} end
if not ldinc_railgun_artillery.lib then ldinc_railgun_artillery.lib = {} end
if not ldinc_railgun_artillery.lib.constant then ldinc_railgun_artillery.lib.constant = {} end
if not ldinc_railgun_artillery.lib.constant.name then ldinc_railgun_artillery.lib.constant.name = {} end

require("util")

ldinc_railgun_artillery.lib.constant.energy_per_shot = util.parse_energy("10MJ")
ldinc_railgun_artillery.lib.constant.ammo_stack_size = 10

ldinc_railgun_artillery.lib.constant.colors = {
	yellow = util.color("#FFD249"),
	red = util.color("#DA0801"),
	green = util.color("#00EB00"),
}

ldinc_railgun_artillery.lib.constant.name.artillery = "ldinc-railgun-artillery"
ldinc_railgun_artillery.lib.constant.name.gun = "ldinc-artillery-railgun-cannon"