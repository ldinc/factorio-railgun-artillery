--- Runs once when a save made with an older version of this mod is loaded.
---
--- NOTE: migration scripts run in the same lua state as control.lua and before
--- on_configuration_changed, so this only fixes up the stored data. The hidden power units
--- themselves are recreated by manager.rebuild() from on_configuration_changed afterwards.
ldinc_railgun_artillery.lib.script.migration.to_0_1_9()
