require("lib.features.all")
require("lib.constant")

---@param event any
---@param message string
local function out(event, message)
	local player = event.player_index and game.get_player(event.player_index)

	if player then
		player.print(message)
	else
		game.print(message)
	end

	log("[ldinc_railgun_artillery] " .. message)
end

commands.add_command(
	"ldinc-railgun-animation",
	"Turns the railgun charge animation on or off at runtime: /ldinc-railgun-animation [on|off]",
	function(event)
		if not storage.railgun then
			storage.railgun = {}
		end

		local argument = event.parameter and string.lower(string.gsub(event.parameter, "%s", "")) or ""

		if argument == "on" then
			storage.railgun.animation_off = nil
		elseif argument == "off" then
			storage.railgun.animation_off = true
		elseif argument == "" then
			--- no argument: toggle
			storage.railgun.animation_off = not storage.railgun.animation_off or nil
		else
			out(event, "usage: /ldinc-railgun-animation [on|off]")

			return
		end

		if not ldinc_railgun_artillery.lib.features.charge_animation_enabled then
			out(event, "the startup setting \"Show charging animation\" is off, nothing is drawn either way")

			return
		end

		local enabled = ldinc_railgun_artillery.lib.script.manager.animation_enabled()

		if not enabled then
			ldinc_railgun_artillery.lib.script.manager.reset_glows()
		end

		out(event, string.format("charge animation %s", enabled and "on" or "off"))
	end
)

commands.add_command(
	"ldinc-railgun-alert",
	"Turns the no electricity icon on or off: /ldinc-railgun-alert [on|off]",
	function(event)
		local setting_name = "ldinc_railgun_artillery_no_power_alert"
		local current = settings.global[setting_name]
		local enabled = current == nil or current.value == true

		local argument = event.parameter and string.lower(string.gsub(event.parameter, "%s", "")) or ""

		if argument == "on" then
			enabled = true
		elseif argument == "off" then
			enabled = false
		elseif argument == "" then
			--- no argument: toggle
			enabled = not enabled
		else
			out(event, "usage: /ldinc-railgun-alert [on|off]")

			return
		end

		--- writing the map setting keeps the command and the settings gui in sync
		settings.global[setting_name] = { value = enabled }

		if not enabled then
			local cleared = ldinc_railgun_artillery.lib.script.manager.clear_no_power_icons()

			out(event, string.format("no electricity icon off, %d icon(s) removed", cleared))

			return
		end

		out(event, "no electricity icon on")
	end
)
