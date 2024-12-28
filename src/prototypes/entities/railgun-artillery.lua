require("lib.constant")

local gun = table.deepcopy(data.raw["gun"]["artillery-wagon-cannon"])
gun.name = "ldinc-artillery-railgun-cannon"
gun.attack_parameters.cooldown = 60
gun.attack_parameters.range = 400
gun.attack_parameters.damage_modifier = 10

data.extend({
  gun,
})

local artillery = table.deepcopy(data.raw["artillery-turret"]["artillery-turret"])

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

