-- Send the following files to players.
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("core/sh_core.lua")
AddCSLuaFile("shared.lua")

-- Include utility functions, data storage functions, and then shared.lua
include("core/sh_core.lua")
include("shared.lua")

function LoadMapConfig()
	BREACH.Msg("Loading Map Config"..'\n', CLR_MSG_PINK, true)
	if file.Exists( GM.FolderName .. "/gamemode/configs/mapconfigs/" .. game.GetMap() .. ".lua", "LUA" ) then
		local relpath = "configs/mapconfigs/" .. game.GetMap() .. ".lua"
		AddCSLuaFile( relpath )
		BREACH.Include( relpath )
		if MAP_LOADED != true then
			BREACH.Msg("Loaded Config For "..game.GetMap()..'\n', CLR_MSG_GREEN)
		end
		MAP_LOADED = true
	else
		BREACH.Msg("Error occurred during map config process\n", CLR_MSG_ORANGE)
		BREACH.Msg("Unsupported map " .. game.GetMap() ..'\n', CLR_MSG_RED)
		MAP_LOADED = false
	end
end

LoadMapConfig()