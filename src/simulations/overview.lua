-- Tips and tricks simulation, init script: runs once as a silent console command inside the
-- simulation. No require, and the mod's own Lua state is out of reach: the only way to the
-- mod is through the game, which is why the railgun is built with raise_built - that event is
-- what attaches its power unit.
--
-- Scene: one powered railgun on the left firing at a flare 60 tiles to the right
-- (see flares.lua). Charge glow, discharge flash, flight and impact in one view.

local surface = game.surfaces[1]
local force = "player" -- create_entity takes the force by name

-- the default lab checkerboard is 40 x 30; a shot needs somewhere to land
local tiles = {}

for x = -48, 47 do
	for y = -16, 15 do
		tiles[#tiles + 1] = {
			name = (x + y) % 2 == 0 and "lab-dark-1" or "lab-dark-2",
			position = { x, y },
		}
	end
end

surface.set_tiles(tiles)

-- The mod draws its charge glow and unplugged icon only near a connected player, and a
-- simulation has no players until one is made.
local player = game.simulation.create_test_player({ name = "engineer" })
player.teleport({ -33, 5 })

-- a strong supply: 1 GW, far more than one turret can take
local source = surface.create_entity({ name = "electric-energy-interface", position = { -26, 4 }, force = force })
source.power_production = 1e9 / 60
source.electric_buffer_size = 1e9 / 60

surface.create_entity({ name = "medium-electric-pole", position = { -27.5, 2.5 }, force = force })

local railgun = surface.create_entity({
	name = "ldinc-railgun-artillery",
	position = { -30.5, 0.5 },
	force = force,
	raise_built = true,
})

-- only the flares decide when it fires
railgun.artillery_auto_targeting = false
railgun.insert({ name = "ldinc-railgun-ammo-loaded", count = 10 })

game.simulation.camera_position = { 0, 0 }
game.simulation.camera_zoom = 0.6
