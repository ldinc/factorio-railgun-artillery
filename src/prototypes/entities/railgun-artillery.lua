require("lib.constant")
require("lib.features.all")

local hit_effects = require("__base__.prototypes.entity.hit-effects")
local sounds = require("__base__.prototypes.entity.sounds")

local circuit_connector_definitions = circuit_connector_definitions or {}
local default_circuit_wire_max_distance = default_circuit_wire_max_distance or 9


local gun = table.deepcopy(data.raw["gun"]["artillery-wagon-cannon"])
gun.name = ldinc_railgun_artillery.lib.constant.name.gun
gun.attack_parameters.ammo_categories = { ldinc_railgun_artillery.lib.constant.name.category }
gun.attack_parameters.cooldown = 60
gun.attack_parameters.range = ldinc_railgun_artillery.lib.features.radius
gun.attack_parameters.damage_modifier = 10
gun.attack_parameters.shell_particle = nil

local fire_sound_filename = "__ldinc_railgun_artillery__/sound/fire-sound.ogg"

if ldinc_railgun_artillery.lib.features.alt_sounds_enabled then
	fire_sound_filename = "__ldinc_railgun_artillery__/sound/fire-sound-alt.ogg"
end

gun.attack_parameters.sound = {
	switch_vibration_data =
	{
		filename = "__base__/sound/fight/artillery-shoots.bnvib",
		play_for = "everything"
	},
	game_controller_vibration_data =
	{
		low_frequency_vibration_intensity = 1,
		duration = 150,
		play_for = "everything"
	},
	filename = fire_sound_filename,
	volume = 0.9,
	modifiers = volume_multiplier("main-menu", 0.9)
}

data.extend({
	gun,
})

---@type data.ArtilleryTurretPrototype
local artillery = {
	type = "artillery-turret",
	name = ldinc_railgun_artillery.lib.constant.name.artillery,
	icon = "__ldinc_railgun_artillery__/graphics/icons/railgun-artillery.png",
	flags = { "placeable-neutral", "placeable-player", "player-creation" },
	inventory_size = 1,
	ammo_stack_limit = ldinc_railgun_artillery.lib.constant.ammo_stack_size,
	automated_ammo_count = ldinc_railgun_artillery.lib.constant.ammo_stack_size,
	alert_when_attacking = false,
	minable = { mining_time = 0.5, result = ldinc_railgun_artillery.lib.constant.name.artillery },
	fast_replaceable_group = "artillery-turret",
	open_sound = sounds.artillery_open,
	close_sound = sounds.artillery_close,
	mined_sound = sounds.deconstruct_large(0.8),
	rotating_sound =
	{
		sound = { filename = "__base__/sound/fight/artillery-rotation-loop.ogg", volume = 0.6 },
		stopped_sound = { filename = "__base__/sound/fight/artillery-rotation-stop.ogg" }
	},
	max_health = 4000,
	corpse = "artillery-turret-remnants",
	dying_explosion = "artillery-turret-explosion",
	collision_box = { { -1.2, -1.2 }, { 1.2, 1.2 } },
	selection_box = { { -1.5, -1.5 }, { 1.5, 1.5 } },
	drawing_box_vertical_extension = 3.5,
	damaged_trigger_effect = hit_effects.entity(),
	circuit_connector = circuit_connector_definitions["artillery-turret"],
	circuit_wire_max_distance = default_circuit_wire_max_distance,
	gun = ldinc_railgun_artillery.lib.constant.name.gun,
	turret_rotation_speed = 0.005,
	turn_after_shooting_cooldown = 10,
	cannon_parking_frame_count = 8,
	cannon_parking_speed = 2,
	manual_range_modifier = 2.0,
	resistances =
	{
		{
			type = "fire",
			decrease = 15,
			percent = 50
		},
		{
			type = "physical",
			decrease = 15,
			percent = 30
		},
		{
			type = "impact",
			decrease = 50,
			percent = 50
		},
		{
			type = "explosion",
			decrease = 15,
			percent = 30
		},
		{
			type = "acid",
			decrease = 3,
			percent = 20
		}
	},

	base_picture_render_layer = "lower-object-above-shadow",
	base_picture =
	{
		layers =
		{
			{
				filename = "__ldinc_railgun_artillery__/graphics/entity/railgun-artillery/artillery-turret-base.png",
				priority = "high",
				line_length = 1,
				width = 207,
				height = 199,
				scale = 0.5
			},
			{
				filename = "__ldinc_railgun_artillery__/graphics/entity/railgun-artillery/artillery-turret-base-shadow.png",
				priority = "high",
				line_length = 1,
				width = 277,
				height = 149,
				shift = util.by_pixel(18, 16),
				draw_as_shadow = true,
				scale = 0.5
			}
		}
	},

	cannon_base_shift = { 0.0, 0.0, 0.9722 }, -- ENU
	cannon_base_pictures =
	{
		layers =
		{
			util.sprite_load("__ldinc_railgun_artillery__/graphics/entity/base",
				{
					dice = 4,
					priority = "very-low",
					allow_low_quality_rotation = false,
					direction_count = 256,
					scale = 0.75,
					apply_projection = false
				}
			),
			util.sprite_load("__ldinc_railgun_artillery__/graphics/entity/shadows",
				{
					dice = 4,
					priority = "very-low",
					allow_low_quality_rotation = true,
					draw_as_shadow = true,
					direction_count = 256,
					scale = 0.7
				}
			)
		}
	},

	water_reflection =
	{
		pictures =
		{
			filename = "__base__/graphics/entity/artillery-turret/artillery-turret-reflection.png",
			priority = "extra-high",
			width = 28,
			height = 32,
			shift = util.by_pixel(0, 75),
			variation_count = 1,
			scale = 5
		},
		rotate = false,
		orientation_to_variation = false
	}
}

artillery.name = "ldinc-railgun-artillery"

artillery.ammo_stack_limit = ldinc_railgun_artillery.lib.constant.ammo_stack_size
artillery.automated_ammo_count = ldinc_railgun_artillery.lib.constant.ammo_stack_size

artillery.gun = "ldinc-artillery-railgun-cannon"
artillery.minable.result = "ldinc-railgun-artillery"

artillery.localised_description = {
	"ldinc_railgun_artillery_info", "mid-level"
}

artillery.next_upgrade = nil

data.extend(
	{
		artillery,
	}
)
