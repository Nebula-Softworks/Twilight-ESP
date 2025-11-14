--// Functions
local function cast(service: string): any
	return cloneref and cloneref(game:GetService(service)) or game:GetService(service)
end

--// Initialize
local module = {}
setmetatable(module, {
	__index = function(table, key)
		return cast(key)
	end,
})
return module
