--[[


addons/[admin]_gmodadminsuite/lua/gmodadminsuite/modules/commands/sh_init.lua

--]]

if (SERVER) then
	AddCSLuaFile("cl_commands.lua")
end

GAS.Commands = {}

GAS.Commands.ACTION_COMMANDS_MENU   = 0
GAS.Commands.ACTION_COMMAND         = 1
GAS.Commands.ACTION_CHAT            = 2
GAS.Commands.ACTION_WEBSITE         = 3
GAS.Commands.ACTION_TELEPORT        = 4
GAS.Commands.ACTION_LUA_FUNCTION_SV = 5
GAS.Commands.ACTION_LUA_FUNCTION_CL = 6
GAS.Commands.ACTION_GAS_MODULE      = 7

GAS:hook("gmodadminsuite:LoadModule:commands", "LoadModule:commands", function()
	if (SERVER) then
		include("gmodadminsuite/modules/commands/sv_commands.lua")
		include("gmodadminsuite/modules/commands/sv_permissions.lua")
	else
		include("gmodadminsuite/modules/commands/cl_commands.lua")
	end
end)