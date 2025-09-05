require("util")
require("__core__.lualib.mod-gui")

require("lib.features.all")
require("lib.constant")
require("lib.scripts.init")
require("lib.scripts.load")
require("lib.scripts.runtime_settings_changed")
require("lib.scripts.gui")

script.on_init(
	ldinc_railgun_artillery.lib.script.on_init
)

script.on_load(
	function()
		if storage and storage.railgun_manager then
			storage.railgun.manager = storage.railgun_manager
		end
	end
)

script.on_event(
	defines.events.on_runtime_mod_setting_changed,
	ldinc_railgun_artillery.lib.script.on_runtime_mod_setting_changed
)

--- const block
local stack_size = ldinc_railgun_artillery.lib.features.stack_size
local energy_per_shot = ldinc_railgun_artillery.lib.features.energy_per_shot
local energy_limit = energy_per_shot * stack_size

local ticks_to_update = {
	state = ldinc_railgun_artillery.lib.features.ticks.update,
	gui = ldinc_railgun_artillery.lib.features.ticks.gui,
}

---@param event EventData.on_built_entity | EventData.on_robot_built_entity | EventData.script_raised_built
function on_build(event)
	ldinc_railgun_artillery.lib.script.manager.on_built_entity(event.entity)
end

---@param event EventData.on_robot_mined_entity | EventData.on_player_mined_entity | EventData.on_entity_died | EventData.script_raised_destroy
function on_deconstruct(event)
	ldinc_railgun_artillery.lib.script.manager.on_destroy_entity(event.entity)
end

script.on_event(
	{
		defines.events.on_built_entity,
		defines.events.on_robot_built_entity,
		defines.events.script_raised_built,
		defines.events.script_raised_revive,
		defines.events.on_space_platform_built_entity,
	},
	on_build
)

script.on_event(
	{
		defines.events.on_robot_mined_entity,
		defines.events.on_player_mined_entity,
		defines.events.on_entity_died,
		defines.events.script_raised_destroy,
		defines.events.on_space_platform_mined_entity,
	},
	on_deconstruct
)


script.on_event(
	defines.events.on_trigger_fired_artillery,
	function(event)
		if event then
			ldinc_railgun_artillery.lib.script.manager.on_trigger_fired_artillery(event.source)
		end
	end
)

script.on_nth_tick(
	ticks_to_update.state,
	function()
		ldinc_railgun_artillery.lib.script.manager.state_update()
	end
)

script.on_nth_tick(
	ticks_to_update.gui,
	function()
		ldinc_railgun_artillery.lib.script.manager.update_ui()
	end
)

script.on_event(
	defines.events.on_gui_opened,
	function(event)
		if event.entity == nil then return end

		if event.gui_type == defines.gui_type.entity and event.entity.name == 'ldinc-railgun-artillery' then
			local player = game.players[event.player_index]

			ldinc_railgun_artillery.lib.script.gui.make_extension(player, event.entity, energy_limit)
		end
	end
)

script.on_event(defines.events.on_gui_closed, function(event)
	if event.gui_type == defines.gui_type.entity and event.entity.name == 'ldinc-railgun-artillery' then
		local player = game.players[event.player_index]

		ldinc_railgun_artillery.lib.script.gui.destroy_extension(player)
	end
end
)
