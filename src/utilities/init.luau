--// Variables
local services = require(script.services)

local utility = {}

--// Initialize

function utility.ProtectUI(gui)
	if gethui then
		gui.Parent = gethui()
		return gethui()
	elseif syn and syn.protect_gui then
		syn.protect_gui(gui)
		return services.CoreGui
	elseif not services.RunService:IsStudio() and services.CoreGui:FindFirstChild("RobloxGui") then
		gui.Parent = services.CoreGui:FindFirstChild("RobloxGui")
		return services.CoreGui:FindFirstChild("RobloxGui")
	else
		if not services.RunService:IsStudio() then
			gui.Parent = services.CoreGui
			return services.CoreGui
		else
			gui.Parent = services.Players.LocalPlayer.PlayerGui
			return services.Players.LocalPlayer.PlayerGui
		end
	end
end

function utility.Kwargify(array, defaults)
	array = array or {}
	for defaultprop, defaultvalue in pairs(defaults) do
		if array[defaultprop] == nil then
			array[defaultprop] = defaultvalue
		end
	end
	return array
end

return utility
