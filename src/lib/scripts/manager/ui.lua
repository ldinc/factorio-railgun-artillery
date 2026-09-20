if not ldinc_railgun_artillery then ldinc_railgun_artillery = {} end
if not ldinc_railgun_artillery.lib then ldinc_railgun_artillery.lib = {} end
if not ldinc_railgun_artillery.lib.script then ldinc_railgun_artillery.lib.script = {} end
if not ldinc_railgun_artillery.lib.script.manager then ldinc_railgun_artillery.lib.script.manager = {} end

require("lib.features.all")
require("lib.constant")
require("lib.features.energy")

---@class Railgun_UI_State
---@field player_index integer
---@field progressbar LuaGuiElement
---@field statusbar LuaGuiElement
---@field railgun_id integer

--- NOTE:
--- Well. With multiplayer game you need to wait server ack that  gui still opened...
--- So there is anoying lag with adding extra frame to entity. Sad.
--- https://forums.factorio.com/viewtopic.php?t=90795

---@param state Railgun_UI_State
function ldinc_railgun_artillery.lib.script.manager.register_opened_ui(state)
	if not state or not state.progressbar or not state.progressbar.valid then
		return
	end

	if not state.progressbar.valid or not state.statusbar.valid then
		return
	end

	local info = storage.railgun.manager.railguns[state.railgun_id]

	if not info then
		return
	end

	if not storage.railgun.manager.electric_interfaces[info.electric_interface_id] then
		return
	end

	storage.railgun.manager.ui[state.player_index] = {
		player_index = state.player_index,
		railgun_id = state.railgun_id,
		progressbar = state.progressbar,
		statusbar = state.statusbar,
		electric_interface_id = info.electric_interface_id
	}
end

---@param player_index integer
function ldinc_railgun_artillery.lib.script.manager.register_closed_ui(player_index)
	storage.railgun.manager.ui[player_index] = nil
end

--- check if ui updates > 256... drop table?
function ldinc_railgun_artillery.lib.script.manager.update_ui()
	ldinc_railgun_artillery.lib.script.manager.update_tooltips()

	local stack_size = ldinc_railgun_artillery.lib.features.stack_size
	local energy_per_shot = ldinc_railgun_artillery.lib.features.energy_per_shot
	local energy_limit = energy_per_shot * stack_size

	for player_index, state in pairs(storage.railgun.manager.ui) do
		if not state then
			ldinc_railgun_artillery.lib.script.manager.register_closed_ui(player_index)

			goto continue
		end

		if not game.get_player(player_index) then
			ldinc_railgun_artillery.lib.script.manager.register_closed_ui(player_index)

			goto continue
		end

		local electric_interface = storage.railgun.manager.electric_interfaces[state.electric_interface_id]

		if not electric_interface or not electric_interface.valid then goto continue end

		local progress = electric_interface.energy / energy_limit

		if state.progressbar and state.progressbar.valid then
			state.progressbar.value = progress

			local color = ldinc_railgun_artillery.lib.constant.colors.red

			if electric_interface.energy > energy_per_shot then
				color = ldinc_railgun_artillery.lib.constant.colors.yellow
			end

			if electric_interface.energy > energy_limit / 2 then
				color = ldinc_railgun_artillery.lib.constant.colors.green
			end

			state.progressbar.style.color = color
		end

		if not state.statusbar or not state.statusbar.valid then goto continue end

		state.statusbar.caption = string.format(
			"%s/%s",
			ldinc_railgun_artillery.lib.features.energy.format(electric_interface.energy),
			ldinc_railgun_artillery.lib.features.energy.format(energy_limit)
		)

		::continue::
	end
end
