local espInstance = require(script.Parent.espInstance)
local types = require(script.Parent.Parent.types)
local root = require(script.Parent.Parent.contract)

local module = require(script.Parent.objectEspContract)

function module:new(object)
	local rootPart = object
	if object:IsA("Model") then
		rootPart = object:FindFirstChildWhichIsA("Part")
	end
	local objectEsp = {
		boundedTo = object,
	} :: types.objectEsp

	local esp = espInstance:Create(object, rootPart)

	objectEsp.instance = esp

	-- TODO add skeleton esp

	function objectEsp.Update()
		esp:Update()
	end

	table.insert(root._connections, object.Changed:Connect(objectEsp.Update))
	table.insert(root._connections, workspace.CurrentCamera.Changed:Connect(objectEsp.Update))

	root.espObjects[object] = objectEsp
	return objectEsp
end

return module
