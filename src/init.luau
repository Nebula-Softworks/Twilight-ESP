local services = require("@root/utilities/services")
local playerEsp = require("@root/components/playerEsp")
local radarEsp = require("@root/components/radarEsp")
local objectEsp = require("@root/components/objectEsp")

local Players = services.Players
local RunService = services.RunService
local UserInputService = services.UserInputService
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

local Twilight = {
	Settings = {
		-- Generic is anything not in a team, including external/custom objects bounded to an ESP instance

		Enabled = false,
		ObjectsEnabled = false,

		Checks = {
			Visible = {
				Enabled = false,
				OnlyVisible = false,
				Recolor = false, -- enable visible and invisible variations of colours.
			},
			Team = {
				Enabled = false,
				SelectedTeams = {
					enemy = false,
					friendly = false,
					generic = false,
					["local"] = false,
				},
			},
		},

		currentColors = {
			generic = {
				Box = {
					Outline = {
						Visible = Color3.new(1, 1, 1),
						Invisible = Color3.new(1, 1, 1),
					},
					Fill = {
						Visible = Color3.new(1, 1, 1),
						Invisible = Color3.new(1, 1, 1),
					},
				},

				HealthBar = {
					Outline = Color3.new(1, 1, 1),
					Fills = {
						Low = Color3.new(1, 1, 1),
						Medium = Color3.new(1, 1, 1),
						High = Color3.new(1, 1, 1),
					},
				},

				Tracer = {
					Visible = Color3.new(1, 1, 1),
					Invisible = Color3.new(1, 1, 1),
				},

				Text = Color3.new(1, 1, 1),

				Chams = {
					Outline = {
						Visible = Color3.new(1, 1, 1),
						Invisible = Color3.new(1, 1, 1),
					},
					Fill = {
						Visible = Color3.new(1, 1, 1),
						Invisible = Color3.new(1, 1, 1),
					},
				},

				Skeleton = {
					Visible = Color3.new(1, 1, 1),
					Invisible = Color3.new(1, 1, 1),
				},
			},
			friendly = {
				Box = {
					Outline = {
						Visible = Color3.new(1, 1, 1),
						Invisible = Color3.new(1, 1, 1),
					},
					Fill = {
						Visible = Color3.new(1, 1, 1),
						Invisible = Color3.new(1, 1, 1),
					},
				},

				HealthBar = {
					Outline = Color3.new(1, 1, 1),
					Fills = {
						Low = Color3.new(1, 1, 1),
						Medium = Color3.new(1, 1, 1),
						High = Color3.new(1, 1, 1),
					},
				},

				Tracer = {
					Visible = Color3.new(1, 1, 1),
					Invisible = Color3.new(1, 1, 1),
				},

				Text = Color3.new(1, 1, 1),

				Chams = {
					Outline = {
						Visible = Color3.new(1, 1, 1),
						Invisible = Color3.new(1, 1, 1),
					},
					Fill = {
						Visible = Color3.new(1, 1, 1),
						Invisible = Color3.new(1, 1, 1),
					},
				},

				Skeleton = {
					Visible = Color3.new(1, 1, 1),
					Invisible = Color3.new(1, 1, 1),
				},
			},
			enemy = {
				Box = {
					Outline = {
						Visible = Color3.new(1, 1, 1),
						Invisible = Color3.new(1, 1, 1),
					},
					Fill = {
						Visible = Color3.new(1, 1, 1),
						Invisible = Color3.new(1, 1, 1),
					},
				},

				HealthBar = {
					Outline = Color3.new(1, 1, 1),
					Fills = {
						Low = Color3.new(1, 1, 1),
						Medium = Color3.new(1, 1, 1),
						High = Color3.new(1, 1, 1),
					},
				},

				Tracer = {
					Visible = Color3.new(1, 1, 1),
					Invisible = Color3.new(1, 1, 1),
				},

				Text = Color3.new(1, 1, 1),

				Chams = {
					Outline = {
						Visible = Color3.new(1, 1, 1),
						Invisible = Color3.new(1, 1, 1),
					},
					Fill = {
						Visible = Color3.new(1, 1, 1),
						Invisible = Color3.new(1, 1, 1),
					},
				},

				Skeleton = {
					Visible = Color3.new(1, 1, 1),
					Invisible = Color3.new(1, 1, 1),
				},
			},
			["local"] = {
				Box = {
					Outline = {
						Visible = Color3.new(1, 1, 1),
						Invisible = Color3.new(1, 1, 1),
					},
					Fill = {
						Visible = Color3.new(1, 1, 1),
						Invisible = Color3.new(1, 1, 1),
					},
				},

				HealthBar = {
					Outline = Color3.new(1, 1, 1),
					Fills = {
						Low = Color3.new(1, 1, 1),
						Medium = Color3.new(1, 1, 1),
						High = Color3.new(1, 1, 1),
					},
				},

				Tracer = {
					Visible = Color3.new(1, 1, 1),
					Invisible = Color3.new(1, 1, 1),
				},

				Text = Color3.new(1, 1, 1),

				Chams = {
					Outline = {
						Visible = Color3.new(1, 1, 1),
						Invisible = Color3.new(1, 1, 1),
					},
					Fill = {
						Visible = Color3.new(1, 1, 1),
						Invisible = Color3.new(1, 1, 1),
					},
				},

				Skeleton = {
					Visible = Color3.new(1, 1, 1),
					Invisible = Color3.new(1, 1, 1),
				},
			},
		},

		HealthBar = {
			Enabled = {
				enemy = false,
				friendly = false,
				["local"] = false,
				generic = false,
			},

			Bar = false,
			Text = false,

			Position = 1, -- 1 - left, 2 - right
			Suffix = "HP",
		},

		Box = {
			Style = 1, -- 1 Corners, 2 Box, 3 3D, maybe in future ill add quad (oriented box)
			Enabled = false,
			Filled = {
				Enabled = false,
				Transparency = 0.6,
			},
			Thickness = 1,
		},

		Tracer = {
			Enabled = {
				enemy = false,
				friendly = false,
				generic = false,
			},
			Origin = 1, -- 1 Local HRP, 2 Bottom Viewport, 3 Top Viewport, 4 Center Viewport, 5 Mouse
			Style = 1, -- 1 Line
			Thickness = 1, --px
		},

		Name = {
			Enabled = {
				enemy = false,
				friendly = false,
				["local"] = false,
				generic = false,
			},

			Style = 1, -- 1 Display Name, 2 User Name
		},
		Distance = {
			Enabled = {
				enemy = false,
				friendly = false,
				["local"] = false,
				generic = false,
			},
			DistanceUnit = 1, -- 1 studs, 2 meters
		},

		Chams = {
			Enabled = {
				enemy = false,
				friendly = false,
				["local"] = false,
				generic = false,
			},
			Outline = {
				Enabled = true,
				Thickness = 0.1, --px
				Transparency = 0,
			},
			Fill = {
				Enabled = true,
				Transparency = 0.5,
			},
			Occlusion = false,
		},

		Skeleton = {
			Enabled = {
				enemy = false,
				friendly = false,
				["local"] = false,
				generic = false,
			},
			Thickness = 1, --px
			Transparency = 1,
			ExplicitBodyType = nil, -- 1 R15, 2 R6. But not required as the esp will auto detect body types
		},

		TextSize = 14,
		MaxDistance = 2000, -- studs
		RefreshRate = 1 / 120,

		Snaplines = true,
	},

	Drawings = {
		ESP = {},
		Tracers = {},
		Boxes = {},
		Healthbars = {},
		Names = {},
		Distances = {},
		Snaplines = {},
		Skeleton = {},

		ObjectESPs = {
			Highlights = {},
			ESPs = {},
		},
		Radar = {},
	},
	Highlights = {},

	_connections = {},
}

