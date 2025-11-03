local services = require("@root/utilities/services")
local playerEsp = require("@root/components/playerEsp")
local radarEsp = require("@root/components/radarEsp")
local objectEsp = require("@root/components/objectEsp")

local Players = services.Players
local RunService = services.RunService

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
			Radar = {
				Background = Color3.fromRGB(5, 5, 5),
				Border = Color3.fromRGB(35, 35, 35),
			},
		},

		HealthBar = {
			Enabled = {
				enemy = false,
				friendly = false,
				["local"] = false,
				generic = false,
			},

			Source = function(plr)
				return plr.Character.Humanoid
			end,

			Bar = false,
			Text = false,

			Position = 1,
			Suffix = "HP",
		},

		Box = {
			Style = 1,
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
			Origin = 1,
			Style = 1,
			Thickness = 1, --px
		},

		Name = {
			Enabled = {
				enemy = false,
				friendly = false,
				["local"] = false,
				generic = false,
			},

			Style = 1,
		},
		Distance = {
			Enabled = {
				enemy = false,
				friendly = false,
				["local"] = false,
				generic = false,
			},
			DistanceUnit = 1,
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
				Thickness = 0.1,
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
			ExplicitBodyType = nil,
		},

		Radar = {
			Enabled = true,
			Position = Vector2.new(workspace.CurrentCamera.ViewportSize.X - 120, 120),
			Radius = 100, -- Radius Of The Circle, Hence The Circle will be 200x200
			Scale = 1, -- Determinatant Factor on the effect of the relative pos for 2D replacement
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
		Radar = {},
		Skeleton = {},
	},

	ObjectESPs = {
		Highlights = {},
		ESPs = {},
	},

	Highlights = {},

	_connections = {},

	Enums = {
		HealthBarPosition = {
			Left = 1,
			Right = 2,
		},
		HealthSource = {
			NRPBS = function(plr)
				return plr.NRPBS -- arsenal support
			end,
			Humanoid = function(plr)
				return plr.Character.Humanoid
			end,
		},
		BoxStyle = {
			CornerBoxes = 1,
			Normal = 2,
			["3D"] = 3,
			Quad = 4,
		},
		TracerOrigin = {
			LocalHumanoid = 1,
			Mouse = 5,
			Viewports = {
				Bottom = 2,
				Top = 3,
				Center = 4,
			},
		},
		TracerStyle = {
			Line = 1,
		},
		NameStyle = {
			Username = 1,
			DisplayName = 2,
		},
		DistanceUnit = {
			Studs = 1,
			Meters = 2,
		},
	},
}
radarEsp:init(Twilight)

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

function Twilight:BindESPToObject(object, rootPart)
	task.defer(function()
		task.wait(1)
		radarEsp:updateobjectlist(Twilight)
	end)
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
