-- Tips and tricks simulation, init script: runs once as a silent console command inside the
-- simulation (no require, the mod is reached only through the game - see overview.lua).
--
-- Scene: three railguns side by side, all aimed at the same flare (see flares.lua).
--   top     plenty of power  - fires every cycle, charges back almost at once
--   middle  5 MW supply      - glows most of the time and fires every other cycle
--   bottom  no pole at all   - shows the unplugged icon and never fires
-- Each has its own pole, 11 tiles apart, beyond a medium pole's wire reach, so the three
-- networks stay separate.

local surface = game.surfaces[1]
local force = "player" -- create_entity takes the force by name

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

-- needed for the glow and the unplugged icon, see overview.lua
local player = game.simulation.create_test_player({ name = "engineer" })
player.teleport({ -20, 14 })

---@param key string
---@param position MapPosition
local function label(key, position)
	rendering.draw_text({
		text = { "ldinc-railgun-artillery-tips." .. key },
		surface = surface,
		target = position,
		color = { 1, 1, 1 },
		scale = 1.5,
		scale_with_zoom = true,
		alignment = "right",
		vertical_alignment = "middle",
	})
end

---@param x number
---@param y number
---@param watts number? nil builds no pole and no source
local function railgun(x, y, watts)
	if watts then
		surface.create_entity({ name = "medium-electric-pole", position = { x + 3, y + 2 }, force = force })

		local source = surface.create_entity({
			name = "electric-energy-interface",
			position = { x + 4.5, y + 3.5 },
			force = force,
		})

		-- the buffer equals one tick of production, so the source cannot dump stored energy
		-- faster than its rating
		source.power_production = watts / 60
		source.electric_buffer_size = watts / 60
	end

	local turret = surface.create_entity({
		name = "ldinc-railgun-artillery",
		position = { x, y },
		force = force,
		raise_built = true,
	})

	turret.artillery_auto_targeting = false
	turret.insert({ name = "ldinc-railgun-ammo-loaded", count = 10 })
end

railgun(-28.5, -10.5, 1e9)
railgun(-28.5, 0.5, 5e6)
railgun(-28.5, 11.5, nil)

label("strong-supply", { -33, -10.5 })
label("weak-supply", { -33, 0.5 })
label("no-supply", { -33, 11.5 })

game.simulation.camera_position = { 0, 0 }
game.simulation.camera_zoom = 0.55
