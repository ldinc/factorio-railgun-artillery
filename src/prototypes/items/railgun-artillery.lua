require("lib.constant")
require("lib.scripts.gen")

local item_sounds = require("__base__.prototypes.item_sounds")

--- [ldinc-railgun-artillery]
local item = table.deepcopy(data.raw["item"]["artillery-turret"])

item.name = "ldinc-railgun-artillery"
item.place_result = "ldinc-railgun-artillery"

data.extend({ item })


--- [ldinc-railgun-artillery-shell-body]
---@type data.ItemPrototype
local body = {
	type = "item",
	name = ldinc_railgun_artillery.lib.constant.name.shell.body,
	icon = "__ldinc_railgun_artillery__/graphics/entity/shell/shell-body-icon.png",
	subgroup = "intermediate-product",
	order = "d[railgun-artillery-parts]-a[body]",
	inventory_move_sound = item_sounds.low_density_inventory_move,
	pick_sound = item_sounds.low_density_inventory_pickup,
	drop_sound = item_sounds.low_density_inventory_move,
	stack_size = 50,
	weight = 20 * kg
}

data.extend({ body })

--- [ldinc-railgun-ammo-loaded]
-- local ammo = table.deepcopy(data.raw["ammo"]["artillery-shell"])

-- ammo.name = "ldinc-railgun-ammo-loaded"
-- ammo.ammo_type.action.action_delivery.trigger_fired_artillery = true
-- ammo.ammo_type.action.action_delivery.source_effects = nil

-- -- railgun-artillery-projectile

-- ammo.ammo_type.action.action_delivery.projectile = "railgun-artillery-projectile"
-- ammo.stack_size = ldinc_railgun_artillery.lib.features.stack_size
-- ammo.icon = "__ldinc_railgun_artillery__/graphics/icons/shell-body.png"

data.extend({
	ldinc_railgun_artillery.lib.script.gen.shell_item("ldinc-railgun-ammo-loaded")
})
