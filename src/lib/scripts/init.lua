if not ldinc_railgun_artillery then ldinc_railgun_artillery = {} end
if not ldinc_railgun_artillery.lib then ldinc_railgun_artillery.lib = {} end
if not ldinc_railgun_artillery.lib.script then ldinc_railgun_artillery.lib.script = {} end

require("lib.scripts.manager")
require("lib.scripts.migration")

function ldinc_railgun_artillery.lib.script.on_init()
	ldinc_railgun_artillery.lib.script.manager.new()
	ldinc_railgun_artillery.lib.script.migration.on_init()
end
