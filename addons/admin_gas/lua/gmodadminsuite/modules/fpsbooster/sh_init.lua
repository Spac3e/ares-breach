--[[


addons/[admin]_gmodadminsuite/lua/gmodadminsuite/modules/fpsbooster/sh_init.lua

--]]

if (SERVER) then
	AddCSLuaFile("cl_menu.lua")
else
	GAS:hook("gmodadminsuite:LoadModule:fpsbooster", "LoadModule:fpsbooster", function()
		include("gmodadminsuite/modules/fpsbooster/cl_menu.lua")
	end)
end