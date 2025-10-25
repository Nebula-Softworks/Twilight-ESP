local fs = require("@lune/fs")
local process = require("@lune/process")

local FilePath = "dist/main.luau"
local TempFile = "dist/temp.luau"
local Header = fs.readFile("./build/header.lua")

local function bundle()
	process.exec(
		"darklua",
		{ "process", "src/init.luau", TempFile, "--config", "./build/darklua.development.config.json" }
	)
	local value = fs.readFile(TempFile)
	fs.removeFile(TempFile)
	return value
end

fs.writeFile(FilePath, Header .. "\n\n" .. bundle())
