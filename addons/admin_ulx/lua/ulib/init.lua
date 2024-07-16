if not ULib then
	ULib = {}

	-- For historical purposes
	if not ULib.consoleCommand then ULib.consoleCommand = game.ConsoleCommand end

	file.CreateDir( "ulib" )

	include( "ulib/shared/defines.lua" )
	include( "ulib/shared/misc.lua" )
	include( "ulib/shared/util.lua" )
	include( "ulib/shared/hook.lua" )
	include( "ulib/shared/tables.lua" )
	include( "ulib/shared/player.lua" )
	include( "ulib/server/player.lua" )
	include( "ulib/shared/messages.lua" )
	include( "ulib/shared/commands.lua" )
	include( "ulib/server/concommand.lua" )
	include( "ulib/server/util.lua" )
	include( "ulib/shared/sh_ucl.lua" )
	include( "ulib/server/ucl.lua" )
	include( "ulib/server/phys.lua" )
	include( "server/player_ext.lua" )
	include( "server/entity_ext.lua" )
	include( "ulib/shared/plugin.lua" )
	include( "shared/cami_global.lua" )
	include( "shared/cami_ulib.lua" )

	AddCSLuaFile( "ulib/cl_init.lua" )
	AddCSLuaFile( "autorun/ulib_init.lua" )
	local folder = "ulib/shared"
	local files = file.Find( folder .. "/" .. "*.lua", "LUA" )
	for _, file in ipairs( files ) do
		AddCSLuaFile( folder .. "/" .. file )
	end

	folder = "ulib/client"
	files = file.Find( folder .. "/" .. "*.lua", "LUA" )
	for _, file in ipairs( files ) do
		AddCSLuaFile( folder .. "/" .. file )
	end

	--Shared modules
	local files = file.Find( "ulib/modules/*.lua", "LUA" )
	if #files > 0 then
		for _, file in ipairs( files ) do
			include( "ulib/modules/" .. file )
			AddCSLuaFile( "ulib/modules/" .. file )
		end
	end

	--Server modules
	local files = file.Find( "ulib/modules/server/*.lua", "LUA" )
	if #files > 0 then
		for _, file in ipairs( files ) do
			include( "ulib/modules/server/" .. file )
		end
	end

	--Client modules
	local files = file.Find( "ulib/modules/client/*.lua", "LUA" )
	if #files > 0 then
		for _, file in ipairs( files ) do
			AddCSLuaFile( "ulib/modules/client/" .. file )
		end
	end

	local function clReady( ply )
		ply.ulib_ready = true
		hook.Call( ULib.HOOK_LOCALPLAYERREADY, _, ply )
	end
	concommand.Add( "ulib_cl_ready", clReady ) -- Called when the c-side player object is ready
end
