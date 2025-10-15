local services = require("@root/utilities/services")

local Players = services.Players
local RunService = services.RunService
local UserInputService = services.UserInputService
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

local playerEsp = {}

-- TODO
-- set colors on update
-- set colors based on visible

function playerEsp:CreateESP(Library, Player)
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
		if
			not (
				Library.Settings
				and Library.Settings.Checks.Team.Enabled
				and Library.Settings.Checks.Team.SelectedTeams.self
			)
		then
			return
		end
		teamType = "self"
	end

	local box = {
		TopLeft = Drawing.new("Line"),
		TopRight = Drawing.new("Line"),
		BottomLeft = Drawing.new("Line"),
		BottomRight = Drawing.new("Line"),
		Left = Drawing.new("Line"),
		Right = Drawing.new("Line"),
		Top = Drawing.new("Line"),
		Bottom = Drawing.new("Line"),
	}

	for _, line in pairs(box) do
		line.Visible = false
		line.Color = Library.Settings.currentColors[teamType].Box.Outline.Visible
		line.Thickness = Library.Settings.Box.Thickness
		if line == box.Fill then
			line.Filled = true
			line.Transparency = Library.Settings.Box.Filled.Transparency
		end
	end

	local tracer = Drawing.new("Line")
	tracer.Visible = false
	tracer.Color = Library.Settings.currentColors[teamType].Tracer.Visible
	tracer.Thickness = Library.Settings.Tracers.Thickness

	local healthBar = {
		Outline = Drawing.new("Square"),
		Fill = Drawing.new("Square"),
		Text = Drawing.new("Text"),
	}

	for _, obj in pairs(healthBar) do
		obj.Visible = false
		local healthtype
		if Player.Character.Humanoid.Health / Player.Character.Humanoid.MaxHealth > 60 / 100 then
			healthtype = "High"
		elseif Player.Character.Humanoid.Health / Player.Character.Humanoid.MaxHealth > 20 / 100 then
			healthtype = "Medium"
		else
			healthtype = "Low"
		end
		if obj == healthBar.Fill then
			obj.Color = Library.Settings.currentColors[teamType].healthBar.Fills[healthtype]
			obj.Filled = true
		elseif obj == healthBar.Text then
			obj.Center = true
			obj.Size = Library.Settings.TextSize
			obj.Color = Library.Settings.currentColors[teamType].healthBar.Fills[healthtype]
			obj.Font = 2
		else
			obj.Color = Library.Settings.currentColors[teamType].healthBar.Outline
			obj.Filled = false
		end
	end

	local info = {
		Name = Drawing.new("Text"),
		Distance = Drawing.new("Text"),
	}

	for _, text in pairs(info) do
		text.Visible = false
		text.Center = true
		text.Size = Library.Settings.TextSize
		text.Color = Library.Settings.currentColors[teamType].Text
		text.Font = 2
		text.Outline = true
	end

	local snapline = Drawing.new("Line")
	snapline.Visible = false
	snapline.Color = Library.Settings.currentColors[teamType].Box.Outline
	snapline.Thickness = 1

	local highlight = Instance.new("Highlight")
	highlight.FillColor = Library.Settings.currentColors[teamType].Chams.Fill.Visible
	highlight.OutlineColor = Library.Settings.currentColors[teamType].Chams.Outline.Visible
	highlight.FillTransparency = Library.Settings.Chams.Fill.Transparency
	highlight.OutlineTransparency = Library.Settings.Chams.Oultine.Transparency
	highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
	highlight.Enabled = Library.Settings.Chams.Enabled[teamType]

	Library.Highlights[Player] = highlight

	local skeleton = {
		-- Spine & Head
		Head = Drawing.new("Line"),
		Neck = Drawing.new("Line"),
		UpperSpine = Drawing.new("Line"),
		LowerSpine = Drawing.new("Line"),

		-- Left Arm
		LeftShoulder = Drawing.new("Line"),
		LeftUpperArm = Drawing.new("Line"),
		LeftLowerArm = Drawing.new("Line"),
		LeftHand = Drawing.new("Line"),

		-- Right Arm
		RightShoulder = Drawing.new("Line"),
		RightUpperArm = Drawing.new("Line"),
		RightLowerArm = Drawing.new("Line"),
		RightHand = Drawing.new("Line"),

		-- Left Leg
		LeftHip = Drawing.new("Line"),
		LeftUpperLeg = Drawing.new("Line"),
		LeftLowerLeg = Drawing.new("Line"),
		LeftFoot = Drawing.new("Line"),

		-- Right Leg
		RightHip = Drawing.new("Line"),
		RightUpperLeg = Drawing.new("Line"),
		RightLowerLeg = Drawing.new("Line"),
		RightFoot = Drawing.new("Line"),
	}

	for _, line in pairs(skeleton) do
		line.Visible = false
		line.Color = Library.Settings.currentColors[teamType].Skeleton.Visible
		line.Thickness = Library.Settings.Skeleton.Thickness
		line.Transparency = Library.Settings.Skeleton.Transparency
	end

	Library.Drawings.Skeleton[Player] = skeleton

	Library.Drawings.ESP[Player] = {
		Box = box,
		Tracer = tracer,
		HealthBar = healthBar,
		Info = info,
		Snapline = snapline,
	}
end

function playerEsp:RemoveESP(Library, Player) end

return playerEsp
