local espInstance = require(script.Parent.espInstance)
local types = require(script.Parent.Parent.types)
local services = require(script.Parent.Parent.utilities.services)
local root = require(script.Parent.Parent.contract)

local module = require(script.Parent.playerEspContract)

function module:BindPlayer(player: Player)
	local playerEsp = {
		boundedTo = player,
	} :: types.playerEsp

	local char = player.Character
	local esp = espInstance:Create(char, char:WaitForChild("HumanoidRootPart"))
	esp.Box.NameLabel.Visible = true
	esp.Box.Parent = root.Instance.PlayerESPs
	esp.tracer.Parent = root.Instance.PlayerESPs.PlayerESPTracers

	if player == services.Players.LocalPlayer then
		esp.Box.Distance.Visible = false
	end

	playerEsp.instance = esp

	-- TODO add skeleton esp

	function playerEsp.Update()
		esp:Update(true)
	end

	table.insert(root._connections, player.Changed:Connect(playerEsp.Update))
	table.insert(root._connections, char.Changed:Connect(playerEsp.Update))
	table.insert(root._connections, workspace.CurrentCamera.Changed:Connect(playerEsp.Update))

	root.espObjects.Players[player] = playerEsp
	return playerEsp
end

return module
