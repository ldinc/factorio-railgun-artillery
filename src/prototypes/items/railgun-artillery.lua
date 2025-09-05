require("lib.constant")

--- [ldinc-railgun-artillery]
local item = table.deepcopy(data.raw["item"]["artillery-turret"])

item.name = "ldinc-railgun-artillery"
item.place_result = "ldinc-railgun-artillery"

data.extend({ item })

--- [ldinc-railgun-ammo-loaded]
local ammo = table.deepcopy(data.raw["ammo"]["artillery-shell"])

ammo.name = "ldinc-railgun-ammo-loaded"
ammo.ammo_type.action.action_delivery.trigger_fired_artillery = true
ammo.ammo_type.action.action_delivery.source_effects = nil
ammo.stack_size = ldinc_railgun_artillery.lib.features.stack_size

data.extend({ ammo })