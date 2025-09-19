require("lib.constant")

---@type data.AmmoCategory
local category = {
	type = "ammo-category",
	name = ldinc_railgun_artillery.lib.constant.name.category,
	icon = ldinc_railgun_artillery.lib.constant.path.icon,
	subgroup = "ammo-category",
	bonus_gui_order = "o"
}

data:extend({ category })
