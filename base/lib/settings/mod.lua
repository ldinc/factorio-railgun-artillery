local mod_settings = {}

function mod_settings.get_belt_stack_size()
  local default = 1
  local v = settings.startup["ldinc_overhaul_belt_stack_count"].value

  if v then
    return tonumber(v)
  end

  return default
end

return mod_settings