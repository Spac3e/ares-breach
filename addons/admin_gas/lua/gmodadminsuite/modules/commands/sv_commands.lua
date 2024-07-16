GAS.Commands.Config = GAS:GetConfig("commands", {ModuleCommands = {}, Commands = {}})

GAS:netInit("commands:ACTION_COMMANDS_MENU")
GAS:netInit("commands:ACTION_WEBSITE")
GAS:netInit("commands:ACTION_LUA_FUNCTION")
GAS:netInit("commands:ACTION_GAS_MODULE")
GAS:netInit("commands:no_permission")

function GAS.Commands:RegisterCommand(text, module_name)
	if (GAS.Commands.Config.ModuleCommands[module_name]) then return end
	GAS.Commands.Config.ModuleCommands[module_name] = true
	GAS.Commands.Config.Commands[text] = {
		action = {
			type = GAS.Commands.ACTION_GAS_MODULE,
			module_name = module_name
		},
		hide_command = true,
		help = "Opens GmodAdminSuite module " .. GAS.Modules.Info[module_name].Name,
	}
	GAS:SaveConfig("commands", GAS.Commands.Config)
end

GAS:hook("PlayerSay", "commands", function(ply, txt)
	local cmd = txt:lower()
	local options = GAS.Commands.Config.Commands[cmd]
	if (not options) then return end
	
	local can_use_command = OpenPermissions:HasPermission(ply, "gmodadminsuite_commands/" .. cmd)
	if (can_use_command) then
		if (options.action.type == GAS.Commands.ACTION_WEBSITE) then
			GAS:netStart("commands:ACTION_WEBSITE")
				net.WriteString(options.action.website)
			net.Send(ply)
		elseif (options.action.type == GAS.Commands.ACTION_GAS_MODULE) then
			GAS:netStart("commands:ACTION_GAS_MODULE")
				net.WriteString(options.action.module_name)
			net.Send(ply)
		elseif (options.action.type == GAS.Commands.ACTION_TELEPORT) then
			ply:SetPos(Vector(options.action.TelePosX, options.action.TelePosY, options.action.TelePosZ))
			ply:SetAngles(Angle(options.action.TeleAngP, options.action.TeleAngY, options.action.TeleAngR))
		elseif (options.action.type == GAS.Commands.ACTION_COMMANDS_MENU) then
			GAS:netStart("commands:ACTION_COMMANDS_MENU")
			net.Send(ply)
		elseif (options.action.type == GAS.Commands.ACTION_COMMAND) then
			ply:ConCommand(options.action.command)
		elseif (options.action.type == GAS.Commands.ACTION_CHAT) then
			return options.action.chat
		elseif (options.action.type == GAS.Commands.ACTION_LUA_FUNCTION_SV) then
			GAS:RunLuaFunction(options.action.lua_func_name, ply, command)
		elseif (options.action.type == GAS.Commands.ACTION_LUA_FUNCTION_CL) then
			GAS:netStart("commands:ACTION_LUA_FUNCTION")
				net.WriteString(options.action.lua_func_name)
				net.WriteString(command)
			net.Send(ply)
		end
	else
		GAS:netStart("commands:no_permission")
		net.Send(ply)
	end

	if (options.hide_command == true) then
		return ""
	end
end)

GAS:netInit("commands:NewCommand")
GAS:netReceive("commands:NewCommand", function(ply, l)
	local command_name = net.ReadString():lower()
	local help = net.ReadString()
	local hide_in_chat = net.ReadBool()
	local action = net.ReadUInt(4) - 1
	local action_value
	if (action == GAS.Commands.ACTION_TELEPORT) then
		action_value = {net.ReadVector(), net.ReadAngle()}
	else
		action_value = net.ReadString()
	end
	local delete_old_command = net.ReadBool()
	local old_command
	if (delete_old_command) then old_command = net.ReadString() end

	if (not OpenPermissions:IsOperator(ply)) then return end

	if (
		(action == GAS.Commands.ACTION_WEBSITE and (#action_value == 0 or not action_value:lower():find("^https?://.+%..+"))) or
		((action == GAS.Commands.ACTION_LUA_FUNCTION_SV or action == GAS.Commands.ACTION_LUA_FUNCTION_CL) and GAS.LuaFunctions[action_value] == nil) or
		((action == GAS.Commands.ACTION_COMMAND or action == GAS.Commands.ACTION_CHAT) and #action_value == 0) or
		(action == GAS.Commands.ACTION_GAS_MODULE and (GAS.Modules.Info[action_value] == nil or GAS.Modules.Info[action_value].NoMenu == true))
	) then
		return
	end

	local cmd_table = {
		action = {type = action},
		hide_command = hide_in_chat
	}
	if (#help > 0) then cmd_table.help = help end

	if (action == GAS.Commands.ACTION_WEBSITE) then
		cmd_table.action.website = action_value
	elseif (action == GAS.Commands.ACTION_LUA_FUNCTION_SV or action == GAS.Commands.ACTION_LUA_FUNCTION_CL) then
		cmd_table.action.lua_func_name = action_value
	elseif (action == GAS.Commands.ACTION_COMMAND) then
		cmd_table.action.command = action_value
	elseif (action == GAS.Commands.ACTION_CHAT) then
		cmd_table.action.chat = action_value
	elseif (action == GAS.Commands.ACTION_GAS_MODULE) then
		cmd_table.action.module_name = action_value
	elseif (action == GAS.Commands.ACTION_TELEPORT) then
		cmd_table.action.TelePosX = action_value[1].x
		cmd_table.action.TelePosY = action_value[1].y
		cmd_table.action.TelePosZ = action_value[1].z

		cmd_table.action.TeleAngP = action_value[1].p
		cmd_table.action.TeleAngY = action_value[1].y
		cmd_table.action.TeleAngR = action_value[1].r
	end

	if (old_command) then
		GAS.Commands.Config.Commands[old_command] = nil
	end

	GAS.Commands.Config.Commands[command_name] = cmd_table
	GAS:SaveConfig("commands", GAS.Commands.Config)

	GAS:netStart("commands:NewCommand")
	net.Send(ply)

	GAS.Commands:ReloadPermissions()
end)

GAS:netInit("commands:DeleteCommand")
GAS:netReceive("commands:DeleteCommand", function(ply)
	local command_name = net.ReadString():lower()
	if (not OpenPermissions:IsOperator(ply)) then return end
	GAS.Commands.Config.Commands[command_name] = nil
	GAS:SaveConfig("commands", GAS.Commands.Config)

	GAS.Commands:ReloadPermissions()
end)

GAS.Commands.Loaded = true
hook.Run("gmodadminsuite:Commands:Loaded")