-- Tips and tricks simulation, init script: runs once as a silent console command inside the
-- simulation (no require, the mod is reached only through the game - see overview.lua).
--
-- Scene: close-up of one railgun fed from two chests. Railgun shells come in from the left;
-- the chest of regular artillery shells on the right stays full, because the turret does not
-- accept them. No flares here, the turret only loads.

local surface = game.surfaces[1]
local force = "player" -- create_entity takes the force by name

-- needed for the glow, see overview.lua
local player = game.simulation.create_test_player({ name = "engineer" })
player.teleport({ -5, 5 })

-- one substation covers the turret and both inserters
local source = surface.create_entity({ name = "electric-energy-interface", position = { 4, -4 }, force = force })
source.power_production = 1e9 / 60
source.electric_buffer_size = 1e9 / 60

surface.create_entity({ name = "substation", position = { 0, -4 }, force = force })

surface.create_entity({
  name = "ldinc-railgun-artillery",
  position = { 0.5, 0.5 },
  force = force,
  raise_built = true,
}).artillery_auto_targeting = false

---@param key string
---@param position MapPosition
---@param alignment string
local function label(key, position, alignment)
  rendering.draw_text({
    text = { "ldinc-railgun-artillery-tips." .. key },
    surface = surface,
    target = position,
    color = { 1, 1, 1 },
    scale = 1.2,
    scale_with_zoom = true,
    alignment = alignment,
    vertical_alignment = "middle",
  })
end

--- A chest and an inserter pointing from it into the turret.
---@param chest_x number
---@param inserter_x number
---@param y number
---@param item string
local function feed(chest_x, inserter_x, y, item)
  local chest = surface.create_entity({ name = "iron-chest", position = { chest_x, y }, force = force })
  chest.insert({ name = item, count = 20 })

  local inserter = surface.create_entity({
    name = "fast-inserter",
    position = { inserter_x, y },
    force = force,
    direction = defines.direction.east,
  })

  -- Which way "direction" counts for inserters is easy to get backwards, so check where
  -- it actually picks up from and turn it round if that is not the chest.
  local chest_is_west = chest_x < inserter_x
  local picks_west = inserter.pickup_position.x < inserter.position.x

  if picks_west ~= chest_is_west then
    inserter.direction = defines.direction.west
  end
end

feed(-2.5, -1.5, -0.5, "ldinc-railgun-ammo-loaded")
feed(3.5, 2.5, 1.5, "artillery-shell")

label("railgun-shells", { -4, -0.5 }, "right")
label("artillery-shells", { 5, 1.5 }, "left")

game.simulation.camera_position = { 0.5, 0.5 }
game.simulation.camera_zoom = 1.2
