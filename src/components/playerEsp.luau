--[=[

	The code is somewhat commented,
	I kinda gave up abit into it

]=]

local utilities = require("@root/utilities")
local services = require("@root/utilities/services")
local drawer = require("@root/utilities/drawer")

local Players = services.Players
local Camera = workspace.CurrentCamera

local playerEsp = {}
local tracerorigin = utilities.GetTracerOrigin
local playertype = utilities.GetPlayerType
local playercolorfunc = utilities.GetPlayerColor

function playerEsp:CreateESP(Library, Player)
	local teamType = playertype(utilities, Player)

	local box = {
		TopLeft = drawer.new("Line"),
		TopRight = drawer.new("Line"),
		BottomLeft = drawer.new("Line"),
		BottomRight = drawer.new("Line"),
		Left = drawer.new("Line"),
		Right = drawer.new("Line"),
		Top = drawer.new("Line"),
		Bottom = drawer.new("Line"),
	}

	for _, line in pairs(box) do
		line.Visible = false
		line.Color = Library.Settings.currentColors[teamType].Box.Outline.Visible
		line.Thickness = Library.Settings.Box.Thickness
	end

	local tracer = drawer.new("Line", {
		Visible = false,
		Thickness = Library.Settings.Tracer.Thickness,
		From = tracerorigin(utilities, Library),
	})

	local healthBar = {
		Outline = drawer.new("Square"),
		Fill = drawer.new("Square"),
		Text = drawer.new("Text"),
	}

	task.defer(function()
		for _, obj in pairs(healthBar) do
			obj.Visible = false
			local healthtype
			repeat
				task.wait()
			until Player.Character
			local humanoid = Player.Character:FindFirstChild("Humanoid")
			if humanoid then
				if humanoid.Health / humanoid.MaxHealth > 60 / 100 then
					healthtype = "High"
				elseif humanoid.Health / humanoid.MaxHealth > 20 / 100 then
					healthtype = "Medium"
				else
					healthtype = "Low"
				end
			else
				healthtype = "High"
			end
			if not Library.Settings.currentColors[teamType].HealthBar then
				continue
			end
			if obj == healthBar.Fill then
				obj.Color = Library.Settings.currentColors[teamType].HealthBar.Fills[healthtype]
				obj.Filled = true
			elseif obj == healthBar.Text then
				obj.Center = true
				obj.Size = Library.Settings.TextSize
				obj.Color = Library.Settings.currentColors[teamType].HealthBar.Fills[healthtype]
				obj.Font = 2
			else
				obj.Filled = false
			end
		end
	end)

	local info = {
		Name = drawer.new("Text"),
		Distance = drawer.new("Text"),
	}

	for _, text in pairs(info) do
		text.Visible = false
		text.Center = true
		text.Size = Library.Settings.TextSize
		text.Color = Library.Settings.currentColors[teamType].Text
		text.Font = 2
		text.Outline = true
	end

	local snapline = drawer.new("Line", {
		Visible = false,
		Color = Library.Settings.currentColors[teamType].Box.Outline.Visible,
		Thickness = 1,
	})

	local highlight = Instance.new("Highlight")
	highlight.FillColor = Library.Settings.currentColors[teamType].Chams.Fill.Visible
	highlight.OutlineColor = Library.Settings.currentColors[teamType].Chams.Outline.Visible
	highlight.FillTransparency = Library.Settings.Chams.Fill.Transparency
	highlight.OutlineTransparency = Library.Settings.Chams.Outline.Transparency
	highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
	highlight.Enabled = false

	Library.Highlights[Player] = highlight

	local skeleton = {
		-- Spine & Head
		Head = drawer.new("Line"),
		Neck = drawer.new("Line"),
		UpperSpine = drawer.new("Line"),
		LowerSpine = drawer.new("Line"),

		-- Left Arm
		LeftShoulder = drawer.new("Line"),
		LeftUpperArm = drawer.new("Line"),
		LeftLowerArm = drawer.new("Line"),
		LeftHand = drawer.new("Line"),

		-- Right Arm
		RightShoulder = drawer.new("Line"),
		RightUpperArm = drawer.new("Line"),
		RightLowerArm = drawer.new("Line"),
		RightHand = drawer.new("Line"),

		-- Left Leg
		LeftHip = drawer.new("Line"),
		LeftUpperLeg = drawer.new("Line"),
		LeftLowerLeg = drawer.new("Line"),
		LeftFoot = drawer.new("Line"),

		-- Right Leg
		RightHip = drawer.new("Line"),
		RightUpperLeg = drawer.new("Line"),
		RightLowerLeg = drawer.new("Line"),
		RightFoot = drawer.new("Line"),
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
		Fills = {},
	}
