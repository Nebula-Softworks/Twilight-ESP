local fs = require("@lune/fs")
local process = require("@lune/process")

local FilePath = "dist/Twilight.ESP.luau"
local TempFile = "dist/temp.luau"
local Header = fs.readFile("./build/header.luau")

local function bundle()
	process.exec("darklua", { "process", "src/init.luau", TempFile, "--config", "./build/darklua.config.json" })
	local value = fs.readFile(TempFile)
	fs.removeFile(TempFile)
	return value
end

fs.writeFile(FilePath, Header .. "\n\n" .. bundle())
