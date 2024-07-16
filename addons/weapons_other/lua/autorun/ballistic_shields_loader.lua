--[[


addons/[weapons]_ballistic_shields/lua/autorun/ballistic_shields_loader.lua

--]]

if SERVER then
	AddCSLuaFile("ballistic_shields/cl_bs_util.lua")
	AddCSLuaFile( "ballistic_shields/sh_bs_util.lua" )
	AddCSLuaFile( "ballistic_shields/sh_bs_lang.lua" )
	AddCSLuaFile("libraries/cl_surfacegeturl.lua")
	AddCSLuaFile("bs_config.lua")
	resource.AddWorkshop("1819166858")
end
include( "bs_config.lua" )
include( "libraries/cl_surfacegeturl.lua" )
include( "ballistic_shields/cl_bs_util.lua" )
include( "ballistic_shields/sh_bs_util.lua" )
include( "ballistic_shields/sh_bs_lang.lua" )
resource.AddFile( "resource/fonts/bfhud.ttf" )