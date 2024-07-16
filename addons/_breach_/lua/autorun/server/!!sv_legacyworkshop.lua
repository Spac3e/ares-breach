if game.SinglePlayer() then
	return
end
local lower, Split, StartsWith, GetExtensionFromFilename
do
	local _obj_0 = string
	lower, Split, StartsWith, GetExtensionFromFilename = _obj_0.lower, _obj_0.Split, _obj_0.StartsWith, _obj_0.GetExtensionFromFilename
end
local Exists, Find
do
	local _obj_0 = file
	Exists, Find = _obj_0.Exists, _obj_0.Find
end
local resource = resource
local ipairs = ipairs
local workshopDL = resource.AWDL
if not istable(workshopDL) then
	workshopDL = { }
	resource.AWDL = workshopDL
end
local resourceExtensions = {
	["mdl"] = true,
	["vtx"] = true,
	["phy"] = true,
	["ani"] = true,
	["vvd"] = true,
	["wav"] = true,
	["mp3"] = true,
	["ogg"] = true,
	["vmt"] = true,
	["vtf"] = true,
	["png"] = true,
	["jpg"] = true,
	["jpeg"] = true,
	["raw"] = true,
	["ttf"] = true,
	["ani"] = true,
	["pcf"] = true,
	["vcd"] = true,
	["properties"] = true
}
local getTag = nil
do
	local tagNames = {
		["gamemode"] = "Gamemode",
		["map"] = "Map",
		["weapon"] = "Weapon",
		["vehicle"] = "Vehicle",
		["npc"] = "NPC",
		["entity"] = "Entity",
		["tool"] = "Tool",
		["effects"] = "Effect",
		["model"] = "Model",
		["servercontent"] = "Server Content"
	}
	getTag = function(addon)
		for _, tag in ipairs(Split(addon.tags, ",")) do
			tag = tagNames[lower(tag)]
			if tag ~= nil then
				return tag
			end
		end
		return "Addon"
	end
end
local addons = engine.GetAddons()
local addonsCount = #addons
local addWorkshop = nil
do
	local AddWorkshop = resource.AddWorkshop
	local MsgC = MsgC
	local color0 = Color(200, 200, 200)
	local color1 = Color(180, 180, 180)
	local color2 = Color(20, 150, 240)
	addWorkshop = function(wsid)
		if workshopDL[wsid] then
			return
		end
		workshopDL[wsid] = true
		AddWorkshop(wsid)
		workshopDL[#workshopDL + 1] = wsid
		for index = 1, addonsCount do
			if addons[index].wsid == wsid then
				MsgC(color1, "[", color2, "AWDL", color1, "] + ", color0, getTag(addons[index]) .. ": ", color2, addons[index].title, color1, " ( ", color0, wsid, color1, " )\n")
				return
			end
		end
		return MsgC(color1, "[", color2, "AWDL", color1, "] + ", color0, "Addon: ", color2, "unknown", color1, " ( ", color0, wsid, color1, " )\n")
	end
end
local scanAddon
scanAddon = function(gamePath, folderPath, result, length)
	if folderPath == nil then
		result, length = { }, 0
		local files, folders = Find("*", gamePath)
		for _, fileName in ipairs(files) do
			length = length + 1
			result[length] = fileName
		end
		for _, folderName in ipairs(folders) do
			scanAddon(gamePath, folderName, result, length)
		end
		return result
	end
	local files, folders = Find(folderPath .. "/*", gamePath)
	for _, fileName in ipairs(files) do
		length = length + 1
		result[length] = folderPath .. "/" .. fileName
	end
	for _, folderName in ipairs(folders) do
		scanAddon(gamePath, folderPath .. "/" .. folderName, result, length)
	end
	return result
end
local ignoreOtherMaps = CreateConVar("awdl_ignore_maps", "1", bit.bor(FCVAR_ARCHIVE, FCVAR_DONTRECORD, FCVAR_NOTIFY), "If enabled, AWDL will ignore all maps except the current map.")
local mapName = game.GetMap()
for i = 1, addonsCount do
	local addon = addons[i]
	if not (addon.downloaded and addon.mounted) then
		goto _continue_0
	end
	if mapName ~= nil and Exists("maps/" .. mapName .. ".bsp", addon.title) then
		addWorkshop(addon.wsid)
		mapName = nil
		goto _continue_0
	end
	if ignoreOtherMaps:GetBool() and getTag(addon) == "Map" then
		goto _continue_0
	end
	if addon.models > 0 then
		addWorkshop(addon.wsid)
		goto _continue_0
	end
	for _, filePath in ipairs(scanAddon(addon.title)) do
		if StartsWith(filePath, "data_static/") or resourceExtensions[GetExtensionFromFilename(filePath)] then
			addWorkshop(addon.wsid)
			break
		end
	end
	::_continue_0::
end