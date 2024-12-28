if not ldinc_railgun_artillery then ldinc_railgun_artillery = {} end
if not ldinc_railgun_artillery.lib then ldinc_railgun_artillery.lib = {} end
if not ldinc_railgun_artillery.lib.script then ldinc_railgun_artillery.lib.script = {} end

require("lib.scripts.manager")

function ldinc_railgun_artillery.lib.script.on_init()
	ldinc_railgun_artillery.lib.script.manager.new()
end

