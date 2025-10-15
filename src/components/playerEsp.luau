--[=[

	The code is somewhat commented,
	I kinda gave up abit into it

]=]

local services = require("@root/utilities/services")
local utilities = require("@root/utilities")

local Players = services.Players
local RunService = services.RunService
local UserInputService = services.UserInputService
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

local playerEsp = {}

function playerEsp:CreateESP(Library, Player)
	local teamType = utilities:GetPlayerType(Player)

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

function playerEsp:RemoveESP(Library, Player)
	local esp = Library.Drawings.ESP[Player]
	if esp then
		for _, obj in pairs(esp.Box) do
			obj:Remove()
		end
		esp.Tracer:Remove()
		for _, obj in pairs(esp.HealthBar) do
			obj:Remove()
		end
		for _, obj in pairs(esp.Info) do
			obj:Remove()
		end
		esp.Snapline:Remove()
		Library.Drawings.ESP[Player] = nil
	end

	local highlight = Library.Highlights[Player]
	if highlight then
		highlight:Destroy()
		Library.Highlights[Player] = nil
	end

	local skeleton = Library.Drawings.Skeleton[Player]
	if skeleton then
		for _, line in pairs(skeleton) do
			line:Remove()
		end
		Library.Drawings.Skeleton[Player] = nil
	end
end