end

function playerEsp:RemoveESP(Library, Player)
	local esp = Library.Drawings.ESP[Player]
	if esp then
		for _, obj in pairs(esp.Box) do
			pcall(obj.Remove, obj)
			pcall(obj.Destroy, obj)
		end
		pcall(esp.Tracer.Remove, esp.Tracer)
		pcall(esp.Tracer.Destroy, esp.Tracer)
		for _, obj in pairs(esp.HealthBar) do
			pcall(obj.Remove, obj)
			pcall(obj.Destroy, obj)
		end
		for _, obj in pairs(esp.Info) do
			pcall(obj.Remove, obj)
			pcall(obj.Destroy, obj)
		end
		for _, obj in pairs(esp.Fills) do
			pcall(obj.Remove, obj)
			pcall(obj.Destroy, obj)
		end
		pcall(esp.Snapline.Remove, esp.Snapline)
		pcall(esp.Snapline.Destroy, esp.Snapline)
		Library.Drawings.ESP[Player] = nil
	end

	local highlight = Library.Highlights[Player]
	if highlight then
		pcall(highlight.Destroy, highlight)
		Library.Highlights[Player] = nil
	end

	local skeleton = Library.Drawings.Skeleton[Player]
	if skeleton then
		for _, line in pairs(skeleton) do
			pcall(line.Remove, line)
			pcall(line.Destroy, line)
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
		for _, obj in pairs(esp.Fills) do
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
	local humanoid = character:FindFirstChild("Humanoid")
	if not rootPart or not humanoid then
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
		for _, obj in pairs(esp.Fills) do
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
	local pos, onScreen = Camera:WorldToViewportPoint(rootPart.Position)
	if not onScreen then
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
		for _, obj in pairs(esp.Fills) do
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
		for _, obj in pairs(esp.Fills) do
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
				for _, obj in pairs(esp.Fills) do
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
		for _, obj in pairs(esp.Fills) do
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

	local teamType = playertype(utilities, player)

	if Library.Settings.Checks.Team.Enabled then
		if not Library.Settings.Checks.Team.SelectedTeams[teamType] then
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
			for _, obj in pairs(esp.Fills) do
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

	local boxColor = playercolorfunc(utilities, Library, player, isVisible, "Box", "Outline")
	local boxFillColor = playercolorfunc(utilities, Library, player, isVisible, "Box", "Fill")
	local tracerColor = playercolorfunc(utilities, Library, player, isVisible, "Tracer")
	local textColor = playercolorfunc(utilities, Library, player, isVisible, "Text")
	local skeletonColor = playercolorfunc(utilities, Library, player, isVisible, "Skeleton")
	local chamsOutlineColor = playercolorfunc(utilities, Library, player, isVisible, "Chams", "Outline")
	local chamsFillColor = playercolorfunc(utilities, Library, player, isVisible, "Chams", "Fill")
	local currentHealthColor = playercolorfunc(utilities, Library, player, isVisible, "HealthBar", "Fill")
	local healthOutlineColor = playercolorfunc(utilities, Library, player, isVisible, "HealthBar", "Outline")
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
				return drawer.new("Line", {
					Visible = visible,
					Color = boxColor,
					Thickness = Library.Settings.Box.Thickness,
					From = from,
					To = to,
				})
			end
			local function drawConnectingBox(a, b, c, d, faceId)
				-- BTW im only doing this shit super complicated-ly because some executors' Drawing library is trash.
				-- They dont have filling for shapes (triangle and quad). Example is Solara.
				-- If I could, i would have just used Filled Quads
				local function dot(u, v)
					return u.X * v.X + u.Y * v.Y
				end

				local function length(v)
					return math.sqrt(v.X * v.X + v.Y * v.Y)
				end

				local function normalize(v)
					local l = length(v)
					if l == 0 then
						return Vector2.new(0, 0)
					end
					return Vector2.new(v.X / l, v.Y / l)
				end

				-- a: top-left, b: top-right, c: bottom-right, d: bottom-left (all Vector2 screen coords)
				-- returns: from(Vector2), to(Vector2), thickness(number)
				local function faceCenterLine_and_thickness()
					-- width vector (top edge)
					local widthVec = c - a
					local wlen = length(widthVec)
					if wlen == 0 then
						-- degenerate top edge: fallback to small visible line between a and c
						local fallbackFrom = (a + d) * 0.5
						local fallbackTo = (b + c) * 0.5
						return fallbackFrom, fallbackTo, 1
					end

					-- perpendicular normal to width, rotated 90 degrees (counter-clockwise)
					local n = Vector2.new(-widthVec.Y, widthVec.X)
					local nUnit = normalize(n)
					if nUnit.X == 0 and nUnit.Y == 0 then
						-- shouldn't happen because when > 0, but safe guard
						return (a + d) * 0.5, (b + c) * 0.5, 1
					end

					-- perpendicular distances from top edge to bottom points projected onto normal
					local distLeft = math.abs(dot(d - a, nUnit))
					local distRight = math.abs(dot(b - c, nUnit))

					-- average for stability (handles small skew/trapezoids)
					local height = (distLeft + distRight) * 0.5

					-- midpoints of left and right edges
					local leftMid = (a + b) * 0.5
					local rightMid = (d + c) * 0.5

					return leftMid, rightMid, height
				end

				local from, to, thickness = faceCenterLine_and_thickness()
				local fills = esp.Fills or {}
				local fillIndex = faceId

				local line
				if fills[fillIndex] and fills[fillIndex].Position == nil then
					line = fills[fillIndex]
				else
					line = drawer.new("Line")
					fills[fillIndex] = line
				end

				line.Visible = isVisible and Library.Settings.Box.Filled.Enabled or false
				line.Color = boxFillColor
				line.Transparency = Library.Settings.Box.Filled.Transparency
				line.Thickness = thickness
				line.From = from
				line.To = to

				esp.Fills = fills
				return line
			end

			drawConnectingBox(front.TL, front.TR, front.BL, front.BR, 1)
			drawConnectingBox(back.TL, back.TR, back.BL, back.BR, 2)
			drawConnectingBox(front.TL, back.TL, front.BL, back.BL, 3)
			drawConnectingBox(front.TR, back.TR, front.BR, back.BR, 4)
			drawConnectingBox(front.TL, front.TR, back.TR, back.TL, 5)
			drawConnectingBox(front.BL, front.BR, back.BR, back.BL, 6)

			-- Connect front to back and add fills
			local connectors = {
				drawConnectingLine(front.TL, back.TL, true),
				drawConnectingLine(front.TR, back.TR, true),
				drawConnectingLine(front.BL, back.BL, true),
				drawConnectingLine(front.BR, back.BR, true),
			}

			-- Clean up connecting lines and filled after frame
			task.defer(function()
				task.wait(Library.Settings.Framerate or 1 / 60)
				for _, drawing in ipairs(connectors) do
					pcall(drawing.Remove, drawing)
					pcall(drawing.Destroy, drawing)
				end
			end)
		else
			local function drawConnectingBox(pointa, pointd)
				local fills = esp.Fills or {}
				local fillIndex = 1

				local fill
				if fills[fillIndex] and fills[fillIndex].From == nil then
					fill = fills[fillIndex]
				else
					fill = drawer.new("Square")
					fills[fillIndex] = fill
				end

				fill.Visible = isVisible and Library.Settings.Box.Filled.Enabled or false
				fill.Color = boxFillColor
				fill.Transparency = Library.Settings.Box.Filled.Transparency
				fill.Filled = true
				fill.Position = pointa
				fill.Size = pointd - pointa

				esp.Fills = fills
				return fill
			end

			drawConnectingBox(boxPosition, boxPosition + Vector2.new(boxSize.X, boxSize.Y))

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
		end

		for _, obj in pairs(esp.Box) do
			if obj.Visible then
				obj.Color = boxColor
				obj.Thickness = Library.Settings.Box.Thickness
			end
		end
	end

	if Library.Settings.Tracer.Enabled[teamType] then
		esp.Tracer.From = tracerorigin(utilities, Library)
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
	if Library.Settings.Distance.Enabled[teamType] then
		local distformatted = tonumber(distance)
		if Library.Settings.Distance.DistanceUnit == 2 then
			distformatted = distance * 0.28
		end
		esp.Info.Name.Text = tostring(math.round(distformatted * 10) / 10)
			.. " "
			.. (Library.Settings.Distance.DistanceUnit == 2 and "meters" or "studs")
		esp.Info.Name.Position = Vector2.new(boxPosition.X + boxWidth / 2, boxPosition.Y + boxSize.Y)
		esp.Info.Name.Color = textColor
		esp.Info.Name.Visible = true
	else
		esp.Info.Name.Visible = false
	end

	if Library.Settings.Snaplines then
		esp.Snapline.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
		esp.Snapline.To = Vector2.new(pos.X, pos.Y)
		esp.Snapline.Color = boxColor
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
		local function getBonePositions()
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
