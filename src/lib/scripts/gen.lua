if not ldinc_railgun_artillery then ldinc_railgun_artillery = {} end
if not ldinc_railgun_artillery.lib then ldinc_railgun_artillery.lib = {} end
if not ldinc_railgun_artillery.lib.script then ldinc_railgun_artillery.lib.script = {} end
if not ldinc_railgun_artillery.lib.script.gen then ldinc_railgun_artillery.lib.script.gen = {} end

--- @param name string
--- @param icon string?
--- @return data.AmmoItemPrototype
function ldinc_railgun_artillery.lib.script.gen.shell_item(name, icon)
	local ammo = table.deepcopy(data.raw["ammo"]["artillery-shell"])

	ammo.name = name
	ammo.ammo_type.action.action_delivery.trigger_fired_artillery = true
	ammo.ammo_type.action.action_delivery.source_effects = nil

	ammo.ammo_type.action.action_delivery.projectile = "railgun-artillery-projectile"

	ammo.stack_size = ldinc_railgun_artillery.lib.features.stack_size

	if not icon then
		ammo.icon = "__ldinc_railgun_artillery__/graphics/icons/shell-body.png"
	else
		ammo.icon = "__ldinc_railgun_artillery__/graphics/icons/"..icon
	end

	return ammo
end

--- @param name string
--- @param content (data.FluidIngredientPrototype|data.ItemIngredientPrototype)[]?
--- @param icon string?
--- @return data.RecipePrototype
function ldinc_railgun_artillery.lib.script.gen.shell_recipe(name, content, icon)
	---@type data.RecipePrototype
	recipe = {
		type = "recipe",
		name = name,
		-- icon = "__ldinc_railgun_artillery__/graphics/entity/shell/shell-body.png",
		ingredients = {
			-- {
			-- 	type = "item",
			-- 	name = "artillery-shell",
			-- 	amount = 1,
			-- },
			{
				type = "item",
				name = ldinc_railgun_artillery.lib.constant.name.shell.body,
				amount = 1,
			},
		},
		main_product = name,
		results = {
			{
				type = "item",
				name = name,
				amount = 1,
			},
		},
		energy_required = 2,
	}

	if icon then
		recipe.icon = icon
	end

	if content then
		for _, c in ipairs(content) do
			table.insert(recipe.ingredients, c)
		end
	end

	return recipe
end