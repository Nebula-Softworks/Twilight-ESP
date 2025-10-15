local root = require("@root")
local services = require("@root/utilities/services")

local Players = services.Players
local UserInputService = services.UserInputService
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local functions = {}

function functions:GetTracerOrigin()
	local origin = root.Settings.Tracer.Origin
	if origin == 2 then
		return Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
	elseif origin == 3 then
		return Vector2.new(Camera.ViewportSize.X / 2, 0)
	elseif origin == 4 then
		return Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
	elseif origin == 5 then
		return UserInputService:GetMouseLocation()
	else
		return Camera:WorldToViewportPoint(LocalPlayer.Character.HumanoidRootPart.Position)
	end
end

function functions:GetPlayerType(Player)
	local teamType
	if Player.Neutral then
		teamType = "generic"
	else
		if Player.TeamColor == LocalPlayer.TeamColor then
			teamType = "friendly"
		else
			teamType = "enemy"
		end
	end

	if Player == LocalPlayer then
		teamType = "self"
	end
	return teamType
end

function functions:GetPlayerColor(Player, isVisible, part, additional)
	local teamType
	if Player.Neutral then
		teamType = "generic"
	else
		if Player.TeamColor == LocalPlayer.TeamColor then
			teamType = "friendly"
		else
			teamType = "enemy"
		end
	end

	if Player == LocalPlayer then
		teamType = "self"
	end

	if part == "HealthBar" and additional == "Fill" then
		local maxHealth = Player.Character.Humanoid.MaxHealth
		local currentHealth = Player.Character.Humanoid.Health
		local currentStatus
		if currentHealth / maxHealth > 65 / 100 then
			currentStatus = "High"
		elseif currentHealth / maxHealth > 20 / 100 then
			currentStatus = "Medium"
		else
			currentStatus = "Low"
		end
		return root.Settings.currentColors[teamType].HealthBar.Fills[currentStatus]
	end

	if root.Settings.Checks.Visible.Enabled and not isVisible then
		if additional then
			return root.Settings.currentColors[teamType][part][additional].Invisible
		else
			return root.Settings.currentColors[teamType][part].Invisible
		end
	else
		if additional then
			return root.Settings.currentColors[teamType][part][additional].Visible
		else
			return root.Settings.currentColors[teamType][part].Visible
		end
	end
end

function functions:GetBoxCorners(cf, size)
	local corners = {
		Vector3.new(-size.X / 2, -size.Y / 2, -size.Z / 2),
		Vector3.new(-size.X / 2, -size.Y / 2, size.Z / 2),
		Vector3.new(-size.X / 2, size.Y / 2, -size.Z / 2),
		Vector3.new(-size.X / 2, size.Y / 2, size.Z / 2),
		Vector3.new(size.X / 2, -size.Y / 2, -size.Z / 2),
		Vector3.new(size.X / 2, -size.Y / 2, size.Z / 2),
		Vector3.new(size.X / 2, size.Y / 2, -size.Z / 2),
		Vector3.new(size.X / 2, size.Y / 2, size.Z / 2),
	}

	for i, corner in ipairs(corners) do
		corners[i] = cf:PointToWorldSpace(corner)
	end

	return corners
end

function functions:Kwargify(defaults, passed)
	defaults = defaults or {}
	passed = passed or {}
	for i, v in pairs(defaults) do
		if passed[i] == nil then
			passed[i] = v
		end
	end
	return passed -- incase smth went wrong
end

return functions
