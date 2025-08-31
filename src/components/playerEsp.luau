local espInstance = require(script.Parent.espInstance)
local types = require(script.Parent.Parent.types)
local services = require(script.Parent.Parent.utilities.services)
local root = require(script.Parent.Parent.contract)

local module = require(script.Parent.playerEspContract)

function module:BindPlayer(player: Player)
	local playerEsp = {
		boundedTo = player,
	} :: types.playerEsp

	local char = workspace[player.Name]
	local esp = espInstance:Create(char, char.HumanoidRootPart)
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

	function playerEsp:Destroy()
		esp:Destroy()
	end

	local connection = services.RunService.RenderStepped:Connect(playerEsp.Update)
	services.Players.PlayerRemoving:Once(function(leavingPlayer)
		if player == leavingPlayer then
			connection:Disconnect()
			playerEsp:Destroy()
		end
	end)
	table.insert(root._connections, connection)

	root.espObjects.Players[player] = playerEsp
	return playerEsp
end

return module
