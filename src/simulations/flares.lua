-- Tips and tricks simulation, update script: runs every tick as a silent console command
-- inside the simulation, so no require and none of the mod's own Lua is reachable.
--
-- Every 90 ticks the old flare is cleared and a new one is set at the same spot. Each turret
-- gets one chance per cycle: one that is still charging visibly skips a cycle instead of
-- working through a backlog of flares later.

if game.tick % 90 ~= 0 then
	return
end

local surface = game.surfaces[1]

for _, flare in pairs(surface.find_entities_filtered({ name = "artillery-flare" })) do
	flare.destroy()
end

surface.create_entity({
	name = "artillery-flare",
	position = { 30, 0 },
	force = "player",
	movement = { 0, 0 },
	height = 0,
	vertical_speed = 0,
	frame_speed = 1,
})
