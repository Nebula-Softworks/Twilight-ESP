local services = require("@self/utilities/services")
local playerEsp = require("@self/components/playerEsp")
local radarEsp = require("@self/components/radarEsp")
local objectEsp = require("@self/components/objectEsp")

local types = require("@self/types")

local Players = services.Players
local RunService = services.RunService

local Twilight = {
	Settings = {

		-- Generic is anything not in a team, including external/custom objects bounded to an ESP instance
		Enabled = false,
		ObjectsEnabled = false,

		Checks = {
			Visible = {
				Enabled = false, -- required for the next 2 checks
				OnlyVisible = false, -- makes it show only visible players
				Recolor = false, -- enable visible and invisible variations of colours.
			},
			Team = {
				Enabled = false, -- whether team check will be enabled. required for SelectedTeams
				SelectedTeams = { -- if TeamCheck is enabled, only the following teams with 'true' will be enabled root-ly
					enemy = false,
					friendly = false,
					generic = false,
					["local"] = false,
				},
			},
		},

		-- Team, Category, Property, Invisible and Visible Variations - Visible is default used if recoloring is turned off
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
			} :: types.TwilightColorSet,
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
			} :: types.TwilightColorSet,
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
			} :: types.TwilightColorSet,
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
			} :: types.TwilightColorSet,
			Radar = {
				Background = Color3.fromRGB(5, 5, 5),
				Border = Color3.fromRGB(35, 35, 35),
			},
		} :: types.TwilightColors,

		HealthBar = {
			Enabled = { -- enabled for what variations
				enemy = false,
				friendly = false,
				["local"] = false,
				generic = false,
			},

			Source = function(plr) -- health source/where the library will get health properties from. Arsenal Support. Use Enum HealthSource
				return plr.Character.Humanoid
			end,

			Bar = false, -- Display The Bar
			Text = false, -- Display The Health as text

			Position = 1, -- Position of the bar and text. Use Enum HealthBarPosition
			Suffix = "HP", -- Trailing Text for HP Text
		},

		Box = {
			Style = 1, -- Style of Box. Use Enum BoxStyle
			Enabled = false,
			Filled = {
				Enabled = false,
				Transparency = 0.6,
			},
			Thickness = 1, -- in pixels
		},

		Tracer = {
			Enabled = { -- enabled for what variations
				enemy = false,
				friendly = false,
				generic = false,
			},
			Origin = 1, -- Tracer Origin. Use Enum TracerOrigin. Can be Local HRP, Following Mouse, Center, Top or Bottom
			Style = 1, -- Tracer Style. Use Enum TracerStyle
			Thickness = 1, --px
		},

		Name = {
			Enabled = { -- enabled for what variations
				enemy = false,
				friendly = false,
				["local"] = false,
				generic = false,
			},

			Style = 1, -- Which Name Source To Use. Use Enum NameStyle.
		},
		Distance = {
			Enabled = { -- enabled for what variations
				enemy = false,
				friendly = false,
				["local"] = false,
				generic = false,
			},
			DistanceUnit = 1, -- Unit Of Measurement. Use Enum DistanceUnit
		},

		Chams = {
			Enabled = { -- enabled for what variations
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
			Occlusion = false, -- whether the highlight/cham will not show through walls.
		},

		Skeleton = {
			Enabled = { -- enabled for what variations
				enemy = false,
				friendly = false,
				["local"] = false,
				generic = false,
			},
			Thickness = 1, --px
			Transparency = 0,
			ExplicitBodyType = nil, -- Explicitly set what type of skeleton should be shown. Not working atm. Use Enum SkeletonBodyType.
		},

		Radar = {
			Enabled = true,
			Position = Vector2.new(workspace.CurrentCamera.ViewportSize.X - 120, 120),
			Radius = 100, -- Radius Of The Circle, Hence The Circle will be 200x200
			Scale = 1, -- Determinatant Factor on the effect of the relative pos for 2D replacement
		},

		TextSize = 14,
		MaxDistance = 2000, -- Measured in studs
		RefreshRate = 1 / 120,

		Snaplines = true, -- deprecated and removed mid development in favor of tracers. will be removed here soon.
	} :: types.TwilightSettings,

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
	Highlights = {},

	ObjectESPs = {
		Highlights = {},
		ESPs = {},
	},

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
		SkeletonBodyType = {
			Dynamic = nil,
			["R6"] = 1,
			["R15"] = 2,
		},
	} :: types.TwilightEnums,
	_connections = {},
} :: types.TwilightLibrary
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

local function kwarigfy(defaults, passed)
	defaults = defaults or {}
	for i, v in pairs(defaults) do
		if type(v) == "table" then
			passed[i] = kwarigfy(v, passed[i] or {})
			continue
		end
		if passed[i] == nil then
			passed[i] = v
		end
	end
	return passed
end

function Twilight:SetOptions(options: types.TwilightSettings)
	options = options or {}
	local currentOptions = Twilight.Settings
	Twilight.Settings = kwarigfy(currentOptions, options)
end

return Twilight
