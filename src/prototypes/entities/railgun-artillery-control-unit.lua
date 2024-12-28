require("lib.features.all")

-- local cu = table.deepcopy(data.raw["assembling-machine"]["assembling-machine-1"])

-- cu.name = "ldinc-railgun-artillery-control-unit"

-- cu.crafting_categories = { "ldinc-railgun-artillery-control-unit" }
-- cu.energy_usage = "50MW"
-- cu.crafting_speed = 1.0
-- cu.ingredient_count = 2
-- cu.fixed_recipe = "ldinc-railgun-artillery-control-unit-loading"
-- cu.fluid_boxes = {
-- 	{
-- 		production_type = "input",
-- 		pipe_picture = assembler2pipepictures(),
-- 		pipe_covers = pipecoverspictures(),
-- 		volume = 1000,
-- 		filter = "fluoroketone-cold",
-- 		pipe_connections = { { flow_direction = "input", direction = defines.direction.south, position = { 1, 1 } } },
-- 		secondary_draw_orders = { north = -1 }
-- 	},
-- 	{
-- 		production_type = "output",
-- 		pipe_picture = assembler2pipepictures(),
-- 		pipe_covers = pipecoverspictures(),
-- 		filter = "fluoroketone-hot",
-- 		volume = 1000,
-- 		pipe_connections = { { flow_direction = "output", direction = defines.direction.south, position = { -1, 1 } } },
-- 		secondary_draw_orders = { north = -1 }
-- 	},
-- }

-- cu.ingredient_count = 1

-- -- cu.selection_box = {{0,0}, {0,0}}

-- data.extend(
-- 	{
-- 		cu,
-- 	}
-- )

local eu = table.deepcopy(data.raw["accumulator"]["accumulator"])

local cap = ldinc_railgun_artillery.lib.features.energy_per_shot * ldinc_railgun_artillery.lib.features.stack_size
local flow_limit = ldinc_railgun_artillery.lib.features.energy_per_shot*3/60

eu.name = "ldinc-railgun-artillery-power-unit"
eu.energy_source.buffer_capacity = tostring(cap).."J"
eu.energy_source.drain = "0J"
eu.energy_source.input_flow_limit = tostring(flow_limit).."J"
eu.energy_source.output_flow_limit = "0J"

-- eu.chargable_graphics = nil
eu.tile_width = 3
eu.tile_height = 3

eu.selection_box = {{0, 0}, {0, 0}}
eu.circuit_connector = nil

data.extend({eu})