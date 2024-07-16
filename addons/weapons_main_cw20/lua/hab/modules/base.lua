hab.Module.Base = hab.Module.Base or {}
local MODULE = hab.Module.Base

MODULE.info = {

	name = "HAB Base", --module name
	iname = "Base", --internal name
	version = "0.4a",
	author = "The_HAVOK",
	contact = "STEAM_0:1:40989742",
	contrib = {},

}

hab.RegisterModule( MODULE )

-- Add Concommands
local FuncReloadModuleAutoComplete = function( cmd, args )

	args = string.Trim( args ) -- remove spaces
	args = string.lower( args ) -- lowercase

	local tbl = {} -- define table

	for k, v in pairs( hab.modules ) do -- check modules

		local Module = v

		if string.find( string.lower( Module ), args ) then

			Module = "hab_reload_modules " .. Module -- insert command name before arg

			table.insert( tbl, Module )

		end

	end

	return tbl

end

local FuncReloadModule = function( player, command, args )

	if ( player:IsAdmin( ) or player:IsSuperAdmin( ) ) then

		if !args[1] then

			MsgN( )
			MsgN( "Reloading Modules..." )
			MsgN( )

			for i, f in pairs( file.Find( "hab/modules/*.lua", "LUA" ) ) do

				AddCSLuaFile( "hab/modules/" .. f )
				include( "hab/modules/" .. f )

				MsgN( "	Module " .. f .. " Reloaded..." )

			end

			MsgN( )
			MsgN( "...Done Reloading Modules." )
			MsgN( )

		else

			AddCSLuaFile( "hab/modules/" .. args[1] )
			include( "hab/modules/" .. args[1] )

			MsgN( "Module " .. args[1] .. " Reloaded!" )

		end

	else

		MsgN( "You do not have access to this command." )

	end

end

hab.AddConCommand( nil, "reload_modules", FuncReloadModule, FuncReloadModuleAutoComplete, "Used to reload HAB modules", HAB_FCVAR_CLIENT_SERVER_ONCE )

local FuncReloadMenu = function( player, command, args )

	if SERVER then MsgN( "This command can only be ran by the client." ) return end

	for nameCategory, category in pairs( hab.menus ) do

		for nameSelection, selection in pairs( category ) do

--			hab.PopulateMenus( )

		end

	end

	Msg( "HAB Menus Reloaded" )

end

hab.AddConCommand( nil, "reload_menu", FuncReloadMenu, nil, "Used to reload HAB menus" )

-- MEME
local FuncCreator = function( player, command, args )

	local incorrect = {

		["STEAM_0:0:13251500"] = "Me too.",

		["STEAM_0:0:80731307"] = "No you diddn't kiddo.",

		["STEAM_0:1:43680041"] = "I guess...",

		["STEAM_0:1:18976388"] = "LOL",

		["STEAM_0:1:29236543"] = "You're are fat.",

	}

	if player:SteamID( ) == hab.contact then

		if SERVER then

			PrintMessage( HUD_PRINTTALK, player:Nick( ) .. " Made the server." )

		elseif CLIENT then

			MsgAll( "Correct!\n" )

		end

	elseif CLIENT and incorrect[player:SteamID( )] then

		MsgN( incorrect[player:SteamID( )] )

	else

		MsgN( "Wrong." )

	end

end

hab.AddConCommand( nil, "i_made_the_server", FuncCreator, nil, "I made the server?", HAB_FCVAR_CLIENT_SERVER_ONCE ) -- an inside joke

hab.AddCvar( nil, "Developer", 0, CVAL_NUMBER, HAB_FCVAR_SERVER, "Default: 0, Enable developer mode.", 0, false )

-- Client Menu Panels
if CLIENT then

hab.AddCvarCL( nil, "Enable_DOF_Hack", 1, CVAL_BOOL, HAB_FCVAR_CLIENT_ONLY, "Default: 1, Enable DOF Mode Hack." )


hab.AddCvarCL( nil, "Wire_Menu_Layout", 1, CVAL_BOOL, HAB_FCVAR_CLIENT_ONLY, "Default: 1, Use custom wire toolmenu layout." )

if hab.WireMounted and WireLib and tonumber( hab.cval.Base.Wire_Menu_Layout ) > 0 then

	hab.Dmsg( "Wiremod is detected, using custom menu" )

	WireLib.registerTabForCustomMenu( "HAB" )

end


