local module = {}

function module.New(objecttype: string, properties: {}): Drawing
	local Object = Drawing.new(objecttype)
	for property, value in pairs(properties) do
		Object[property] = value
	end
	return Object
end

return module
