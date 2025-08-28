local types = require(script.types)
local utilities = require(script.utilities)
local creator = require(script.utilities.creator)

local gui = creator.New("ScreenGui", { Name = "Twilight ESP", Enabled = false })
utilities.ProtectUI(gui)

creator.New("Folder", {
	Parent = gui,
	Name = "PlayerESPs",
})

local Twilight = {
	Instance = gui,
	_connections = {},
	espObjects = {},
	settings = {} :: types.twilightSettings,
} :: types.Twilight

function Twilight.Load()
	gui.Enabled = true
end

function Twilight.Unload(destroy: boolean?)
	gui.Enabled = false
	if destroy then
		for _, connection in pairs(Twilight._connections) do
			connection:Disconnect()
			connection = nil
		end
		gui:Destroy()
	end
end

function Twilight:EnablePlayerESP() end

function Twilight:DisablePlayerESP() end

function Twilight:BindESPToObject(object: Instance, showName, showDistance) end

function Twilight:SetColors(colors: types.twilightTheme) end

function Twilight:SetSettings(props: types.twilightSettings) end

return Twilight
