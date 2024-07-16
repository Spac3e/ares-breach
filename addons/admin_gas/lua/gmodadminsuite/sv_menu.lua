GAS:netInit("menu")
GAS:netInit("menu_nopermission")
GAS:netInit("menu_unknown_module")
GAS:netInit("menu_disabled_module")
GAS:netInit("menu_module_nopermission")
GAS:netInit("menu_open")
GAS:netInit("send_server_data")
GAS:netInit("getmymodules")

function GAS:OpenMenu(ply, module_name)
	local is_operator = OpenPermissions:IsOperator(ply)
	if (is_operator or (module_name ~= nil and GAS.Modules.Info[module_name].Public == true) or GAS:CanAccessMenu(ply)) then
		if (not module_name) then
			GAS:netStart("menu")
				net.WriteString("")
			net.Send(ply)
		elseif (is_operator or GAS.Modules.Info[module_name].Public == true or OpenPermissions:HasPermission(ply, "gmodadminsuite/" .. module_name)) then
			GAS:netStart("menu")
				net.WriteString(module_name)
			net.Send(ply)
		else
			GAS:netQuickie("menu_module_nopermission", ply)
		end
	else
		GAS:netQuickie("menu_nopermission", ply)
	end
end

GAS:hook("PlayerSay", "menu_command", function(ply, txt)
	local txt = txt:lower()
	local cmd = GAS.Config.ChatCommand:lower()
	if (txt == cmd or (txt:sub(1, #cmd + 1)) == cmd .. " ") then
		local args = string.Explode(" ", txt)
		if (#args >= 2 and #string.Trim(args[2]) > 0) then
			local verify = GAS.Modules:IsModuleEnabled(args[2])
			if (verify == GAS.Modules.MODULE_ENABLED) then
				GAS:OpenMenu(ply, args[2])
			elseif (verify == GAS.Modules.MODULE_DISABLED) then
				GAS:netQuickie("menu_disabled_module", ply)
			elseif (verify == GAS.Modules.MODULE_UNKNOWN) then
				GAS:netQuickie("menu_unknown_module", ply)
			end
		else
			GAS:OpenMenu(ply)
		end
		return ""
	end
end)

GAS:netReceive("menu_open", function(ply)
	local module_name = net.ReadString()
	if (#module_name == 0) then module_name = false end
	if (not module_name) then
		GAS:OpenMenu(ply)
	else
		local verify = GAS.Modules:IsModuleEnabled(module_name)
		if (verify == GAS.Modules.MODULE_ENABLED) then
			GAS:OpenMenu(ply, module_name)
		elseif (verify == GAS.Modules.MODULE_DISABLED) then
			GAS:netQuickie("menu_disabled_module", ply)
		elseif (verify == GAS.Modules.MODULE_UNKNOWN) then
			GAS:netQuickie("menu_unknown_module", ply)
		end
	end
end)