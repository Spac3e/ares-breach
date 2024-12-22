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

hab.AddCvar( nil, "Developer", 0, CVAL_NUMBER, HAB_FCVAR_SERVER, "Default: 0, Enable developer mode.", 0, false )

-- Client Menu Panels
if CLIENT then
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
end

hab.SubLoad( MODULE.info.iname )
