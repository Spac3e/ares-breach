--[[


addons/[admin]_gmodadminsuite/lua/gmodadminsuite/modules/secondaryusergroups/sh_init.lua

--]]

if (SERVER) then
	AddCSLuaFile("sh_core.lua")
	AddCSLuaFile("cl_menu.lua")
end

GAS:hook("gmodadminsuite:LoadModule:secondaryusergroups", "LoadModule:secondaryusergroups", function()
	include("gmodadminsuite/modules/secondaryusergroups/sh_core.lua")
	if (SERVER) then
		include("gmodadminsuite/modules/secondaryusergroups/sv_secondaryusergroups.lua")
		include("gmodadminsuite/modules/secondaryusergroups/sv_permissions.lua")
	else
		include("gmodadminsuite/modules/secondaryusergroups/cl_menu.lua")
	end
end)