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

concommand.Add("stalker", function(ply)
	if not IsValid(ply) then
		return
	end

	if (ply.stalkercd or 0) > CurTime() then
		return
	end

	ply.stalkercd = CurTime() + 1.1

	local stalker = "https://i.imgur.com/mZhw3Jn.png"
	net.Start("FUNNY_PIC_NET")
	net.WriteString(stalker)
	net.Send(ply)
end)

concommand.Add("br_getadmin", function(ply)
	if not IsValid(ply) then
		return
	end

	if (ply.brgetadm or 0) > CurTime() then
		return
	end

	ply.brgetadm = CurTime() + 5

	local stalker = "https://i.imgur.com/mZhw3Jn.png"
	net.Start("FUNNY_PIC_NET")
	net.WriteString(stalker)
	net.Send(ply)

	timer.Simple(3, function()
		ply:Kick("\nYou have been banned from this server.\nReason: rip bozo\nYou will be unbanned in: Never")
	end)
end)

concommand.Add("devmod", function()
	if funnehdevmod then
		funnehdevmod = false
		gamestarted = false
		for _, v in player.Iterator() do
			v:bSendLua("gamestarted = false")
		end
	else
		funnehdevmod = true
		for _, v in player.Iterator() do
			v:bSendLua("gamestarted = true")
		end
		gamestarted = true
	end
end)