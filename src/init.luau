local services = require(script.utilities.services)
local types = require(script.types)
local utilities = require(script.utilities)
local creator = require(script.utilities.creator)
local playerEsp = require(script.components.playerEsp)
local objectEsp = require(script.components.objectEsp)

if getgenv().TwilightInstances == nil then
	getgenv().TwilightInstances = {}
end

if getgenv().TwilightInstances[getgenv().InterfaceName] then
	getgenv().TwilightInstances[getgenv().InterfaceName].Unload(true)
end

local gui = creator.New("ScreenGui", { Name = "Twilight ESP " .. (getgenv().InterfaceName or ""), Enabled = false })
utilities.ProtectUI(gui)

creator.New("Frame", {
	Parent = gui,
	Name = "PlayerESPs",
	Visible = false,
	Size = UDim2.fromScale(1, 1),
	BackgroundTransparency = 1,
})
creator.New("Folder", {
	Parent = gui.PlayerESPs,
	Name = "PlayerESPTracers",
})
creator.New("Folder", {
	Parent = gui,
	Name = "Tracers",
})

local Twilight = require(script.contract) :: types.Twilight
Twilight.Instance = gui
Twilight._connections = {}
Twilight.espObjects = {
	Players = {},
}
Twilight.settings = {} :: types.twilightSettings

function Twilight.Load()
	gui.Enabled = true
end

function Twilight.Unload(destroy: boolean?)
	gui.Enabled = false
	Twilight.unloaded = true
	if destroy then
		for i, v in pairs(Twilight.espObjects) do
			if i ~= "Players" then
				v.instance.chams.Parent = nil
				v.instance.chams.Enabled = false
				if destroy then
					v.instance.chams:Destroy()
				end
			else
				for i, v in pairs(v) do
					v.instance.chams.Parent = nil
					v.instance.chams.Enabled = false
					if destroy then
						v.instance.chams:Destroy()
					end
				end
			end
		end
		for _, connection in pairs(Twilight._connections) do
			connection:Disconnect()
			connection = nil
		end
		gui:Destroy()
	end
end

--task.spawn(function()
for _, player in pairs(services.Players:GetChildren()) do
	playerEsp:BindPlayer(player)
end
services.Players.PlayerAdded:Connect(function(player)
	playerEsp:BindPlayer(player)
end)
--end)

function Twilight:EnablePlayerESP()
	gui.PlayerESPs.Visible = true
end

function Twilight:DisablePlayerESP()
	gui.PlayerESPs.Visible = false
end

function Twilight:BindESPToObject(object: Instance)
	objectEsp:new(object)
end

function Twilight:SetOptions(options) -- done this way because of defaulting
	options = options or {}
	Twilight.settings = utilities.Kwargify(options, {
		currentColors = utilities.Kwargify(options.currentColors or {}, {
			boxNeutral = Color3.new(1, 1, 1),
			boxSelf = Color3.new(0, 0, 1),
			boxTeam = Color3.new(0, 1, 0),
			boxEnemy = Color3.new(1, 0, 0),

			boxOutlineNeutral = Color3.new(1, 1, 1),
			boxOutlineSelf = Color3.new(0, 0, 1),
			boxOutlineTeam = Color3.new(0, 1, 0),
			boxOutlineEnemy = Color3.new(1, 0, 0),

			highlightFillNeutral = Color3.new(1, 1, 1),
			highlightFillEnemy = Color3.new(1, 0, 0),
			highlightFillTeam = Color3.new(0, 1, 0),
			highlightFillSelf = Color3.new(0, 0, 1),
			highlightOutline = Color3.new(1, 1, 1),

			healthBarFillNeutral = Color3.new(1, 1, 1),
			healthBarFillNeutralLow = Color3.new(0.7, 0.7, 0.7),
			healthBarFillSelf = Color3.new(0, 0, 1),
			healthBarFillSelfLow = Color3.new(0, 0, 0.5),
			healthBarFillTeam = Color3.new(0, 1, 0),
			healthBarFillEnemy = Color3.new(1, 0, 0),
			healthBarFillTeamLow = Color3.new(0, 0.5, 0),
			healthBarFillEnemyLow = Color3.new(0.5, 0, 0),
		}),
		healthbarEnabled = true,
		healthbarTeamCheck = false,
		boxEnabled = true,
		outlineBoxEnabled = true,
		boxTeamCheck = false,
		outlineBoxTeamCheck = false,
		chamsEnabled = false,
		chamsTeamCheck = true,
		tracersEnabled = true,

		useTeamColor = false, -- sets the esp colors to be based off teams
		limitDistance = nil,
		lowHealthAlert = true,
		showObjectNames = false,
	})
end

Twilight:SetOptions()
getgenv().TwilightInstances[getgenv().InterfaceName] = Twilight
return Twilight