function playerEsp:UpdateESP(Library, player)
	if not Library.Settings.Enabled then
		return
	end

	local esp = Library.Drawings.ESP[player]
	if not esp then
		return
	end

	local character = player.Character
	if not character then
		-- Hide all drawings if character doesn't exist
		for _, obj in pairs(esp.Box) do
			obj.Visible = false
		end
		esp.Tracer.Visible = false
		for _, obj in pairs(esp.HealthBar) do
			obj.Visible = false
		end
		for _, obj in pairs(esp.Info) do
			obj.Visible = false
		end
		esp.Snapline.Visible = false

		local skeleton = Library.Drawings.Skeleton[player]
		if skeleton then
			for _, line in pairs(skeleton) do
				line.Visible = false
			end
		end
		return
	end

	local rootPart = character:FindFirstChild("HumanoidRootPart")
	if not rootPart then
		-- Hide all drawings if rootPart doesn't exist
		for _, obj in pairs(esp.Box) do
			obj.Visible = false
		end
		esp.Tracer.Visible = false
		for _, obj in pairs(esp.HealthBar) do
			obj.Visible = false
		end
		for _, obj in pairs(esp.Info) do
			obj.Visible = false
		end
		esp.Snapline.Visible = false

		local skeleton = Library.Drawings.Skeleton[player]
		if skeleton then
			for _, line in pairs(skeleton) do
				line.Visible = false
			end
		end
		return
	end

	-- Early screen check to hide all drawings if player is off screen
	local _, isOnScreen = Camera:WorldToViewportPoint(rootPart.Position)
	if not isOnScreen then
		for _, obj in pairs(esp.Box) do
			obj.Visible = false
		end
		esp.Tracer.Visible = false
		for _, obj in pairs(esp.HealthBar) do
			obj.Visible = false
		end
		for _, obj in pairs(esp.Info) do
			obj.Visible = false
		end
		esp.Snapline.Visible = false

		local skeleton = Library.Drawings.Skeleton[player]
		if skeleton then
			for _, line in pairs(skeleton) do
				line.Visible = false
			end
		end
		return
	end

	local humanoid = character:FindFirstChild("Humanoid")
	if not humanoid or humanoid.Health <= 0 then
		for _, obj in pairs(esp.Box) do
			obj.Visible = false
		end
		esp.Tracer.Visible = false
		for _, obj in pairs(esp.HealthBar) do
			obj.Visible = false
		end
		for _, obj in pairs(esp.Info) do
			obj.Visible = false
		end
		esp.Snapline.Visible = false

		local skeleton = Library.Drawings.Skeleton[player]
		if skeleton then
			for _, line in pairs(skeleton) do
				line.Visible = false
			end
		end
		return
	end

	local pos, onScreen = Camera:WorldToViewportPoint(rootPart.Position)
	local distance = (rootPart.Position - Camera.CFrame.Position).Magnitude

	local isVisible = true
	if onScreen then
		if
			not (
				#workspace.CurrentCamera:GetPartsObscuringTarget(
					{ workspace.CurrentCamera.CFrame.Position, rootPart.Position },
					{ rootPart }
				) == 0
			)
		then
			isVisible = false
			if Library.Settings.Checks.Visible.Enabled and Library.Settings.Checks.Visible.OnlyVisible then
				for _, obj in pairs(esp.Box) do
					obj.Visible = false
				end
				esp.Tracer.Visible = false
				for _, obj in pairs(esp.HealthBar) do
					obj.Visible = false
				end
				for _, obj in pairs(esp.Info) do
					obj.Visible = false
				end
				esp.Snapline.Visible = false

				local skeleton = Library.Drawings.Skeleton[player]
				if skeleton then
					for _, line in pairs(skeleton) do
						line.Visible = false
					end
				end
				return
			end
		end
	end
	if not onScreen or distance > Library.Settings.MaxDistance then
		for _, obj in pairs(esp.Box) do
			obj.Visible = false
		end
		esp.Tracer.Visible = false
		for _, obj in pairs(esp.HealthBar) do
			obj.Visible = false
		end
		for _, obj in pairs(esp.Info) do
			obj.Visible = false
		end
		esp.Snapline.Visible = false
		return
	end

	local teamType = utilities:GetPlayerType(player)

	if Library.Settings.Checks.Team.Enabled then
		if Library.Settings.Checks.Team.SelectedTeams[teamType] == false then
			for _, obj in pairs(esp.Box) do
				obj.Visible = false
			end
			esp.Tracer.Visible = false
			for _, obj in pairs(esp.HealthBar) do
				obj.Visible = false
			end
			for _, obj in pairs(esp.Info) do
				obj.Visible = false
			end
			esp.Snapline.Visible = false
			return
		end
	end

	local boxColor = utilities:GetPlayerColor(player, isVisible, "Box", "Outline")
	local boxFillColor = utilities:GetPlayerColor(player, isVisible, "Box", "Fill")
	local tracerColor = utilities:GetPlayerColor(player, isVisible, "Tracer")
	local textColor = utilities:GetPlayerColor(player, isVisible, "Text")
	local skeletonColor = utilities:GetPlayerColor(player, isVisible, "Skeleton")
	local chamsOutlineColor = utilities:GetPlayerColor(player, isVisible, "Chams", "Outline")
	local chamsFillColor = utilities:GetPlayerColor(player, isVisible, "Chams", "Fill")
	local currentHealthColor = utilities:GetPlayerColor(player, isVisible, "HealthBar", "Fill")
	local healthOutlineColor = utilities:GetPlayerColor(player, isVisible, "HealthBar", "Outline")
	local size = character:GetExtentsSize()
	local cf = rootPart.CFrame

	local top, top_onscreen = Camera:WorldToViewportPoint(cf * CFrame.new(0, size.Y / 2, 0).Position)
	local bottom, bottom_onscreen = Camera:WorldToViewportPoint(cf * CFrame.new(0, -size.Y / 2, 0).Position)

	if not top_onscreen or not bottom_onscreen then
		for _, obj in pairs(esp.Box) do
			obj.Visible = false
		end
		return
	end

	local screenSize = bottom.Y - top.Y
	local boxWidth = screenSize * 0.65
	local boxPosition = Vector2.new(top.X - boxWidth / 2, top.Y)
	local boxSize = Vector2.new(boxWidth, screenSize)

	-- Hide all box parts by default
	for _, obj in pairs(esp.Box) do
		obj.Visible = false
	end

	if Library.Settings.Box.Enabled then
		if Library.Settings.Box.Style == 3 then
			local front = {
				TL = Camera:WorldToViewportPoint((cf * CFrame.new(-size.X / 2, size.Y / 2, -size.Z / 2)).Position),
				TR = Camera:WorldToViewportPoint((cf * CFrame.new(size.X / 2, size.Y / 2, -size.Z / 2)).Position),
				BL = Camera:WorldToViewportPoint((cf * CFrame.new(-size.X / 2, -size.Y / 2, -size.Z / 2)).Position),
				BR = Camera:WorldToViewportPoint((cf * CFrame.new(size.X / 2, -size.Y / 2, -size.Z / 2)).Position),
			}

			local back = {
				TL = Camera:WorldToViewportPoint((cf * CFrame.new(-size.X / 2, size.Y / 2, size.Z / 2)).Position),
				TR = Camera:WorldToViewportPoint((cf * CFrame.new(size.X / 2, size.Y / 2, size.Z / 2)).Position),
				BL = Camera:WorldToViewportPoint((cf * CFrame.new(-size.X / 2, -size.Y / 2, size.Z / 2)).Position),
				BR = Camera:WorldToViewportPoint((cf * CFrame.new(size.X / 2, -size.Y / 2, size.Z / 2)).Position),
			}

			if
				not (
					front.TL.Z > 0
					and front.TR.Z > 0
					and front.BL.Z > 0
					and front.BR.Z > 0
					and back.TL.Z > 0
					and back.TR.Z > 0
					and back.BL.Z > 0
					and back.BR.Z > 0
				)
			then
				for _, obj in pairs(esp.Box) do
					obj.Visible = false
				end
				return
			end

			-- Convert to Vector2
			local function toVector2(v3)
				return Vector2.new(v3.X, v3.Y)
			end
			front.TL, front.TR = toVector2(front.TL), toVector2(front.TR)
			front.BL, front.BR = toVector2(front.BL), toVector2(front.BR)
			back.TL, back.TR = toVector2(back.TL), toVector2(back.TR)
			back.BL, back.BR = toVector2(back.BL), toVector2(back.BR)

			-- Front face
			esp.Box.TopLeft.From = front.TL
			esp.Box.TopLeft.To = front.TR
			esp.Box.TopLeft.Visible = true

			esp.Box.TopRight.From = front.TR
			esp.Box.TopRight.To = front.BR
			esp.Box.TopRight.Visible = true

			esp.Box.BottomLeft.From = front.BL
			esp.Box.BottomLeft.To = front.BR
			esp.Box.BottomLeft.Visible = true

			esp.Box.BottomRight.From = front.TL
			esp.Box.BottomRight.To = front.BL
			esp.Box.BottomRight.Visible = true

			-- Back face
			esp.Box.Left.From = back.TL
			esp.Box.Left.To = back.TR
			esp.Box.Left.Visible = true

			esp.Box.Right.From = back.TR
			esp.Box.Right.To = back.BR
			esp.Box.Right.Visible = true

			esp.Box.Top.From = back.BL
			esp.Box.Top.To = back.BR
			esp.Box.Top.Visible = true

			esp.Box.Bottom.From = back.TL
			esp.Box.Bottom.To = back.BL
			esp.Box.Bottom.Visible = true

			-- Connecting lines
			local function drawConnectingLine(from, to, visible)
				local line = Drawing.new("Line")
				line.Visible = visible
				line.Color = boxColor
				line.Thickness = Library.Settings.Box.Thickness
				line.From = from
				line.To = to
				return line
			end
			local function drawConnectingBox(pointa, pointb, pointc, pointd)
				local quad = Drawing.new("Quad")
				if Library.Settings.Box.Filled.Enabled then
					quad.Visible = true
					quad.Filled = true
					quad.Transparency = Library.Settings.Box.Filled.Transparency
					quad.Color = boxFillColor
					quad.PointA = pointa
					quad.PointB = pointb
					quad.PointC = pointc
					quad.PointD = pointd
				else
					quad.Visible = false
				end
				return quad
			end

			-- Connect front to back and add fills
			local connectors = {
				drawConnectingLine(front.TL, back.TL, true),
				drawConnectingLine(front.TR, back.TR, true),
				drawConnectingLine(front.BL, back.BL, true),
				drawConnectingLine(front.BR, back.BR, true),
				drawConnectingBox(front.TL, front.TR, front.BL, front.BR),
				drawConnectingBox(back.TL, back.TR, back.BL, back.BR),
				drawConnectingBox(front.TL, back.TL, front.BL, back.BL),
				drawConnectingBox(front.TR, back.TR, front.BR, back.BR),
				drawConnectingBox(front.TR, back.TR, front.TL, back.TR),
				drawConnectingBox(front.BR, back.BR, front.BL, back.BR),
			}

			-- Clean up connecting lines and filled after frame
			task.spawn(function()
				task.wait()
				for _, drawing in ipairs(connectors) do
					drawing:Remove()
				end
			end)
		else
			local function drawConnectingBox(pointa, pointb, pointc, pointd)
				local quad = Drawing.new("Quad")
				if Library.Settings.Box.Filled.Enabled then
					quad.Visible = true
					quad.Filled = true
					quad.Transparency = Library.Settings.Box.Filled.Transparency
					quad.Color = boxFillColor
					quad.PointA = pointa
					quad.PointB = pointb
					quad.PointC = pointc
					quad.PointD = pointd
				else
					quad.Visible = false
				end
				return quad
			end

			local connectors = {
				drawConnectingBox(
					boxPosition,
					boxPosition + Vector2.new(boxSize.X, 0),
					boxPosition + Vector2.new(0, boxSize.Y),
					boxPosition + Vector2.new(boxSize.X, boxSize.Y)
				),
			}
			if Library.Settings.Box.Style == 1 then
				local cornerSize = boxWidth * 0.2

				esp.Box.TopLeft.From = boxPosition
				esp.Box.TopLeft.To = boxPosition + Vector2.new(cornerSize, 0)
				esp.Box.TopLeft.Visible = true

				esp.Box.TopRight.From = boxPosition + Vector2.new(boxSize.X, 0)
				esp.Box.TopRight.To = boxPosition + Vector2.new(boxSize.X - cornerSize, 0)
				esp.Box.TopRight.Visible = true

				esp.Box.BottomLeft.From = boxPosition + Vector2.new(0, boxSize.Y)
				esp.Box.BottomLeft.To = boxPosition + Vector2.new(cornerSize, boxSize.Y)
				esp.Box.BottomLeft.Visible = true

				esp.Box.BottomRight.From = boxPosition + Vector2.new(boxSize.X, boxSize.Y)
				esp.Box.BottomRight.To = boxPosition + Vector2.new(boxSize.X - cornerSize, boxSize.Y)
				esp.Box.BottomRight.Visible = true

				esp.Box.Left.From = boxPosition
				esp.Box.Left.To = boxPosition + Vector2.new(0, cornerSize)
				esp.Box.Left.Visible = true

				esp.Box.Right.From = boxPosition + Vector2.new(boxSize.X, 0)
				esp.Box.Right.To = boxPosition + Vector2.new(boxSize.X, cornerSize)
				esp.Box.Right.Visible = true

				esp.Box.Top.From = boxPosition + Vector2.new(0, boxSize.Y)
				esp.Box.Top.To = boxPosition + Vector2.new(0, boxSize.Y - cornerSize)
				esp.Box.Top.Visible = true

				esp.Box.Bottom.From = boxPosition + Vector2.new(boxSize.X, boxSize.Y)
				esp.Box.Bottom.To = boxPosition + Vector2.new(boxSize.X, boxSize.Y - cornerSize)
				esp.Box.Bottom.Visible = true
			else -- Full box
				esp.Box.Left.From = boxPosition
				esp.Box.Left.To = boxPosition + Vector2.new(0, boxSize.Y)
				esp.Box.Left.Visible = true

				esp.Box.Right.From = boxPosition + Vector2.new(boxSize.X, 0)
				esp.Box.Right.To = boxPosition + Vector2.new(boxSize.X, boxSize.Y)
				esp.Box.Right.Visible = true

				esp.Box.Top.From = boxPosition
				esp.Box.Top.To = boxPosition + Vector2.new(boxSize.X, 0)
				esp.Box.Top.Visible = true

				esp.Box.Bottom.From = boxPosition + Vector2.new(0, boxSize.Y)
				esp.Box.Bottom.To = boxPosition + Vector2.new(boxSize.X, boxSize.Y)
				esp.Box.Bottom.Visible = true

				esp.Box.TopLeft.Visible = false
				esp.Box.TopRight.Visible = false
				esp.Box.BottomLeft.Visible = false
				esp.Box.BottomRight.Visible = false
			end
			task.spawn(function()
				task.wait()
				for _, drawing in ipairs(connectors) do
					drawing:Remove()
				end
			end)
		end

		for _, obj in pairs(esp.Box) do
			if obj.Visible then
				obj.Color = boxColor
				obj.Thickness = Library.Settings.Box.Thickness
			end
		end
	end

	if Library.Settings.Tracer.Enabled[teamType] then
		esp.Tracer.From = utilities:GetTracerOrigin()
		esp.Tracer.To = Vector2.new(pos.X, pos.Y)
		esp.Tracer.Color = tracerColor
		esp.Tracer.Visible = true
	else
		esp.Tracer.Visible = false
	end

	if Library.Settings.HealthBar.Enabled[teamType] then
		local health = humanoid.Health
		local maxHealth = humanoid.MaxHealth
		local healthPercent = health / maxHealth

		local barHeight = screenSize * 0.8
		local barWidth = 4
		local barPos = Vector2.new(boxPosition.X - barWidth - 2, boxPosition.Y + (screenSize - barHeight) / 2)

		if Library.Settings.HealthBar.Bar then
			esp.HealthBar.Outline.Size = Vector2.new(barWidth, barHeight)
			esp.HealthBar.Outline.Position = barPos
			esp.HealthBar.Outline.Visible = true
			esp.HealthBar.Outline.Color = healthOutlineColor

			esp.HealthBar.Fill.Size = Vector2.new(barWidth - 2, barHeight * healthPercent)
			esp.HealthBar.Fill.Position = Vector2.new(barPos.X + 1, barPos.Y + barHeight * (1 - healthPercent))
			esp.HealthBar.Fill.Color = currentHealthColor
			esp.HealthBar.Fill.Visible = true
		else
			esp.HealthBar.Outline.Visible = false
			esp.HealthBar.Fill.Visible = false
		end

		if Library.Settings.HealthBar.Text then
			esp.HealthBar.Text.Text = math.floor(health) .. Library.Settings.HealthBar.Suffix
			esp.HealthBar.Text.Position = Vector2.new(barPos.X + barWidth + 2, barPos.Y + barHeight / 2)
			esp.HealthBar.Text.Visible = true
		else
			esp.HealthBar.Text.Visible = false
		end
	else
		for _, obj in pairs(esp.HealthBar) do
			obj.Visible = false
		end
	end

	if Library.Settings.Name.Enabled[teamType] then
		esp.Info.Name.Text = Library.Settings.Name.Style == 2 and player.Name or player.DisplayName
		esp.Info.Name.Position = Vector2.new(boxPosition.X + boxWidth / 2, boxPosition.Y - 20)
		esp.Info.Name.Color = textColor
		esp.Info.Name.Visible = true
	else
		esp.Info.Name.Visible = false
	end

	if Library.Settings.Snaplines then
		esp.Snapline.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
		esp.Snapline.To = Vector2.new(pos.X, pos.Y)
		esp.Snapline.Color = boxColor
		esp.Snapline.Visible = true
	else
		esp.Snapline.Visible = false
	end

	local highlight: Highlight = Library.Highlights[player]
	if highlight then
		if Library.Settings.Chams.Enabled[teamType] and character then
			highlight.Parent = character
			highlight.FillColor = chamsFillColor
			highlight.OutlineColor = chamsOutlineColor
			highlight.FillTransparency = Library.Settings.Chams.Fill.Enabled
					and Library.Settings.Chams.Fill.Transparency
				or 1
			highlight.OutlineTransparency = Library.Settings.Chams.Outline.Enabled
					and Library.Settings.Chams.Outline.Transparency
				or 1
			highlight.Enabled = true
		else
			highlight.Enabled = false
		end
		highlight.DepthMode = Library.Settings.Chams.Occlusion and Enum.HighlightDepthMode.Occluded
			or Enum.HighlightDepthMode.AlwaysOnTop
	end

	if Library.Settings.Skeleton.Enabled[teamType] then
		local function getBonePositions(character)
			if not character then
				return nil
			end

			local bones = {
				Head = character:FindFirstChild("Head"),
				UpperTorso = character:FindFirstChild("UpperTorso") or character:FindFirstChild("Torso"),
				LowerTorso = character:FindFirstChild("LowerTorso") or character:FindFirstChild("Torso"),
				RootPart = character:FindFirstChild("HumanoidRootPart"),

				-- Left Arm
				LeftUpperArm = character:FindFirstChild("LeftUpperArm") or character:FindFirstChild("Left Arm"),
				LeftLowerArm = character:FindFirstChild("LeftLowerArm") or character:FindFirstChild("Left Arm"),
				LeftHand = character:FindFirstChild("LeftHand") or character:FindFirstChild("Left Arm"),

				-- Right Arm
				RightUpperArm = character:FindFirstChild("RightUpperArm") or character:FindFirstChild("Right Arm"),
				RightLowerArm = character:FindFirstChild("RightLowerArm") or character:FindFirstChild("Right Arm"),
				RightHand = character:FindFirstChild("RightHand") or character:FindFirstChild("Right Arm"),

				-- Left Leg
				LeftUpperLeg = character:FindFirstChild("LeftUpperLeg") or character:FindFirstChild("Left Leg"),
				LeftLowerLeg = character:FindFirstChild("LeftLowerLeg") or character:FindFirstChild("Left Leg"),
				LeftFoot = character:FindFirstChild("LeftFoot") or character:FindFirstChild("Left Leg"),

				-- Right Leg
				RightUpperLeg = character:FindFirstChild("RightUpperLeg") or character:FindFirstChild("Right Leg"),
				RightLowerLeg = character:FindFirstChild("RightLowerLeg") or character:FindFirstChild("Right Leg"),
				RightFoot = character:FindFirstChild("RightFoot") or character:FindFirstChild("Right Leg"),
			}

			-- Verify we have the minimum required bones
			if not (bones.Head and bones.UpperTorso) then
				return nil
			end

			return bones
		end

		local function drawBone(from, to, line)
			if not from or not to then
				line.Visible = false
				return
			end

			-- Get center positions of the parts
			local fromPos = (from.CFrame * CFrame.new(0, 0, 0)).Position
			local toPos = (to.CFrame * CFrame.new(0, 0, 0)).Position

			-- Convert to screen positions with proper depth check
			local fromScreen, fromVisible = Camera:WorldToViewportPoint(fromPos)
			local toScreen, toVisible = Camera:WorldToViewportPoint(toPos)

			-- Only show if both points are visible and in front of camera
			if not (fromVisible and toVisible) or fromScreen.Z < 0 or toScreen.Z < 0 then
				line.Visible = false
				return
			end

			-- Check if points are within screen bounds
			local screenBounds = Camera.ViewportSize
			if
				fromScreen.X < 0
				or fromScreen.X > screenBounds.X
				or fromScreen.Y < 0
				or fromScreen.Y > screenBounds.Y
				or toScreen.X < 0
				or toScreen.X > screenBounds.X
				or toScreen.Y < 0
				or toScreen.Y > screenBounds.Y
			then
				line.Visible = false
				return
			end

			-- Update line with screen positions
			line.From = Vector2.new(fromScreen.X, fromScreen.Y)
			line.To = Vector2.new(toScreen.X, toScreen.Y)
			line.Color = skeletonColor
			line.Thickness = Library.Settings.Skeleton.Thickness
			line.Transparency = Library.Settings.Skeleton.Transparency
			line.Visible = true
		end

		local bones = getBonePositions(character)
		if bones then
			local skeleton = Library.Drawings.Skeleton[player]
			if skeleton then
				-- Spine & Head
				drawBone(bones.Head, bones.UpperTorso, skeleton.Head)
				drawBone(bones.UpperTorso, bones.LowerTorso, skeleton.UpperSpine)

				-- Left Arm Chain
				drawBone(bones.UpperTorso, bones.LeftUpperArm, skeleton.LeftShoulder)
				drawBone(bones.LeftUpperArm, bones.LeftLowerArm, skeleton.LeftUpperArm)
				drawBone(bones.LeftLowerArm, bones.LeftHand, skeleton.LeftLowerArm)

				-- Right Arm Chain
				drawBone(bones.UpperTorso, bones.RightUpperArm, skeleton.RightShoulder)
				drawBone(bones.RightUpperArm, bones.RightLowerArm, skeleton.RightUpperArm)
				drawBone(bones.RightLowerArm, bones.RightHand, skeleton.RightLowerArm)

				-- Left Leg Chain
				drawBone(bones.LowerTorso, bones.LeftUpperLeg, skeleton.LeftHip)
				drawBone(bones.LeftUpperLeg, bones.LeftLowerLeg, skeleton.LeftUpperLeg)
				drawBone(bones.LeftLowerLeg, bones.LeftFoot, skeleton.LeftLowerLeg)

				-- Right Leg Chain
				drawBone(bones.LowerTorso, bones.RightUpperLeg, skeleton.RightHip)
				drawBone(bones.RightUpperLeg, bones.RightLowerLeg, skeleton.RightUpperLeg)
				drawBone(bones.RightLowerLeg, bones.RightFoot, skeleton.RightLowerLeg)
			end
		end
	else
		local skeleton = Library.Drawings.Skeleton[player]
		if skeleton then
			for _, line in pairs(skeleton) do
				line.Visible = false
			end
		end
	end
end

return playerEsp
