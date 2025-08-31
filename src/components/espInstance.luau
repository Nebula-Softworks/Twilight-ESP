local services = require(script.Parent.Parent.utilities.services)
local root = require(script.Parent.Parent.contract)
local creator = require(script.Parent.Parent.utilities.creator)
local types = require(script.Parent.Parent.types)

local players = services.Players

local espInstance = {}

function espInstance:Create(object, partRoot)
	local espObject = {} :: types.espObject

	local container = creator.New("Frame", {
		Parent = root.Instance,
		Name = object.Name and object.Name .. "_ESP",
	})
	creator.New("TextLabel", {
		Name = "Distance",
		Size = UDim2.new(1, 0, 0, 14),
		Position = UDim2.new(0, 0, 1, 2),
		Parent = container,
	})
	local namelabel = creator.New("TextLabel", {
		Name = "NameLabel",
		Size = UDim2.new(1, 0, 0, 14),
		Position = UDim2.fromScale(0, -0.1),
		Parent = container,
		Visible = root.settings.showObjectNames or false,
	})
	local boxContainer = creator.New("CanvasGroup", {
		Name = "Recolorer",
		Parent = container,
		--[[root.settings.currentColors.boxNeutral or ]]
		GroupColor3 = Color3.new(1, 1, 1),
	})
	local cornerBoxes = creator.New("ImageLabel", {
		Name = "CornerBoxes",
		-- old visuals
		--Image = "rbxassetid://85554062016173",
		--SliceCenter = Rect.new(142, 156, 861, 861),
		-- SliceScale = 0.32,
		Image = "rbxassetid://120285876115168",
		ScaleType = Enum.ScaleType.Slice,
		SliceCenter = Rect.new(271, 271, 746, 759),
		SliceScale = 0.22,
		ZIndex = 2,
		Parent = boxContainer,
	})
	local boxFrame = creator.New("Frame", {
		Size = UDim2.new(1, -70, 1, -70),
		Position = UDim2.fromScale(0.5, 0.5),
		AnchorPoint = Vector2.new(0.5, 0.5),
		Parent = boxContainer,
		Name = "BoxOutlineContainer",
	})
	local boxOutline = creator.New("UIStroke", {
		Thickness = 1,
		Parent = boxFrame,
		--[[root.settings.currentColors.boxOutlineNeutral or ]]
		Color = Color3.new(1, 1, 1),
		Name = "BoxOutline",
	})
	local cham = creator.New("Highlight", {
		--[[root.settings.currentColors.highlightFillNeutral or ]]
		FillColor = Color3.new(1, 1, 1),
		--OutlineColor = root.settings.currentColors.highlightOutline,
		Parent = root.settings.chamsEnabled and object or nil,
	})
	local tracer = creator.New("Frame", {
		Name = object.Name .. "_Tracer",
		Parent = root.Instance.Tracers,
		AnchorPoint = Vector2.new(0.5, 0.5),
		--[[root.settings.currentColors.boxOutlineNeutral or ]]
		BackgroundColor3 = Color3.new(1, 1, 1),
		Visible = false,
		BackgroundTransparency = 0,
	})
	espObject.tracer = tracer

	local healthBar = creator.New("CanvasGroup", {
		BackgroundTransparency = 0.65,
		AnchorPoint = Vector2.new(0.5, 0),
		Position = UDim2.new(0.5, 0, -0.1, 24),
		Size = UDim2.new(1, -60, 0, 8),
		Name = "HealthBar",
		Parent = container,
	})
	creator.New("UIStroke", {
		Thickness = 1.3,
		Parent = healthBar,
		Color = Color3.new(0, 0, 0),
	})
	creator.New("UICorner", {
		CornerRadius = UDim.new(1, 0),
		Parent = healthBar,
	})
	local healthBarFill = creator.New("Frame", {
		Size = UDim2.fromScale(0, 0),
		Parent = healthBar,
		Name = "Fill",
		BackgroundTransparency = 0,
	})
	creator.New("UICorner", {
		CornerRadius = UDim.new(1, 0),
		Parent = healthBarFill,
	})

	espObject.chams = cham
	espObject.Box = container
	espObject.healthBar = healthBar
	partRoot = partRoot or object

	function espObject:Update(isPlayer)
		root.settings.currentColors = root.settings.currentColors or {} :: types.twilightTheme
		local colors = {
			cham = root.settings.currentColors.highlightFillNeutral or Color3.new(0, 0, 0),
			chamOutline = root.settings.currentColors.highlightOutline or Color3.new(0, 0, 0),

			healthbar = root.settings.currentColors.healthBarFillNeutral or Color3.new(0, 0, 0),
			healthbarlow = root.settings.currentColors.healthBarFillNeutralLow or Color3.new(0, 0, 0),

			box = root.settings.currentColors.boxNeutral or Color3.new(0, 0, 0),
			boxoutline = root.settings.currentColors.boxOutlineNeutral or Color3.new(0, 0, 0),
		}

		isPlayer = isPlayer or false
		local flag
		if not isPlayer then
			flag = root.settings.showObjectNames or false
		else
			flag = true
		end

		local player = isPlayer and services.Players[object.Name]
		if player and not player.Neutral then
			if player.TeamColor ~= services.Players.LocalPlayer.TeamColor then
				if root.settings.chamsTeamCheck then
					colors.cham = root.settings.currentColors.highlightFillEnemy
				end
				if root.settings.healthbarTeamCheck then
					colors.healthbar = root.settings.currentColors.healthBarFillEnemy
					colors.healthbarlow = root.settings.currentColors.healthBarFillEnemyLow
				end
				if root.settings.boxTeamCheck then
					colors.box = root.settings.currentColors.boxEnemy
				end
				if root.settings.outlineBoxTeamCheck then
					colors.boxoutline = root.settings.currentColors.boxOutlineEnemy
				end
			elseif player ~= services.Players.LocalPlayer then
				if root.settings.chamsTeamCheck then
					colors.cham = root.settings.currentColors.highlightFillTeam
				end
				if root.settings.healthbarTeamCheck then
					colors.healthbar = root.settings.currentColors.healthBarFillTeam
					colors.healthbarlow = root.settings.currentColors.healthBarFillTeamLow
				end
				if root.settings.boxTeamCheck then
					colors.box = root.settings.currentColors.boxTeam
				end
				if root.settings.outlineBoxTeamCheck then
					colors.boxoutline = root.settings.currentColors.boxOutlineTeam
				end
			else
				if root.settings.chamsTeamCheck then
					colors.cham = root.settings.currentColors.highlightFillSelf
				end
				if root.settings.healthbarTeamCheck then
					colors.healthbar = root.settings.currentColors.healthBarFillSelf
					colors.healthbarlow = root.settings.currentColors.healthBarFillSelfLow
				end
				if root.settings.boxTeamCheck then
					colors.box = root.settings.currentColors.boxSelf
				end
				if root.settings.outlineBoxTeamCheck then
					colors.boxoutline = root.settings.currentColors.boxOutlineSelf
				end
			end
			if root.settings.useTeamColor then
				colors.cham = player.TeamColor.Color
				colors.healthbar = player.TeamColor.Color
				colors.box = player.TeamColor.Color
				colors.boxoutline = player.TeamColor.Color
			end
		end

		namelabel.Visible = flag
		cornerBoxes.Visible = root.settings.boxEnabled == nil and true or root.settings.boxEnabled
		boxOutline.Enabled = root.settings.outlineBoxEnabled or false
		cham.Enabled = root.settings.chamsEnabled or false
		cham.Parent = root.settings.chamsEnabled and object or nil
		if root.unloaded then
			cham.Enabled = false
			cham.Parent = nil
		end

		local minX, minY = math.huge, math.huge
		local maxX, maxY = -math.huge, -math.huge
		local onScreen = false

		container.NameLabel.Text = object.Name

		for _, part in ipairs(object:GetDescendants()) do
			if part:IsA("BasePart") then
				local size = part.Size / 2
				local corners = {
					Vector3.new(size.X, size.Y, size.Z),
					Vector3.new(-size.X, size.Y, size.Z),
					Vector3.new(size.X, -size.Y, size.Z),
					Vector3.new(-size.X, -size.Y, size.Z),
					Vector3.new(size.X, size.Y, -size.Z),
					Vector3.new(-size.X, size.Y, -size.Z),
					Vector3.new(size.X, -size.Y, -size.Z),
					Vector3.new(-size.X, -size.Y, -size.Z),
				}

				for _, offset in ipairs(corners) do
					local worldPoint = part.CFrame:PointToWorldSpace(offset)
					local screenPos, visible = workspace.CurrentCamera:WorldToViewportPoint(worldPoint)
					if visible then
						onScreen = true
					end
					minX = math.min(minX, screenPos.X)
					minY = math.min(minY, screenPos.Y)
					maxX = math.max(maxX, screenPos.X)
					maxY = math.max(maxY, screenPos.Y)
				end
			end
		end
		if object:IsA("Part") then
			local size = object.Size / 2
			local corners = {
				Vector3.new(size.X, size.Y, size.Z),
				Vector3.new(-size.X, size.Y, size.Z),
				Vector3.new(size.X, -size.Y, size.Z),
				Vector3.new(-size.X, -size.Y, size.Z),
				Vector3.new(size.X, size.Y, -size.Z),
				Vector3.new(-size.X, size.Y, -size.Z),
				Vector3.new(size.X, -size.Y, -size.Z),
				Vector3.new(-size.X, -size.Y, -size.Z),
			}

			for _, offset in ipairs(corners) do
				local worldPoint = object.CFrame:PointToWorldSpace(offset)
				local screenPos, visible = workspace.CurrentCamera:WorldToViewportPoint(worldPoint)
				if visible then
					onScreen = true
				end
				minX = math.min(minX, screenPos.X)
				minY = math.min(minY, screenPos.Y)
				maxX = math.max(maxX, screenPos.X)
				maxY = math.max(maxY, screenPos.Y)
			end
		end

		if onScreen then
			local width = maxX - minX
			local height = maxY - minY
			local centerX = (minX + maxX) / 2
			local centerY = (minY + maxY) / 2

			local scale = 1.7
			local boxWidth = width * scale > width + 106 and width * scale or width + 106
			local boxHeight = height * scale > height + 106 and height * scale or height + 106

			container.Visible = true
			container.Size = UDim2.fromOffset(boxWidth, boxHeight)
			container.Position = UDim2.fromOffset(centerX - boxWidth / 2, centerY - boxHeight / 2)
			boxFrame.Size = UDim2.fromOffset(boxWidth - 50, boxHeight - 50)
		else
			container.Visible = false
		end

		local hrp = players.LocalPlayer.Character:WaitForChild("HumanoidRootPart")
		local dist = (hrp.CFrame.Position - partRoot.Position).Magnitude
		container.Distance.Text = string.format("[%dm]", math.floor(dist))
		if root.settings.limitDistance ~= nil then
			if math.floor(dist) > tonumber(root.settings.limitDistance) then
				container.Distance.Text = ""
			end
		end

		if hrp and partRoot then
			-- WorldToViewportPoint returns (x, y, z), but visible only if z > 0 & inside screen
			local rootPos = workspace.CurrentCamera:WorldToViewportPoint(hrp.Position)
			local rootVec = Vector2.new(rootPos.X, rootPos.Y)

			local targetPos = workspace.CurrentCamera:WorldToViewportPoint(partRoot.Position)
			local targetVec = Vector2.new(targetPos.X, targetPos.Y)

			-- if behind camera, flip vector to screen center direction
			if targetPos.Z < 0 then
				targetVec = workspace.CurrentCamera.ViewportSize / 2
					- (targetVec - workspace.CurrentCamera.ViewportSize / 2)
			end

			-- clamp to screen bounds
			targetVec = Vector2.new(
				math.clamp(targetVec.X, 0, workspace.CurrentCamera.ViewportSize.X),
				math.clamp(targetVec.Y, 0, workspace.CurrentCamera.ViewportSize.Y)
			)

			-- midpoint + rotation
			local midpoint = (rootVec + targetVec) / 2
			local distance = (targetVec - rootVec).Magnitude

			tracer.Size = UDim2.fromOffset(distance, 1)
			tracer.Position = UDim2.fromOffset(midpoint.X, midpoint.Y)
			tracer.Rotation = math.deg(math.atan2(targetVec.Y - rootVec.Y, targetVec.X - rootVec.X))
			tracer.Visible = root.settings.tracersEnabled and true or false
		else
			tracer.Visible = false
		end

		if object:FindFirstChild("Humanoid") and root.settings.healthbarEnabled then
			healthBarFill.Size = UDim2.fromScale(object.Humanoid.Health / object.Humanoid.MaxHealth, 1)
			if (object.Humanoid.Health / object.Humanoid.MaxHealth) > 32 / 100 then
				--healthBarFill.BackgroundColor3 = root.settings.currentColors.HealthBarFillNeutral
				healthBarFill.BackgroundColor3 = colors.healthbar
			elseif root.settings.lowHealthAlert then
				healthBarFill.BackgroundColor3 = colors.healthbarlow
			end
		else
			healthBar.Visible = false
		end

		tracer.BackgroundColor3 = colors.boxoutline
		boxOutline.Color = colors.boxoutline
		cornerBoxes.ImageColor3 = colors.box
		cham.FillColor = colors.cham
		cham.OutlineColor = colors.chamOutline
	end

	function espObject:Destroy()
		container:Destroy()
		cham:Destroy()
		tracer:Destroy()

		function espObject:Update() end
	end

	return espObject
end

root.espInstance = espInstance
return espInstance
