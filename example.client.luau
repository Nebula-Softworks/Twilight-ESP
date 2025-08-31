local twilight = require(game.ReplicatedStorage["Twilight ESP"])
twilight.Load()
twilight.EnablePlayerESP()
twilight.settings.outlineBoxEnabled = true
twilight.settings.boxEnabled = true
twilight.settings.chamsEnabled = true
twilight.settings.healthbarEnabled = true
twilight.settings.showObjectNames = false
twilight.settings.tracersEnabled = true

twilight.settings.boxTeamCheck = true
twilight.settings.chamsTeamCheck = true
twilight.settings.healthbarTeamCheck = true
twilight.settings.outlineBoxTeamCheck = true
twilight.settings.useTeamColor = true

require(game.ReplicatedStorage["Twilight ESP"]):BindESPToObject(workspace.trees:FindFirstChild("Cherry Blossom M"))

task.wait(5)

--twilight.Unload()
