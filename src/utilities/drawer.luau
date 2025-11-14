local module = {}

function module.new(objecttype: string, properties: {}): Drawing
	local Object = Drawing.new(objecttype)
	for property, value in pairs(properties or {}) do
		Object[property] = value
	end
	return Object
end

return module
