--// Variables
local services = require(script.services)

local utility = {}

--// Initialize

function utility.ProtectUI(gui: Instance): ScreenGui
	local success = nil
	local returned = false

	if gethui then
		gui.Parent = gethui()
	elseif syn and syn.protect_gui then
		syn.protect_gui(gui)

		gui.Parent = services.CoreGui
	elseif not services.RunService:IsStudio() and services.CoreGui:FindFirstChild("RobloxGui") then
		gui.Parent = services.CoreGui:FindFirstChild("RobloxGui")
	else
		success = false

		if not services.RunService:IsStudio() then
			gui.Parent = services.CoreGui
			returned = "No Protection Methods Available."
		else
			gui.Parent = services.Players.LocalPlayer.PlayerGui
			returned = "Environment invalid - isStudio"
		end
	end

	return success and gui or returned
end

return utility
