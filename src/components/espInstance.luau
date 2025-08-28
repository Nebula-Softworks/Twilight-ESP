-- TODO add tracers

local services = require(script.Parent.Parent.utilities.services)
local root = require(script.Parent.Parent)
local creator = require(script.Parent.Parent.utilities.creator)
local types = require(script.Parent.Parent.types)

local players = services.Players

local espInstance = {}

function espInstance:Create(object, distanceRoot, showName)
	showName = showName == nil and true or showName

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
	creator.New("TextLabel", {
		Name = "NameLabel",
		Size = UDim2.new(1, 0, 0, 14),
		Position = UDim2.fromScale(0, -0.1),
		Parent = container,
		Visible = showName,
	})
	local boxContainer = creator.New("CanvasGroup", {
		Name = "Recolorer",
		Parent = container,
		--[[root.settings.currentColors.boxOutlineNeutral or ]]
		GroupColor3 = Color3.new(1, 1, 1),
	})
	local cornerBoxes = creator.New("ImageLabel", {
		Name = "CornerBoxes",
		Image = "rbxassetid://85554062016173",
		ScaleType = Enum.ScaleType.Slice,
		SliceCenter = Rect.new(142, 156, 861, 861),
		SliceScale = 0.32,
		ZIndex = 2,
		Parent = boxContainer,
	})
	local boxFrame = creator.New("Frame", {
		Size = UDim2.new(1, -70, 1, -70),
		Position = UDim2.fromOffset(35, 35),
		Parent = boxContainer,
	})
	local boxOutline = creator.New("UIStroke", {
		Thickness = 1,
		Parent = boxFrame,
	})
	local cham = creator.New("Highlight", {
		--[[root.settings.currentColors.highlightFillNeutral or ]]
		FillColor = Color3.new(1, 1, 1),
		Parent = object,
	})

	espObject.chams = cham
	espObject.Box = container
	distanceRoot = distanceRoot or object

	function espObject:Update()
		cornerBoxes.Visible = root.settings.boxEnabled == nil and true or root.settings.boxEnabled
		boxOutline.Enabled = root.settings.outlineBoxEnabled or false
		cham.Enabled = root.settings.chamsEnabled or false

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
						minX = math.min(minX, screenPos.X)
						minY = math.min(minY, screenPos.Y)
						maxX = math.max(maxX, screenPos.X)
						maxY = math.max(maxY, screenPos.Y)
					end
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
					minX = math.min(minX, screenPos.X)
					minY = math.min(minY, screenPos.Y)
					maxX = math.max(maxX, screenPos.X)
					maxY = math.max(maxY, screenPos.Y)
				end
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
		else
			container.Visible = false
		end

		local hrp = players.LocalPlayer.Character:WaitForChild("HumanoidRootPart")
		local dist = (hrp.CFrame.Position - distanceRoot.Position).Magnitude
		container.Distance.Text = string.format("[%dm]", math.floor(dist))
	end

	root.espObjects[object] = espObject
	return espObject
end

-- we have this seperately cus apprently constantly assigning new color3 is not good for performance
function espInstance:UpdateThemes() end
function espInstance:Set(boxEnabled, chamsEnabled) end

root.espInstance = espInstance
return espInstance
