getgenv().NoAnticheatPresent = false -- chams are super-duper detected. enabling this means there is no anticheat present, and will allow chams to run. if there is one present, you will probably get banned straight away as it is using a simple Highlight as of version 1.0
getgenv().InterfaceName = "Twilight ESP Example"
local Twilight = loadstring(game:HttpGet("https://raw.nebulasoftworks.xyz/twilight"))()
Twilight.Load()

local Luna = loadstring(game:HttpGet("https://raw.nebulasoftworks.xyz/luna", true))()
local Window = Luna:CreateWindow({
	Name = "Twilight ESP",
	Subtitle = "Example. v1.0",
	LogoID = "139573252824260",
	LoadingEnabled = false,
})

local Tab = Window:CreateTab({
	Name = "ESP Features",
	Icon = "view_in_ar",
	ImageSource = "Material",
	ShowTitle = true,
})

Tab:CreateToggle({
	Name = "Corner Boxes",
	CurrentValue = true,
	InitialCallback = true,
	Callback = function(Value)
		Twilight.settings.boxEnabled = Value
	end,
}, "Toggle")

Tab:CreateToggle({
	Name = "Drawing Outline Boxes",
	CurrentValue = true,
	InitialCallback = true,
	Callback = function(Value)
		Twilight.settings.outlineBoxEnabled = Value
	end,
}, "Toggle")

Tab:CreateToggle({
	Name = "Chams (DETECTED)",
	CurrentValue = false,
	InitialCallback = true,
	Callback = function(Value)
		if getgenv().NoAnticheatPresent then
			Twilight.settings.chamsEnabled = Value
		end
	end,
}, "Toggle")

Tab:CreateToggle({
	Name = "Tracers",
	CurrentValue = false,
	InitialCallback = true,
	Callback = function(Value)
		Twilight.settings.tracersEnabled = Value
	end,
}, "Toggle")

Tab:CreateToggle({
	Name = "Health bars",
	CurrentValue = false,
	InitialCallback = true,
	Callback = function(Value)
		Twilight.settings.healthBarEnabled = Value
	end,
}, "Toggle")

Twilight.EnablePlayerESP()