function Twilight:Unload()
	for _, player in ipairs(Players:GetPlayers()) do
		playerEsp:RemoveESP(Twilight, player)
	end
	for _, esp in ipairs(Twilight.Drawings.ObjectESPs) do
		esp:RemoveESP(Twilight)
	end
	Twilight.Drawings.ESP = {}
	Twilight.Drawings.Skeleton = {}
	Twilight.Drawings.Radar = {}
	Twilight.ObjectESPs.Highlights = {}
	Twilight.ObjectESPs = {}
	Twilight.Drawings = {}
	Twilight.Highlights = {}
	for _, connection in pairs(Twilight._connections) do
		connection:Disconnect()
		connection = nil
	end
end

function Twilight:DisablePlayerESP()
	for _, player in ipairs(Players:GetPlayers()) do
		local esp = Twilight.Drawings.ESP[player]
		if esp then
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
		end

		-- Also hide skeleton
		local skeleton = Twilight.Drawings.Skeleton[player]
		if skeleton then
			for _, line in pairs(skeleton) do
				line.Visible = false
			end
		end

		local Highlight: Highlight = Twilight.Highlights[player]
		if Highlight then
			Highlight.Enabled = false
		end
	end
end

function Twilight:DisableObjectESP()
	if not Twilight.ObjectESPs then
		return
	end
	if not Twilight.ObjectESPs.ESPs then
		return
	end
	for _, esp in pairs(Twilight.ObjectESPs.ESPs) do
		if esp then
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
		end
	end
	for _, highlight in pairs(Twilight.ObjectESPs.Highlights) do
		if highlight then
			highlight.Enabled = false
		end
	end
end

function Twilight:EnablePlayerRadar() end
function Twilight:DisablePlayerRadar() end

function Twilight:BindESPToObject(object, rootPart)
	return objectEsp.CreateESP(Twilight, object, rootPart)
end

local lastUpdate, lastUpdate1 = 0, 0
table.insert(
	Twilight._connections,
	RunService.RenderStepped:Connect(function()
		if not Twilight.Settings.Enabled then
			Twilight:DisablePlayerESP()
			return
		end
		local currentTime = tick()
		if currentTime - lastUpdate >= Twilight.Settings.RefreshRate then
			for _, player in ipairs(Players:GetPlayers()) do
				if not Twilight.Drawings.ESP[player] then
					playerEsp:CreateESP(Twilight, player)
				end
				playerEsp:UpdateESP(Twilight, player)
			end
			lastUpdate = currentTime
		end
	end)
)
table.insert(
	Twilight._connections,
	RunService.RenderStepped:Connect(function()
		if not Twilight.Settings.ObjectsEnabled then
			Twilight:DisableObjectESP()
			return
		end

		local currentTime = tick()
		if currentTime - lastUpdate1 >= Twilight.Settings.RefreshRate then
			if not Twilight.ObjectESPs then
				return
			end
			for _, esp in pairs(Twilight.ObjectESPs.ESPs) do
				if esp then
					esp:UpdateESP(Twilight)
				end
			end
			lastUpdate1 = currentTime
		end
	end)
)

table.insert(
	Twilight._connections,
	Players.PlayerAdded:Connect(function(player)
		playerEsp:CreateESP(Twilight, player)
	end)
)
table.insert(
	Twilight._connections,
	Players.PlayerRemoving:Connect(function(player)
		playerEsp:RemoveESP(Twilight, player)
	end)
)

for _, player in ipairs(Players:GetPlayers()) do
	playerEsp:CreateESP(Twilight, player)
end

return Twilight
