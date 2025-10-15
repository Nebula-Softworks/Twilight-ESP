local services = require("@root/utilities/services")
local playerEsp = require("@root/components/playerEsp")

local Players = services.Players
local RunService = services.RunService
local UserInputService = services.UserInputService
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

local Twilight = {
	Settings = {
		-- Generic is anything not in a team, including external/custom objects bounded to an ESP instance

		Enabled = false,
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
					self = false,
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

				healthBar = {
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

				healthBar = {
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
			["self"] = {
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

				healthBar = {
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
				self = false,
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
				self = false,
				generic = false,
			},

			Style = 1, -- 1 Display Name, 2 User Name
		},
		Distance = {
			Enabled = {
				enemy = false,
				friendly = false,
				self = false,
				generic = false,
			},
			DistanceUnit = 1, -- 1 studs, 2 meters
		},

		Chams = {
			Enabled = {
				enemy = false,
				friendly = false,
				self = false,
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
				self = false,
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

		ObjectESPs = {},
	},
	Highlights = {},

	_connections = {},
}

local isAlreadyUnloaded = false
function Twilight:Load()
	Twilight.Settings.Enabled = true
	isAlreadyUnloaded = false
end

function Twilight:Unload(destroy)
	Twilight.Settings.Enabled = false
	isAlreadyUnloaded = true
	if destroy then
		for _, player in ipairs(Players:GetPlayers()) do
			playerEsp:RemoveESP(Twilight, player)
		end
		Twilight.Drawings.ESP = {}
		Twilight.Drawings.Skeleton = {}
		Twilight.Highlights = {}
		for _, connection in pairs(Twilight._connections) do
			connection:Disconnect()
			connection = nil
		end
	else
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
		end
	end
end

function Twilight:BindESPToObject(object, rootPart) end

local lastUpdate = 0
table.insert(
	Twilight._connections,
	RunService.RenderStepped:Connect(function()
		if not Twilight.Settings.Enabled then
			if not isAlreadyUnloaded then
				Twilight:Unload(false)
			end
			return
		end

		local currentTime = tick()
		if currentTime - lastUpdate >= Twilight.Settings.RefreshRate then
			for _, player in ipairs(Players:GetPlayers()) do
				if player ~= LocalPlayer then
					if not Twilight.Drawings.ESP[player] then
						playerEsp:CreateESP(Twilight, player)
					end
					playerEsp:UpdateESP(Twilight, player)
				end
			end
			lastUpdate = currentTime
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

function Twilight:EnablePlayerESP() end

function Twilight:DisablePlayerESP() end

return Twilight
