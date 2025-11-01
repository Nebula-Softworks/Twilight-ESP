local RadarESP = {}

RadarESP.EspObjects = {}
RadarESP.ExistingESPs = {}
local services = require("@root/utilities/services")
local utilities = require("@root/utilities")
local drawer = require("@root/utilities/drawer")

local Players = services.Players
local RunService = services.RunService
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

local playercolorfunc = utilities.GetPlayerColor

function RadarESP:init(Library)
	RadarESP:updateobjectlist(Library)
	RadarESP.Library = Library
end
function RadarESP:updateobjectlist(Library)
	RadarESP.EspObjects = {}
	for Object, _ in pairs(Library.ObjectESPs.ESPs) do
		table.insert(RadarESP.EspObjects, Object)
		if not table.find(RadarESP.ExistingESPs, Object) then
			RadarESP:PlaceObjectDot(Object)
		end
	end
end

task.defer(function()
	repeat
		task.wait()
	until LocalPlayer.Character ~= nil and LocalPlayer.Character.PrimaryPart ~= nil and RadarESP.Library

	-- I am creating a function this way as I wont have to set the properties every time
	local function DrawCircle(Transparency, Color, Radius, Filled, Thickness)
		return drawer.new("Circle", {
			Transparency = Transparency,
			Color = Color,
			Visible = false,
			Thickness = Thickness,
			Position = Vector2.new(0, 0),
			Radius = Radius,
			NumSides = math.clamp(Radius * 55 / 100, 10, 75),
			Filled = Filled,
		})
	end

	local RadarBackground = DrawCircle(
		0.9,
		RadarESP.Library.Settings.currentColors.Radar.Background,
		RadarESP.Library.Settings.Radar.Radius,
		true,
		1
	)
	RadarBackground.Visible = true
	RadarBackground.Position = RadarESP.Library.Settings.Radar.Position

	local RadarBorder = DrawCircle(
		0.75,
		RadarESP.Library.Settings.currentColors.Radar.Border,
		RadarESP.Library.Settings.Radar.Radius,
		false,
		3
	)
	RadarBorder.Visible = true
	RadarBorder.Position = RadarESP.Library.Settings.Radar.Position

	local function GetRelative(pos)
		local char = LocalPlayer.Character
		if char ~= nil and char.PrimaryPart ~= nil then
			local pmpart = char.PrimaryPart
			local camerapos = Vector3.new(Camera.CFrame.Position.X, pmpart.Position.Y, Camera.CFrame.Position.Z)
			local newcf = CFrame.new(pmpart.Position, camerapos)
			local r = newcf:PointToObjectSpace(pos)
			return r.X, r.Z
		else
			return 0, 0
		end
	end

	local function PlaceDot(plr)
		local _, isVisible = Camera:WorldToViewportPoint(plr.Character.PrimaryPart.Position)

		local PlayerDot =
			DrawCircle(1, playercolorfunc(utilities, RadarESP.Library, plr, isVisible, "Box", "Outline"), 3, true, 1)

		local function Update()
			local c
			c = RunService.RenderStepped:Connect(function()
				local char = plr.Character
				if
					char
					and char:FindFirstChildOfClass("Humanoid")
					and char.PrimaryPart ~= nil
					and char:FindFirstChildOfClass("Humanoid").Health > 0
				then
					local _hum = char:FindFirstChildOfClass("Humanoid")
					local scale = RadarESP.Library.Settings.Radar.Scale
					local relx, rely = GetRelative(char.PrimaryPart.Position)
					local newpos = RadarESP.Library.Settings.Radar.Position - Vector2.new(relx * scale, rely * scale)

					if
						(newpos - RadarESP.Library.Settings.Radar.Position).magnitude
						< RadarESP.Library.Settings.Radar.Radius - 2
					then
						PlayerDot.Radius = 3
						PlayerDot.Position = newpos
						PlayerDot.Visible = true
					else
						local dist = (RadarESP.Library.Settings.Radar.Position - newpos).magnitude
						local calc = (RadarESP.Library.Settings.Radar.Position - newpos).unit
							* (dist - RadarESP.Library.Settings.Radar.Radius)
						local inside = Vector2.new(newpos.X + calc.X, newpos.Y + calc.Y)
						PlayerDot.Radius = 2
						PlayerDot.Position = inside
						PlayerDot.Visible = true
					end

					PlayerDot.Color = playercolorfunc(utilities, RadarESP.Library, plr, isVisible, "Box", "Outline")

					PlayerDot.Visible = true
					if not RadarESP.Library.Settings.Radar.Enabled then
						PlayerDot.Visible = false
					end
				else
					PlayerDot.Visible = false
					if Players:FindFirstChild(plr.Name) == nil then
						pcall(PlayerDot.Destroy, PlayerDot)
						pcall(PlayerDot.Remove, PlayerDot)
						c:Disconnect()
					end
				end
			end)
		end
		coroutine.wrap(Update)()
	end

	for _, v in pairs(Players:GetChildren()) do
		print(typeof(v))
		if v ~= LocalPlayer then
			PlaceDot(v)
		end
	end

	local function NewLocalDot()
		local d = drawer.new("Triangle", {
			Visible = true,
			Thickness = 1,
			Filled = true,
			Color = playercolorfunc(RadarESP.Library, LocalPlayer, true, "Box", "Outline"),
			PointA = RadarESP.Library.Settings.Radar.Position + Vector2.new(0, -6),
			PointB = RadarESP.Library.Settings.Radar.Position + Vector2.new(-3, 6),
			PointC = RadarESP.Library.Settings.Radar.Position + Vector2.new(3, 6),
		})
		coroutine.wrap(function()
			RunService.RenderStepped:Connect(function()
				d.Visible = true
				if not RadarESP.Library.Settings.Radar.Enabled then
					d.Visible = false
				end
			end)
		end)()
		return d
	end

	local LocalPlayerDot = NewLocalDot()

	Players.PlayerAdded:Connect(function(v)
		if v ~= LocalPlayer then
			PlaceDot(v)
		end
		pcall(LocalPlayerDot.Destroy, LocalPlayerDot)
		pcall(LocalPlayerDot.Remove, LocalPlayerDot)
		LocalPlayerDot = NewLocalDot()
	end)

	function RadarESP:PlaceObjectDot(object)
		table.insert(RadarESP.ExistingESPs, object)

		local pos = object:IsA("Model") and object:GetBoundingBox() or object.Position

		local _, isVisible = Camera:WorldToViewportPoint(pos)

		local helper = { Neutral = true }
		local ObjectDot = drawer.new("Square", {
			Transparency = 1,
			Color = playercolorfunc(utilities, RadarESP.Library, helper, isVisible, "Box", "Outline"),
			Visible = false,
			Thickness = 1,
			Position = Vector2.new(0, 0),
			Size = Vector2.new(6, 6),
			Filled = true,
		})

		local function Update()
			local c
			c = RunService.RenderStepped:Connect(function()
				if object then
					local scale = RadarESP.Library.Settings.Radar.Scale
					local relx, rely = GetRelative(pos)
					local newpos = RadarESP.Library.Settings.Radar.Position - Vector2.new(relx * scale, rely * scale)

					if
						(newpos - RadarESP.Library.Settings.Radar.Position).magnitude
						< RadarESP.Library.Settings.Radar.Radius - 2
					then
						ObjectDot.Size = Vector2.new(6, 6)
						ObjectDot.Position = newpos - Vector2.new(3, 3)
						ObjectDot.Visible = true
					else
						local dist = (RadarESP.Library.Settings.Radar.Position - newpos).magnitude
						local calc = (RadarESP.Library.Settings.Radar.Position - newpos).unit
							* (dist - RadarESP.Library.Settings.Radar.Radius)
						local inside = Vector2.new(newpos.X + calc.X, newpos.Y + calc.Y)
						ObjectDot.Size = Vector2.new(4, 4)
						ObjectDot.Position = inside - Vector2.new(2, 2)
						ObjectDot.Visible = true
					end

					ObjectDot.Color = playercolorfunc(utilities, RadarESP.Library, helper, isVisible, "Box", "Outline")

					ObjectDot.Visible = true
					if not RadarESP.Library.Settings.Radar.Enabled then
						ObjectDot.Visible = false
					end
				else
					ObjectDot.Visible = false
					pcall(ObjectDot.Destroy, ObjectDot)
					pcall(ObjectDot.Remove, ObjectDot)
					table.remove(RadarESP.ExistingESPs, table.find(RadarESP.ExistingESPs, object))
					c:Disconnect()
				end
			end)
		end
		coroutine.wrap(Update)()
	end

	-- Loop
	coroutine.wrap(function()
		local c
		c = RunService.RenderStepped:Connect(function()
			if not RadarESP.Library then
				return
			end
			if LocalPlayerDot ~= nil then
				LocalPlayerDot.Color = playercolorfunc(utilities, RadarESP.Library, LocalPlayer, true, "Box", "Outline")
				LocalPlayerDot.PointA = RadarESP.Library.Settings.Radar.Position + Vector2.new(0, -6)
				LocalPlayerDot.PointB = RadarESP.Library.Settings.Radar.Position + Vector2.new(-3, 6)
				LocalPlayerDot.PointC = RadarESP.Library.Settings.Radar.Position + Vector2.new(3, 6)
			end
			RadarBackground.Position = RadarESP.Library.Settings.Radar.Position
			RadarBackground.Radius = RadarESP.Library.Settings.Radar.Radius
			RadarBackground.Color = RadarESP.Library.Settings.currentColors.Radar.Background

			RadarBorder.Position = RadarESP.Library.Settings.Radar.Position
			RadarBorder.Radius = RadarESP.Library.Settings.Radar.Radius
			RadarBorder.Color = RadarESP.Library.Settings.currentColors.Radar.Border

			if not RadarESP.Library.Settings.Radar.Enabled then
				RadarBorder.Visible = false
				RadarBackground.Visible = false
			else
				RadarBorder.Visible = true
				RadarBackground.Visible = true
			end
		end)
	end)()
end)

return RadarESP