local EnableMCore = function( cname, old, new )

	new = tonumber( new )

	if new == 1 then

		RunConsoleCommand( "gmod_mcore_test", "1" )

		RunConsoleCommand( "mat_queue_mode", "2" )

		RunConsoleCommand( "cl_threaded_bone_setup", "1" )

		RunConsoleCommand( "cl_threaded_client_leaf_system", "1" )

		RunConsoleCommand( "r_threaded_client_shadow_manager", "1" )

		RunConsoleCommand( "r_threaded_particles", "1" )

		RunConsoleCommand( "r_threaded_renderables", "1" )

		RunConsoleCommand( "r_queued_ropes", "1" )

		RunConsoleCommand( "studio_queue_mode", "1" )

	elseif new == 0 then

		RunConsoleCommand( "gmod_mcore_test", "0" )

		RunConsoleCommand( "mat_queue_mode", "-1" )

		RunConsoleCommand( "cl_threaded_bone_setup", "0" )

		RunConsoleCommand( "cl_threaded_client_leaf_system", "0" )

		RunConsoleCommand( "r_threaded_client_shadow_manager", "0" )

		RunConsoleCommand( "r_threaded_particles", "0" )

		RunConsoleCommand( "r_threaded_renderables", "0" )

		RunConsoleCommand( "r_queued_ropes", "0" )

		RunConsoleCommand( "studio_queue_mode", "0" )

	end

end

hab.AddCvarCL( nil, "Enable_MCore", 1, CVAL_BOOL, HAB_FCVAR_CLIENT_ONLY, "Default: 1, Enable GMod Multi-Core Optimisations (Use at your own risk).", EnableMCore )

-- Add Panels
hab.Menu.AddMenuPanel( MODULE.info.name, "Client Settings", function ( Panel )

	local layout = Panel:CheckBox( "Wire Menu Layout", "hab_Wire_Menu_Layout" )
	layout:SetTooltip ( "Enable Wire Menu Layout" )

	local dofhack = Panel:CheckBox( "DOF Mode Hack", "hab_Enable_DOF_Hack" )
	dofhack:SetTooltip ( "Enable DOF Mode Hack" )

	local mcore = Panel:CheckBox( "GMod MCore CVars", "hab_Enable_MCore" )
	mcore:SetTooltip ( "Enable GMod MCore CVars" )

end )

hab.Menu.AddMenuPanel( MODULE.info.name, "Server Settings", function ( Panel )

	Footsteps = Panel:Help( "Footstep Settings" )

	local Footstep_Min_Speed = Panel:NumSlider( "Min. Footstep Speed", "hab_Footstep_Min_Speed_cl", 0, 640, 0 )
	Footstep_Min_Speed:SetTooltip ( "Minimum speed player can move to play footsteps" )

	local Footstep_Suppress_Crouched = Panel:CheckBox( "Suppress Crouched", "hab_Footstep_Suppress_Crouched_cl" )
	Footstep_Suppress_Crouched:SetTooltip ( "Prevent footsteps from playing when the player is crouched" )

	local Footstep_Suppress_Proned = Panel:CheckBox( "Suppress Proned", "hab_Footstep_Suppress_Proned_cl" )
	Footstep_Suppress_Proned:SetTooltip ( "Prevent footsteps from playing when the player is prone (prone mod only)" )

	Developer = Panel:Help( "Developer Settings" )

	local dev = Panel:CheckBox( "Developer Mode", "hab_Developer_cl" )
	dev:SetTooltip ( "Enable Developer Mode" )

end )

end


MODULE.UpdateUnits = function( cname, old, new )

	new = math.Clamp( tonumber( new ), 0.1, 32 )

--Distance
	HAB_METERS_TO_SOURCE = HAB_METERS_TO_SOURCE_ / new

	HAB_MILIMETERS_TO_SOURCE = HAB_MILIMETERS_TO_SOURCE_ / new

	HAB_CENTIETERS_TO_SOURCE = HAB_CENTIETERS_TO_SOURCE_ / new

	HAB_KILOMETERS_TO_SOURCE = HAB_KILOMETERS_TO_SOURCE_ / new


	HAB_INCHES_TO_SOURCE = HAB_INCHES_TO_SOURCE_ / new

	HAB_FEET_TO_SOURCE = HAB_FEET_TO_SOURCE_ / new

	HAB_YARDS_TO_SOURCE = HAB_YARDS_TO_SOURCE_ / new

	HAB_MILES_TO_SOURCE = HAB_MILES_TO_SOURCE_ / new

--Speed
	HAB_MPH_TO_SOURCE = HAB_MPH_TO_SOURCE_ / new

--Force
	HAB_GRAVITY = HAB_GRAVITY_ / new

end

hab.AddCvar( nil, "PFScale", 1.0, CVAL_NUMBER, HAB_FCVAR_SERVER, "Default: 1.0, Physical Scale Fraction", 1.0, false, MODULE.UpdateUnits )

hab.AddCvar( nil, "Footstep_Min_Speed", 128, CVAL_NUMBER, HAB_FCVAR_SERVER, "Default: 128, Minimum player speed to stop footstep sounds.", 128, false )

hab.AddCvar( nil, "Footstep_Suppress_Crouched", 1, CVAL_NUMBER, HAB_FCVAR_SERVER, "Default: 1, Stop footsteps from playing when the player is crouched.", 1, false )

hab.SubLoad( MODULE.info.iname )
