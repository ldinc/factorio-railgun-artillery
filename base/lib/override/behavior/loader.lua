local loader = require('lib.entity.loader')
local mod_settings = require('lib.settings.mod')

local set_stack = function (loader_name, size)
	local target = data.raw["loader-1x1"][loader_name]

	if target then
		target.max_belt_stack_size = size
	end
end

local size = mod_settings.get_belt_stack_size()

for _, name in pairs(loader) do
	set_stack(name, size)
end