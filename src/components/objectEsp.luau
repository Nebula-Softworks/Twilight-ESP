local ObjectESP = {}
ObjectESP.__index = ObjectESP

local types = require("../types")
local drawer = require("../utilities/drawer")
local utilities = require("../utilities")

local Camera = workspace.CurrentCamera
local tracerorigin = utilities.GetTracerOrigin
local playercolorfunc = utilities.GetPlayerColor

function ObjectESP.CreateESP(Library: types.TwilightLibrary, object, rootPart)
	local teamType = "generic"

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

	for _, obj in pairs(healthBar) do
		obj.Visible = false
		local healthtype
		repeat
			task.wait()
		until object
		local health = Library.Settings.HealthBar.Source(Player, "Health")
		local maxHealth = Library.Settings.HealthBar.Source(Player, "MaxHealth")
		if health / maxHealth > 60 / 100 then
			healthtype = "High"
		elseif health / maxHealth > 20 / 100 then
			healthtype = "Medium"
		else
			healthtype = "Low"
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

	if not Library.ObjectESPs then
		Library.ObjectESPs = { Highlights = {}, ESPs = {} }
	end
	if Library.ObjectESPs.Highlights then
		Library.ObjectESPs.Highlights[object] = highlight
	end

	rootPart = object:IsA("Part") and object or rootPart or object:IsA("Model") and object:FindFirstChildOfClass("Part")

	local self = setmetatable({
		Box = box,
		Tracer = tracer,
		HealthBar = healthBar,
		Info = info,
		Snapline = snapline,
		Fills = {},

		rootPart = rootPart,
		highlight = highlight,
		object = object,
	}, ObjectESP)

	Library.ObjectESPs.ESPs[object] = self

	return self
end

function ObjectESP:UpdateESP(Library: types.TwilightLibrary)
	if not Library.Settings.ObjectsEnabled then
		print("not enabled")
		return
	end

	local esp = self
	if not esp then
		print("esp not found")
		return
	end

	local object = self.object
	if not object then
		-- Hide all drawers if character doesn't exist
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
		esp.highlight.Enabled = false
		return
	end

	local rootPart = self.rootPart
	local humanoid = object:FindFirstChild("Humanoid")
	if not rootPart then
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

		esp.highlight.Enabled = false
		return
	end

	-- Early screen check to hide all drawers if player is off screen
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
		for _, obj in pairs(esp.Fills) do
			obj.Visible = false
		end
		esp.Snapline.Visible = false

		esp.highlight.Enabled = false
		return
	end

	if humanoid then
		if humanoid.Health <= 0 then
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

			esp.highlight.Enabled = false
			return
		end
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
				for _, obj in pairs(esp.Fills) do
					obj.Visible = false
				end
				esp.Snapline.Visible = false

				esp.highlight.Enabled = false
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
		esp.highlight.Enabled = false
		return
	end

	local teamType = "generic"

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
			esp.highlight.Enabled = false
			return
		end
	end

	-- doing this way cus i am lazy to rewrite
	local helper = { Neutral = true }
	local boxColor = playercolorfunc(utilities, Library, helper, isVisible, "Box", "Outline")
	local boxFillColor = playercolorfunc(utilities, Library, helper, isVisible, "Box", "Fill")
	local tracerColor = playercolorfunc(utilities, Library, helper, isVisible, "Tracer")
	local textColor = playercolorfunc(utilities, Library, helper, isVisible, "Text")
	local chamsOutlineColor = playercolorfunc(utilities, Library, helper, isVisible, "Chams", "Outline")
	local chamsFillColor = playercolorfunc(utilities, Library, helper, isVisible, "Chams", "Fill")
	local currentHealthColor = playercolorfunc(utilities, Library, helper, isVisible, "HealthBar", "Fill")
	local healthOutlineColor = playercolorfunc(utilities, Library, helper, isVisible, "HealthBar", "Outline")
	local size = object:IsA("Model") and object:GetExtentsSize() or object.Size
	local cf = rootPart.CFrame

	local _, top_onscreen = Camera:WorldToViewportPoint(cf * CFrame.new(0, size.Y / 2, 0).Position)
	local _, bottom_onscreen = Camera:WorldToViewportPoint(cf * CFrame.new(0, -size.Y / 2, 0).Position)
	local cfpos = Camera:WorldToViewportPoint(cf.Position)

	if not top_onscreen or not bottom_onscreen then
		for _, obj in pairs(esp.Box) do
			obj.Visible = false
		end
		return
	end

	local scale = 1 / (cfpos.Z * math.tan(math.rad(Camera.FieldOfView / 2)) * 2) * 1000
	local boxWidth, boxHeight = math.floor(4.5 * scale), math.floor(6 * scale)
	local x, y = math.floor(cfpos.X), math.floor(cfpos.Y)
	local boxPosition = Vector2.new(math.floor(x - boxWidth / 2), math.floor((y - boxHeight / 2) + (scale / 2)))
	local boxSize = Vector2.new(boxWidth, boxHeight)

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

	if
		Library.Settings.HealthBar.Enabled[teamType]
		and Library.Settings.HealthBar.Source == Library.Enums.HealthSource.Humanoid
	then
		local health = humanoid.Health
		local maxHealth = humanoid.MaxHealth
		local healthPercent = health / maxHealth

		local barHeight = boxSize.Y
		local barWidth = 4

		local barPosX = Library.Settings.HealthBar.Position == 1 and (boxPosition.X - barWidth - 4)
			or (boxPosition.X + barWidth + 4 + boxSize.X)
		local barPos = Vector2.new(barPosX, boxPosition.Y)

		if Library.Settings.HealthBar.Bar then
			esp.HealthBar.Outline.Size = Vector2.new(barWidth, barHeight)
			esp.HealthBar.Outline.Position = barPos
			esp.HealthBar.Outline.Visible = true
			esp.HealthBar.Outline.Color = healthOutlineColor

			esp.HealthBar.Fill.Size = Vector2.new(barWidth - 2, (barHeight - 2) * healthPercent)
			esp.HealthBar.Fill.Position =
				Vector2.new(barPos.X + 1, barPos.Y + 1 + ((barHeight - 2) * (1 - healthPercent)))
			esp.HealthBar.Fill.Color = currentHealthColor
			esp.HealthBar.Fill.Visible = true
		else
			esp.HealthBar.Outline.Visible = false
			esp.HealthBar.Fill.Visible = false
		end

		if Library.Settings.HealthBar.Text then
			esp.HealthBar.Text.Text = math.floor(health) .. Library.Settings.HealthBar.Suffix
			esp.HealthBar.Text.Position = Vector2.new(barPos.X + barWidth + 2, barPos.Y + barHeight)
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
		esp.Info.Name.Text = object.Name
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

	local highlight: Highlight = esp.highlight
	if highlight then
		if Library.Settings.Chams.Enabled[teamType] and object then
			highlight.Parent = object
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
end

function ObjectESP:RemoveESP(Library: types.TwilightLibrary)
	local esp = self
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
		esp = nil
	end

	local highlight = esp.Highlight
	if highlight then
		pcall(highlight.Destroy, highlight)
		highlight = nil
	end
end

return ObjectESP
