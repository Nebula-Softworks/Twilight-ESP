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

	Library.ObjectESPs.Highlights[object] = highlight

	local self = {
		Box = box,
		Tracer = tracer,
		HealthBar = healthBar,
		Info = info,
		Snapline = snapline,
		rootPart = rootPart,
		highlight = highlight,
	}
	Library.ObjectESPs.ESPs[object] = self

	return self
end

function ObjectESP:UpdateESP(library) end

function ObjectESP:RemoveESP(Library)
	local esp = self
	if esp then
		for _, obj in pairs(esp.Box) do
			obj:Destroy()
		end
		esp.Tracer:Destroy()
		for _, obj in pairs(esp.HealthBar) do
			obj:Destroy()
		end
		for _, obj in pairs(esp.Info) do
			obj:Destroy()
		end
		esp.Snapline:Destroy()
		self = nil
	end

	local highlight = esp.highlight
	if highlight then
		highlight:Destroy()
		highlight = nil
	end
end

return ObjectESP
