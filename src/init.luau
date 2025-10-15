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
				CornerBox = {
					Visible = Color3.new(1, 1, 1),
					Invisible = Color3.new(1, 1, 1),
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
				CornerBox = {
					Visible = Color3.new(1, 1, 1),
					Invisible = Color3.new(1, 1, 1),
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
				CornerBox = {
					Visible = Color3.new(1, 1, 1),
					Invisible = Color3.new(1, 1, 1),
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
			self = {
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
				CornerBox = {
					Visible = Color3.new(1, 1, 1),
					Invisible = Color3.new(1, 1, 1),
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

		healthBarSettings = {
			Enabled = {
				enemy = false,
				friendly = false,
				self = false,
				generic = false,
			},

			Bar = false,
			Text = false,
			MaxHealthEnabled = false,

			Position = 1, -- 1 - left, 2 - right
			Suffix = "HP",
		},

		Style = 1, -- 1 Normal, 2 3D
		Box = {
			Enabled = false,
			Filled = {
				Enabled = false,
				Transparency = 0.6,
			},
			Thickness = 1,
		},
		CornerBox = {
			Enabled = false,
			Thickness = 3,
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

			Style = 1, -- 1 Display Name, 2 User Name, 3 Both
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
                Transparency = 0.5
            },
			OutlineThickness = 0.1,
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
		MaxDistance = 2000,
		RefreshRate = 1 / 240,

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
	},
	Highlights = {},

	_connections = {},
}

function Twilight.CleanupESP()
	for _, player in ipairs(Players:GetPlayers()) do
		playerEsp:RemoveESP(Twilight, player)
	end
	Twilight.Drawings.ESP = {}
	Twilight.Drawings.Skeleton = {}
	Twilight.Highlights = {}
end

function Twilight:Load() end

function Twilight:Unload(destroy) end

function Twilight:BindESPToObject(object, rootPart) end

function Twilight:EnablePlayerESP() end

function Twilight:DisablePlayerESP() end

return Twilight
