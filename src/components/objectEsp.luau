local ObjectESP = {}
ObjectESP.__index = ObjectESP

local services = require("@root/utilities/services")
local utilities = require("@root/utilities")

local Players = services.Players
local RunService = services.RunService
local UserInputService = services.UserInputService
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

local tracerorigin = utilities.GetTracerOrigin
local playercolorfunc = utilities.GetPlayerColor

function ObjectESP.CreateESP(Library, object, rootPart)
	local teamType = "generic"

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
	end

	local tracer = Drawing.new("Line")
	tracer.Visible = false
	tracer.Color = Library.Settings.currentColors[teamType].Tracer.Visible
	tracer.Thickness = Library.Settings.Tracer.Thickness
	tracer.From = tracerorigin(utilities, Library)

	local healthBar = {
		Outline = Drawing.new("Square"),
		Fill = Drawing.new("Square"),
		Text = Drawing.new("Text"),
	}

	for _, obj in pairs(healthBar) do
		obj.Visible = false
		local healthtype
		repeat
			task.wait()
		until object
		local humanoid = object:FindFirstChildOfClass("Humanoid")
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
	snapline.Color = Library.Settings.currentColors[teamType].Box.Outline.Visible
	snapline.Thickness = 1

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

		rootPart = rootPart,
		highlight = highlight,
		object = object,
	}, ObjectESP)

	Library.ObjectESPs.ESPs[object] = self

	return self
end

function ObjectESP:UpdateESP(Library)
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
		esp.Snapline.Visible = false

		esp.highlight.Enabled = false
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
			local function drawConnectingBox(a, b, c, d)
				-- returns fromVec2, toVec2, thicknessNumber (pixels)
				local function faceCenterLine_and_thickness(a, b, c, d)
					local law = math.abs((b - a).X)
					local lah = math.abs((b - a).Y)
					local length = math.sqrt(law * law + lah * lah)
					local law2 = math.abs((d - c).X)
					local lah2 = math.abs((d - c).Y)
					local length2 = math.sqrt(law2 * law2 + lah2 * lah2)
					print(length == length2 and "YESSS MATH WORKS" or "fuck ts")

					return (d - a) / 2 + a, (c - b) / 2 + b, length
				end

				local from, to, thickness = faceCenterLine_and_thickness(a, b, c, d)
				local quad = Drawing.new("Line")
				quad.Transparency = Library.Settings.Box.Filled.Transparency
				quad.Color = boxFillColor
				quad.Thickness = thickness
				quad.From = from
				quad.To = to

				if Library.Settings.Box.Filled.Enabled then
					quad.Visible = true
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
				drawConnectingBox(front.TL, front.TR, front.BR, front.BL),
				drawConnectingBox(back.TL, back.TR, back.BR, back.BL),
				drawConnectingBox(front.TL, back.TL, front.BL, back.BL),
				drawConnectingBox(front.TR, back.TR, front.BR, back.BR),
				drawConnectingBox(front.TR, back.TR, back.TR, front.TL),
				drawConnectingBox(front.BR, back.BR, back.BR, front.BL),
			}

			-- Clean up connecting lines and filled after frame
			task.defer(function()
				task.wait(Library.Settings.Framerate or 1 / 144)
				for _, drawing in ipairs(connectors) do
					pcall(drawing.Remove, drawing)
					pcall(drawing.Destroy, drawing)
				end
			end)
		else
			local function drawConnectingBox(pointa, pointd)
				local quad = Drawing.new("Square")
				quad.Filled = true
				quad.Transparency = Library.Settings.Box.Filled.Transparency
				quad.Color = boxFillColor
				quad.Position = pointa
				quad.Size = pointd - pointa
				if Library.Settings.Box.Filled.Enabled then
					quad.Visible = true
				else
					quad.Visible = false
				end
				return quad
			end

			local connectors = {
				drawConnectingBox(boxPosition, boxPosition + Vector2.new(boxSize.X, boxSize.Y)),
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
			task.defer(function()
				task.wait()
				for _, drawing in ipairs(connectors) do
					pcall(drawing.Remove, drawing)
					pcall(drawing.Destroy, drawing)
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
		esp.Info.Name.Text = object.Name
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

function ObjectESP:RemoveESP(Library)
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
