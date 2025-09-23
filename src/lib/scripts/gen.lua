if not ldinc_railgun_artillery then ldinc_railgun_artillery = {} end
if not ldinc_railgun_artillery.lib then ldinc_railgun_artillery.lib = {} end
if not ldinc_railgun_artillery.lib.script then ldinc_railgun_artillery.lib.script = {} end
if not ldinc_railgun_artillery.lib.script.gen then ldinc_railgun_artillery.lib.script.gen = {} end

require("lib.constant")
require("lib.features.all")

function ldinc_railgun_artillery.lib.script.gen.modify_damage(target)
	if target and target.action then
		ldinc_railgun_artillery.lib.script.gen.modify_damage(target.action)
	end

	if target and target.action_delivery then
		ldinc_railgun_artillery.lib.script.gen.modify_damage(target.action_delivery)
	end

	if target and target.target_effects then
		for _, effect in ipairs(target.target_effects) do
			ldinc_railgun_artillery.lib.script.gen.modify_damage(effect)
		end
	end

	if target and target.type == "damage" and target.damage and target.damage.amount then
		target.damage.amount = target.damage.amount * ldinc_railgun_artillery.lib.features.scale.damage
	end
end

---@param source_name string
---@return data.ArtilleryProjectilePrototype?
function ldinc_railgun_artillery.lib.script.gen.copy_of_projectile(source_name)
	local name = "ldinc_railgun_artillery-" .. source_name

	local result = data.raw["artillery-projectile"][name]

	if result then
		return result
	end

	local source = data.raw["artillery-projectile"][source_name]

	if not source then
		return nil
	end

	result = table.deepcopy(data.raw["artillery-projectile"]["railgun-artillery-projectile"])

	result.name = name

	result.action = table.deepcopy(source.action)
	result.final_action = table.deepcopy(source.final_action)

	log(serpent.block(result))

	ldinc_railgun_artillery.lib.script.gen.modify_damage(result.action)
	ldinc_railgun_artillery.lib.script.gen.modify_damage(result.final_action)

	data:extend({ result })

	return result
end

--- @param name string
--- @param icon string?
--- @return data.AmmoItemPrototype?
function ldinc_railgun_artillery.lib.script.gen.shell_item(name, icon, from_ammo, from_projectile)
	if not from_projectile then
		from_projectile = "artillery-projectile"
	end

	if not from_ammo then
		from_ammo = "artillery-shell"
	end

	local ammo = table.deepcopy(data.raw["ammo"][from_ammo])

	local projectile = ldinc_railgun_artillery.lib.script.gen.copy_of_projectile(from_projectile)

	if projectile then
		ammo.ammo_type.action.action_delivery.projectile = projectile.name
	end

	ammo.name = name
	ammo.ammo_category = ldinc_railgun_artillery.lib.constant.name.category
	ammo.ammo_type.action.action_delivery.trigger_fired_artillery = true
	ammo.ammo_type.action.action_delivery.source_effects = nil

	-- ammo.ammo_type.action.action_delivery.projectile = "railgun-artillery-projectile"

	ammo.stack_size = ldinc_railgun_artillery.lib.features.stack_size


	local ico = "__ldinc_railgun_artillery__/graphics/icons/shell-body.png"

	if icon then
		ico = "__ldinc_railgun_artillery__/graphics/icons/" .. icon
	end
	if ammo.icons then
		ammo.icons = { { icon = ico } }
	else
		if ammo.icon then
			ammo.icon = ico
		end
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
		ingredients = {
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
			if c.amount then
				c.amount = c.amount * ldinc_railgun_artillery.lib.features.scale.recipe
			end

			table.insert(recipe.ingredients, c)
		end
	end

	return recipe
end
