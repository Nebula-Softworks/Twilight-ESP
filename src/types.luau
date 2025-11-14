export type TwilightLibrary = {
	Settings: TwilightSettings,

	Drawings: {
		ESP: {
			[any]: any,
		},
		Tracers: {
			[any]: any,
		},
		Boxes: {
			[any]: any,
		},
		Healthbars: {
			[any]: any,
		},
		Names: {
			[any]: any,
		},
		Distances: {
			[any]: any,
		},
		Snaplines: {
			[any]: any,
		},
		Radar: {
			[any]: any,
		},
		Skeleton: {
			[any]: any,
		},
	},
	Highlights: {
		[any]: any,
	},

	ObjectESPs: {
		Highlights: {
			[any]: any,
		},
		ESPs: {
			[any]: any,
		},
	},

	Enums: TwilightEnums,
	_connections: {
		[any]: RBXScriptConnection,
	},
}

export type TwilightSettings = {
	Enabled: boolean,
	ObjectsEnabled: boolean,

	Checks: {
		Visible: {
			Enabled: boolean,
			OnlyVisible: boolean,
			Recolor: boolean,
		},

		Team: {
			Enabled: boolean,
			SelectedTeams: {
				enemy: boolean,
				friendly: boolean,
				generic: boolean,
				["local"]: boolean,
			},
		},
	},

	currentColors: TwilightColors,

	HealthBar: {
		Enabled: {
			enemy: boolean,
			friendly: boolean,
			generic: boolean,
			["local"]: boolean,
		},

		Source: HealthSource,

		Bar: boolean,
		Text: boolean,

		Position: HealthBarPosition,
		Suffix: string,
	},
	Box: {
		Style: BoxStyle,
		Enabled: boolean,
		Filled: {
			Enabled: boolean,
			Transparency: number,
		},
		Thickness: number,
	},
	Tracer: {
		Enabled: {
			enemy: boolean,
			friendly: boolean,
			generic: boolean,
		},
		Origin: TracerOrigin,
		Style: TracerStyle,
		Thickness: number,
	},
	Name: {
		Enabled: {
			enemy: boolean,
			friendly: boolean,
			generic: boolean,
			["local"]: boolean,
		},

		Style: NameStyle,
	},
	Distance: {
		Enabled: {
			enemy: boolean,
			friendly: boolean,
			generic: boolean,
			["local"]: boolean,
		},
		DistanceUnit: DistanceUnit,
	},
	Chams: {
		Enabled: {
			enemy: boolean,
			friendly: boolean,
			generic: boolean,
			["local"]: boolean,
		},
		Outline: {
			Enabled: boolean,
			Thickness: number,
			Transparency: number,
		},
		Fill: {
			Enabled: boolean,
			Transparency: number,
		},
		Occlusion: boolean,
	},
	Skeleton: {
		Enabled: {
			enemy: boolean,
			friendly: boolean,
			generic: boolean,
			["local"]: boolean,
		},
		Thickness: number,
		Transparency: number,
		ExplicitBodyType: SkeletonBodyType,
	},
	Radar: {
		Enabled: boolean,
		Position: Vector2,
		Radius: number,
		Scale: number,
	},

	TextSize: number,
	MaxDistance: number,
	RefreshRate: number,

	Snaplines: boolean,
}

export type TwilightColors = {
	enemy: TwilightColorSet,
	friendly: TwilightColorSet,
	generic: TwilightColorSet,
	["local"]: TwilightColorSet,

	Radar: {
		Background: Color3,
		Border: Color3,
	},
}
export type TwilightColorSet = {
	Box: {
		Outline: TwilightColorItem,
		Fill: TwilightColorItem,
	},
	HealthBar: {
		Outline: Color3,
		Fills: {
			Low: Color3,
			Medium: Color3,
			High: Color3,
		},
	},
	Tracer: TwilightColorItem,
	Text: Color3,
	Chams: {
		Outline: TwilightColorItem,
		Fill: TwilightColorItem,
	},
	Skeleton: TwilightColorItem,
}
export type TwilightColorItem = {
	Invisible: Color3,
	Visible: Color3,
}

export type TwilightEnums = {
	HealthBarPosition: {
		Left: HealthBarPosition,
		Right: HealthBarPosition,
	},
	HealthSource: {
		NRPBS: HealthSource,
		Humanoid: HealthSource,
	},
	BoxStyle: {
		CornerBoxes: BoxStyle,
		Normal: BoxStyle,
		["3D"]: BoxStyle,
		Quad: BoxStyle,
	},
	TracerOrigin: {
		LocalHumanoid: TracerOrigin,
		Mouse: TracerOrigin,
		Viewports: {
			Bottom: TracerOrigin,
			Top: TracerOrigin,
			Center: TracerOrigin,
		},
	},
	TracerStyle: {
		Line: TracerStyle,
	},
	NameStyle: {
		DisplayName: NameStyle,
		Username: NameStyle,
	},
	DistanceUnit: {
		Studs: DistanceUnit,
		Meters: DistanceUnit,
	},
	SkeletonBodyType: {
		Dynamic: SkeletonBodyType,
		["R6"]: SkeletonBodyType,
		["R15"]: SkeletonBodyType,
	},
}

-- Enum Types
type NRPBS = { MaxHealth: number, Health: number, [any]: any }
type HealthBarPosition = number
type HealthSource = ((Player) -> Humanoid) | ((Player) -> NRPBS)
type BoxStyle = number
type TracerOrigin = number
type TracerStyle = number
type NameStyle = number
type DistanceUnit = number
type SkeletonBodyType = number | nil

return 1
