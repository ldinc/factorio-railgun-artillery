require("lib.constant")

local hit_effects = require("__base__.prototypes.entity.hit-effects")
local sounds = require("__base__.prototypes.entity.sounds")

local circuit_connector_definitions = circuit_connector_definitions or {}
local default_circuit_wire_max_distance = default_circuit_wire_max_distance or 9

local gun = table.deepcopy(data.raw["gun"]["artillery-wagon-cannon"])
gun.name = ldinc_railgun_artillery.lib.constant.name.gun
gun.attack_parameters.cooldown = 60
gun.attack_parameters.range = 400
gun.attack_parameters.damage_modifier = 10

data.extend({
  gun,
})

local artillery = {
  type = "artillery-turret",
  name = ldinc_railgun_artillery.lib.constant.name.artillery,
  icon = "__ldinc_railgun_artillery__/graphics/icons/railgun-artillery.png",
  flags = {"placeable-neutral", "placeable-player", "player-creation"},
  inventory_size = 1,
  ammo_stack_limit = ldinc_railgun_artillery.lib.constant.ammo_stack_size,
  automated_ammo_count = ldinc_railgun_artillery.lib.constant.ammo_stack_size,
  alert_when_attacking = false,
  minable = {mining_time = 0.5, result = ldinc_railgun_artillery.lib.constant.name.artillery},
  fast_replaceable_group = "artillery-turret",
  open_sound = sounds.artillery_open,
  close_sound = sounds.artillery_close,
  mined_sound = sounds.deconstruct_large(0.8),
  rotating_sound =
  {
    sound = {filename = "__base__/sound/fight/artillery-rotation-loop.ogg", volume = 0.6},
    stopped_sound = {filename = "__base__/sound/fight/artillery-rotation-stop.ogg"}
  },
  max_health = 4000,
  corpse = "artillery-turret-remnants",
  dying_explosion = "artillery-turret-explosion",
  collision_box = {{-1.2, -1.2}, {1.2, 1.2}},
  selection_box = {{-1.5, -1.5}, {1.5, 1.5}},
  drawing_box_vertical_extension = 3.5,
  damaged_trigger_effect = hit_effects.entity(),
  circuit_connector = circuit_connector_definitions["artillery-turret"],
  circuit_wire_max_distance = default_circuit_wire_max_distance,
  gun = ldinc_railgun_artillery.lib.constant.name.gun,
  turret_rotation_speed = 0.005,
  turn_after_shooting_cooldown = 10,
  cannon_parking_frame_count = 8,
  cannon_parking_speed = 1,
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

  cannon_base_shift = {0.0, 0.0, 0.9722}, -- ENU
  cannon_barrel_pictures =
  {
    layers =
    {
      util.sprite_load("__base__/graphics/entity/artillery-wagon/artillery-wagon-cannon-barrel",
        {
          dice = 4,
          priority = "very-low",
          allow_low_quality_rotation = true,
          direction_count = 256,
          scale = 0.5
        }
      ),
      util.sprite_load("__base__/graphics/entity/artillery-wagon/artillery-wagon-cannon-barrel-shadow",
        {
          dice = 4,
          priority = "very-low",
          allow_low_quality_rotation = true,
          draw_as_shadow = true,
          direction_count = 256,
          scale = 0.5
        }
      )
    }
  },
  cannon_base_pictures =
  {
    layers =
    {
      util.sprite_load("__base__/graphics/entity/artillery-wagon/artillery-wagon-cannon-base",
        {
          dice = 4,
          priority = "very-low",
          allow_low_quality_rotation = true,
          direction_count = 256,
          scale = 0.5
        }
      ),
      util.sprite_load("__base__/graphics/entity/artillery-wagon/artillery-wagon-cannon-base-shadow",
        {
          dice = 4,
          priority = "very-low",
          allow_low_quality_rotation = true,
          draw_as_shadow = true,
          direction_count = 256,
          scale = 0.5
        }
      )
    }
  },
  cannon_barrel_recoil_shiftings =
  { -- East-North-Up (when cannon is facing North)
    {0.0100, -0.0000, -0.0000},
    {0.0093, -0.1973, -0.0878},
    {0.0088, -0.3945, -0.1755},
    {0.0083, -0.5918, -0.2635},
    {0.0078, -0.7888, -0.3513},
    {0.0070, -0.9860, -0.4390},
    {0.0070, -0.9828, -0.4375},
    {0.0070, -0.9753, -0.4343},
    {0.0073, -0.9635, -0.4290},
    {0.0073, -0.9475, -0.4220},
    {0.0073, -0.9278, -0.4130},
    {0.0073, -0.9043, -0.4025},
    {0.0075, -0.8770, -0.3905},
    {0.0075, -0.8463, -0.3768},
    {0.0075, -0.8123, -0.3618},
    {0.0078, -0.7755, -0.3453},
    {0.0078, -0.7360, -0.3278},
    {0.0080, -0.6940, -0.3090},
    {0.0080, -0.6498, -0.2893},
    {0.0083, -0.6040, -0.2690},
    {0.0083, -0.5565, -0.2478},
    {0.0085, -0.5080, -0.2263},
    {0.0085, -0.4588, -0.2043},
    {0.0088, -0.4088, -0.1820},
    {0.0088, -0.3590, -0.1598},
    {0.0090, -0.3095, -0.1378},
    {0.0093, -0.2605, -0.1160},
    {0.0093, -0.2128, -0.0948},
    {0.0095, -0.1663, -0.0740},
    {0.0095, -0.1213, -0.0540},
    {0.0098, -0.0785, -0.0350},
    {0.0098, -0.0380, -0.0170},
  },
  cannon_barrel_light_direction = {0.5976251, -0.0242053, -0.8014102}, -- ENU

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
artillery.turret_rotation_speed = 0.005
artillery.turn_after_shooting_cooldown = 10
artillery.cannon_parking_speed = 2

artillery.gun = "ldinc-artillery-railgun-cannon"
artillery.minable.result = "ldinc-railgun-artillery"

data.extend(
  {
    artillery,
  }
)

