--// Functions
local function cast(service: string): any
	return game:GetService(service)
end

--// Initialize
local module = {}
setmetatable(module, {
	__index = function(table, key)
		return cast(key)
	end,
})
return module
