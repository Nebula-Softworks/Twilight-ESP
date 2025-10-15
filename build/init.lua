local Input = "./dist/main.lua"
local Header = "build/header.lua"
local Output = "./dist/main.lua"
local PackageJson = "../package.json"

local Primary = "\27[38;2;48;255;106m" -- #30ff6a
local Dev = "\27[38;2;255;210;50m" -- #FFD232
local Build = "\27[38;2;50;231;255m" -- #32E7FF
local Error = "\27[38;2;255;74;50m" -- #FF4A32

local Reset = "\27[0m"

local function colorize(text, color)
    return color .. text .. Reset
end

local function getPackageData()
    local nodeScript = [[
const pkg = require('./package.json');
const data = {
    name: pkg.name || '',
    version: pkg.version || '',
    description: pkg.description || '',
    author: pkg.author || '',
    license: pkg.license || '',
    repository: pkg.repository || '',
    main: pkg.main || '',
    discord: pkg.discord || '',
    keywords: Array.isArray(pkg.keywords) ? pkg.keywords.join(', ') : ''
};
console.log(JSON.stringify(data));
]]
    
    local handle = io.popen('node -e "' .. nodeScript .. '"')
    if not handle then
        error(colorize("[ × ] ", Error) .. "Failed to execute node command")
    end
    
    local jsonResult = handle:read("*all")
    handle:close()
    
    if not jsonResult or jsonResult == "" then
        error(colorize("[ × ] ", Error) .. "Failed to get data from package.json")
    end
    
    local data = {}
    for key, value in jsonResult:gmatch('"([^"]+)":"([^"]*)"') do
        data[key] = value ~= "" and value or nil
    end
    
    return data
end

local function processHeader(headerContent, packageData)
    for key, value in pairs(packageData) do
        if value then
            headerContent = headerContent:gsub("{{package%." .. key .. "}}", value)
            headerContent = headerContent:gsub("{package%." .. key .. "}", value)
            headerContent = headerContent:gsub("{{" .. key:upper() .. "}}", value)
            headerContent = headerContent:gsub("{" .. key:upper() .. "}", value)
        end
    end
    
    local buildTime = os.date("%Y-%m-%d %H:%M:%S")
    local buildDate = os.date("%Y-%m-%d")
    local buildYear = os.date("%Y")
    
    headerContent = headerContent:gsub("{{BUILD_TIME}}", buildTime)
    headerContent = headerContent:gsub("{BUILD_TIME}", buildTime)
    headerContent = headerContent:gsub("{{BUILD_DATE}}", buildDate)
    headerContent = headerContent:gsub("{BUILD_DATE}", buildDate)
    headerContent = headerContent:gsub("{{BUILD_YEAR}}", buildYear)
    headerContent = headerContent:gsub("{BUILD_YEAR}", buildYear)
    
    return headerContent
end

local FileCount = arg[1] or "N/A"
local ProcessingTime = arg[2] or "N/A"
local Mode = arg[3] or "dev"

local DevPrefix = "[ DEV ]" .. " "
local BuildPrefix = "[ BUILD ]" .. " "
local ErrorPrefix = "[ × ]" .. " "

local Prefix = Mode == "dev" and colorize(DevPrefix, Dev) or colorize(BuildPrefix, Build)

local packageData = getPackageData()

if not packageData.version then
    error(colorize(ErrorPrefix, Error) .. "Failed to get version from package.json")
end

local File = io.open(Header, "r")
if not File then
    error(colorize(ErrorPrefix, Error) .. "Failed to open header file: " .. Header)
end
local HeaderContent = File:read("*all")
File:close()

HeaderContent = processHeader(HeaderContent, packageData)

File = io.open(Input, "r")
if not File then
    error(colorize(ErrorPrefix, Error) .. "Failed to open input file: " .. Input)
end
local Content = File:read("*all")
File:close()

local NewContent = HeaderContent .. "\n\n" .. Content

File = io.open(Output, "w")
if not File then
    error(colorize(ErrorPrefix, Error) .. "Failed to open output file: " .. Output)
end
File:write(NewContent)
File:close()

local Time = os.date("[ %H:%M:%S ]")

print(Time)
print(colorize("[ ✓ ] ", Primary) .. Prefix)
print(colorize("[ > ] ", Primary) .. "WindUI Build completed successfully")
print(colorize("[ > ] ", Primary) .. "Version: " .. (packageData.version or "N/A"))
print(colorize("[ > ] ", Primary) .. "Time taken: " .. ProcessingTime .. "ms")
print(colorize("[ > ] ", Primary) .. "Output file: " .. Output .. "\n")