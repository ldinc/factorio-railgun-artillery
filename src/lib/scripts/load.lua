if not ldinc_railgun_artillery then ldinc_railgun_artillery = {} end
if not ldinc_railgun_artillery.lib then ldinc_railgun_artillery.lib = {} end
if not ldinc_railgun_artillery.lib.script then ldinc_railgun_artillery.lib.script = {} end

function ldinc_railgun_artillery.lib.script.on_load()
  if not ldinc_railgun_artillery.storage then
    ldinc_railgun_artillery.storage = {}
  end

  ldinc_railgun_artillery.storage.manager = storage.railgun.manager
end
