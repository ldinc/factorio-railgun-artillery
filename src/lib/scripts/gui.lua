if not ldinc_railgun_artillery then ldinc_railgun_artillery = {} end
if not ldinc_railgun_artillery.lib then ldinc_railgun_artillery.lib = {} end
if not ldinc_railgun_artillery.lib.script then ldinc_railgun_artillery.lib.script = {} end
if not ldinc_railgun_artillery.lib.script.gui then ldinc_railgun_artillery.lib.script.gui = {} end

require("lib.constant")

local frame_name = "ldinc_railgun_artillery_frame"
local progressbar_name = "ldinc_railgun_artillery_ui_progress"
local ui_stat_name = "ldinc_railgun_artillery_ui_stat"

---@param player LuaPlayer
---@param energy_limit int64
---@return LuaGuiElement, LuaGuiElement, LuaGuiElement
local function generate_frame(player, energy_limit)
	local anchor = {
		gui = defines.relative_gui_type.container_gui,
		position = defines.relative_gui_position.bottom,
	}

	local frame = player.gui.relative.add {
		type = "frame",
		name = frame_name,
		anchor = anchor,
		direction = "horizontal",
	}

	frame.style.width = 900 - 16

	local lbl = frame.add({
		type = "label",
		caption = "Accumulated energy",
	})

	lbl.style.font_color = ldinc_railgun_artillery.lib.constant.colors.yellow
	lbl.style.vertical_align = "center"
	lbl.style.margin = 4

	local progressbar = frame.add({
		type = "progressbar",
		name = progressbar_name,
		minimum_value = 0,
		maximum_value = 1,
	})

	-- progressbar.style.top_padding = 12
	progressbar.style.height = 8
	progressbar.style.margin = 4
	progressbar.style.top_margin = 12
	progressbar.style.horizontally_stretchable = true
	progressbar.style.color = ldinc_railgun_artillery.lib.constant.colors.yellow
	progressbar.style.vertical_align = "center"
	progressbar.value = 0.0

	local icon = frame.add({
		type = "sprite",
		sprite = "tooltip-category-electricity"
	})

	icon.style.margin = 4
	icon.style.top_padding = 6
	icon.style.vertical_align = "center"

	local statusbar = frame.add({
		type = "label",
		name = ui_stat_name,
		caption = string.format("%.1f/%.1f MJ", 0.0, energy_limit / 1000000),
	})

	statusbar.style.font_color = ldinc_railgun_artillery.lib.constant.colors.yellow
	statusbar.style.vertical_align = "center"
	statusbar.style.horizontal_align = "right"
	statusbar.style.width = 100
	statusbar.style.margin = 4

	return frame, progressbar, statusbar
end

--- make extension for existing artillery gui
---@param player LuaPlayer
---@param entity LuaEntity
---@param energy_limit int64
function ldinc_railgun_artillery.lib.script.gui.make_extension(player, entity, energy_limit)
	---@type LuaGuiElement
	local gui
	---@type LuaGuiElement
	local progressbar
	---@type LuaGuiElement
	local statusbar

	if not player.gui.relative[frame_name] then
		gui, progressbar, statusbar = generate_frame(player, energy_limit)
	else
		gui = player.gui.relative[frame_name]

		if gui then
			progressbar = gui[progressbar_name]
		end
	end

	ldinc_railgun_artillery.lib.script.manager.register_opened_ui({
		player_index = player.index,
		railgun_id = entity.unit_number,
		progressbar = progressbar,
		statusbar = statusbar,
	})
end

---@param player LuaPlayer
function ldinc_railgun_artillery.lib.script.gui.destroy_extension(player)
		local gui = player.gui.relative

		local elem = gui[frame_name]

		if elem then
			elem.destroy()
		end

		ldinc_railgun_artillery.lib.script.manager.register_closed_ui(player.index)
end
