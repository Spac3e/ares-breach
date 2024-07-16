AddCSLuaFile()

--######## LOAD CONFIG ########--

GAS.Config = {}

local function InstallConfigAddon()
	if (SERVER) then
		GAS.BillysErrors:AddMessage(BillysErrors.IMPORTANCE_FATAL, "Looks like the GmodAdminSuite Config Addon has not been installed to your server: ", {Link = "https://gmodsto.re/gmodadminsuite-config-addon"}, "\nYou need to install this addon in order to use & configure GmodAdminSuite.")
	end
end

if (not file.Exists("gmodadminsuite_config.lua", "LUA")) then
	return InstallConfigAddon()
else
	local worked = include("gmodadminsuite_config.lua")
	if (not worked) then
		if (SERVER) then
			GAS.BillysErrors:AddMessage(BillysErrors.IMPORTANCE_FATAL, "GmodAdminSuite config failed to load. You probably have an error in your config. Please read your server's console.")
			return
		end
		return
	else
		GAS:HeaderPrint("Config successfully loaded", GAS_PRINT_COLOR_GOOD, GAS_PRINT_TYPE_INFO)
	end
end

if (not file.Exists("gmodadminsuite_lua_functions.lua", "LUA")) then
	return InstallConfigAddon()
else
	local worked = include("gmodadminsuite_lua_functions.lua")
	if (not worked) then
		if (SERVER) then
			GAS.BillysErrors:AddMessage(BillysErrors.IMPORTANCE_FATAL, "GmodAdminSuite Lua functions config failed to load. You probably have an error in your config. Please read your server's console.")
			return
		end
		return
	else
		GAS:HeaderPrint("Lua functions successfully loaded", GAS_PRINT_COLOR_GOOD, GAS_PRINT_TYPE_INFO)
	end
end

if (SERVER) then
	if (not file.Exists("gmodadminsuite_mysql_config.lua", "LUA")) then
		return InstallConfigAddon()
	else
		GAS.Config.MySQL = {}
		local worked = include("gmodadminsuite_mysql_config.lua")
		if (not worked) then
			GAS.BillysErrors:AddMessage(BillysErrors.IMPORTANCE_FATAL, "GmodAdminSuite MySQL config failed to load. You probably have an error in your config. Please read your server's console.")
			return
		else
			GAS:HeaderPrint("MySQL config successfully loaded", GAS_PRINT_COLOR_GOOD, GAS_PRINT_TYPE_INFO)
		end
	end

	if (not file.Exists("gmodadminsuite_steam_apikey.lua", "LUA")) then
		return InstallConfigAddon()
	else
		GAS.SteamAPI = {}
		GAS.SteamAPI.Config = {}
		local worked = include("gmodadminsuite_steam_apikey.lua")
		if (not worked) then
			GAS.BillysErrors:AddMessage(BillysErrors.IMPORTANCE_FATAL, "GmodAdminSuite Steam API key config failed to load. You probably have an error in your config. Please read your server's console.")
			return
		end
	end
end

--######## ADD RESOURCES ########--

if (SERVER) then
	-- Fonts must be downloaded from the server
	resource.AddFile("resource/fonts/circular-bold.ttf")
	resource.AddFile("resource/fonts/circular-medium.ttf")
	resource.AddFile("resource/fonts/rubik.ttf")
	resource.AddFile("resource/fonts/rubik-bold.ttf")

	if (GAS.Config.WorkshopDL == true or GAS.Config.WorkshopDL == nil) then
		resource.AddWorkshop("1596971443")
	end
	if (GAS.Config.ServerDL == true) then
		for _,v in ipairs({"materials/gmodadminsuite/*", "sound/gmodadminsuite/*"}) do
			local files = file.Find(v, "GAME")
			for _,f in pairs(files) do
				resource.AddFile((v:gsub("%*$", "")) .. f)
			end
		end
	end
else
	for _,v in ipairs((file.Find("sound/gmodadminsuite/*", "GAME"))) do
		util.PrecacheSound("sound/gmodadminsuite/" .. v)
	end
end

--######## Account ID ########--

function GAS:SteamID64ToAccountID(steamid64)
	return GAS:SteamIDToAccountID(util.SteamIDFrom64(steamid64))
end

function GAS:SteamIDToAccountID(steamid)
	local acc32 = tonumber(steamid:sub(11))
	return (acc32 * 2) + tonumber(steamid:sub(9,9))
end

function GAS:AccountIDToSteamID(account_id)
	local sid32 = tonumber(account_id) / 2
	if (sid32 % 1 > 0) then
		return "STEAM_0:1:" .. math.floor(sid32)
	else
		return "STEAM_0:0:" .. sid32
	end
end

function GAS:AccountIDToSteamID64(account_id)
	return util.SteamIDTo64(GAS:AccountIDToSteamID(account_id))
end

--######## MISC ########--

function GAS:IsIPAddress(ip_address, forbid_port)
	local v1,v2,v3,v4,port = ip_address:match("^(%d+)%.(%d+)%.(%d+)%.(%d+)(.*)")
	return
		(v1 ~= nil and (v1 == "0" or (not v1:find("^0") and tonumber(v1) >= 1 and tonumber(v1) <= 255))) and
		(v2 ~= nil and (v2 == "0" or (not v2:find("^0") and tonumber(v2) >= 1 and tonumber(v2) <= 255))) and
		(v3 ~= nil and (v3 == "0" or (not v3:find("^0") and tonumber(v3) >= 1 and tonumber(v3) <= 255))) and
		(v4 ~= nil and (v4 == "0" or (not v4:find("^0") and tonumber(v4) >= 1 and tonumber(v4) <= 255))) and
		(
			(forbid_port == true and (port == nil or #port == 0)) or
			
			(not forbid_port and (
					(port == nil or #port == 0) or
					(port ~= nil and #port > 1 and #port <= 6 and port:sub(1,1) == ":" and
						(port:sub(2) == "0" or
							(tonumber(port:sub(2)) ~= nil and not port:sub(2):find("^0") and tonumber(port:sub(2)) >= 0 and tonumber(port:sub(2)) <= 65535)
						)
					)
				)
			)
		)
end

function GAS:BoolToBit(bool)
	if (bool == true) then
		return 1
	elseif (bool == false) then
		return 0
	end
end
function GAS:BitToBool(bit)
	if (tonumber(bit) == 1) then
		return true
	elseif (tonumber(bit) == 0) then
		return false
	end
end

function GAS:Unvectorize(vec)
if vec == nil then
	return "0,0,0"
end
	if (vec.r and vec.g and vec.b) then
		local vec_a = ""
		if (vec.a and vec.a ~= 255) then
			vec_a = "," .. vec.a
		end
		return vec.r .. "," .. vec.g .. "," .. vec.b .. vec_a
	elseif (vec.p and vec.y and vec.r) then
		return vec.p .. "," .. vec.y .. "," .. vec.r
	elseif (vec.x and vec.y and vec.z) then
		return vec.x .. "," .. vec.y .. "," .. vec.z
	end
end

function GAS:SetClipboardText(text)
	SetClipboardText(text)
	GAS:PlaySound("confirmed")
	bVGUI.MouseInfoTooltip.Create(GAS:Phrase("copied"))
end

function GAS:OpenURL(url)
	GAS:PlaySound("popup")
	gui.OpenURL(url)
end

function GAS:table_Flip(tbl)
	local new_tbl = {}
	for i,v in pairs(tbl) do
		new_tbl[v] = i
	end
	return new_tbl
end

function GAS:table_IsEmpty(tbl)
	return next(tbl) == nil
end

function GAS:table_ValuesFromKey(tab, key)
	local res = {}
	for k, v in pairs( tab ) do
		if ( v[ key ] ~= nil ) then res[ #res + 1 ] = v[ key ] end
	end
	return res
end

function GAS:table_RemoveEmptyChildren(tbl, tbl_key, parent_tbl)
	for k,v in pairs(tbl) do
		if (type(v) == "table") then
			if (GAS:table_IsEmpty(v)) then
				tbl[k] = nil
				if (tbl_key ~= nil and parent_tbl ~= nil and GAS:table_IsEmpty(tbl)) then
					parent_tbl[tbl_key] = nil
				end
			else
				tbl[k] = GAS:table_RemoveEmptyChildren(v, k, tbl)
			end
		end
	end
	if (GAS:table_IsEmpty(tbl)) then
		if (tbl_key == nil and parent_tbl == nil) then
			return {}
		else
			return nil
		end
	else
		return tbl
	end
end

function GAS:utf8_force_strip(str)
	return (utf8.force(str):gsub("�", ""))
end

--######## LUA FUNCTIONS ########--

function GAS:RunLuaFunction(lua_func_name, ...)
	if (not GAS.LuaFunctions[lua_func_name]) then
		GAS:print("Tried to run a Lua function that doesn't exist! (" .. lua_func_name .. ")", GAS.PRINT_ERROR)
	else
		return GAS.LuaFunctions[lua_func_name](...)
	end
end

--######## TEAM HELPERS ########--

local indexed_teams = {}
function GAS:TeamFromName(team_name)
	if (indexed_teams[team_name] ~= nil) then
		return indexed_teams[indexed_teams]
	else
		for i,v in pairs(team.GetAllTeams()) do
			if (v.Name == team_name) then
				indexed_teams[i] = v.Name
				return i
			end
		end
	end
end

--######## SOUND ########--

local sounds = {alert = "gmodadminsuite/alert.mp3"}
function GAS:PlaySound(sound_name)
	surface.PlaySound(sounds[sound_name] or "gmodadminsuite/" .. sound_name .. ".ogg")
end

--######## MARKUP HELPERS ########--

function GAS:MarkupToPlaintext(str)
	str = tostring(str)
	if (markup and markup.ToPlaintext) then
		return markup.ToPlaintext(str)
	else
		return (str:gsub("</?%a+=?.->",""))
	end
end

function GAS:EscapeMarkup(str)
	str = tostring(str)
	if (markup and markup.Escape) then
		return markup.Escape(str)
	else
		return (str:gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;"))
	end
end

local special_markdown_chars = {"\\","`","*","_","{","}","[","]","(",")","#","+","-",".","!"}
function GAS:EscapeMarkdown(str)
	for _,v in ipairs(special_markdown_chars) do
		str = (str:gsub("%" .. v, "\\" .. v))
	end
	return str
end

function GAS:EscapeJSON(str)
	return (str:gsub("\\", "\\"):gsub('"', '\\"'))
end

--######## MySQL ########--

if (SERVER) then
	GAS:EndHeader()
	GAS:StartHeader("Database")
	if (GAS.Config.MySQL.Enabled == true) then
		GAS:HeaderPrint("MySQL enabled", GAS_PRINT_TYPE_INFO)
		local mysqloo_installed = false
		if (system.IsLinux()) then
			if (file.Exists("lua/bin/gmsv_mysqloo_win32.dll", "GAME") and not file.Exists("lua/bin/gmsv_mysqloo_linux.dll", "GAME")) then
				GAS.BillysErrors:AddMessage(BillysErrors.IMPORTANCE_FATAL, "You have the wrong version of MySQLOO installed. Your server is running on Linux, but you have the Windows version of the module installed.\n", {Link = "https://github.com/FredyH/MySQLOO#install-instructions"})
			elseif (not file.Exists("lua/bin/gmsv_mysqloo_linux.dll", "GAME")) then
				GAS.BillysErrors:AddMessage(BillysErrors.IMPORTANCE_FATAL, "You do not have the required MySQLOO module installed on your server. MySQLOO is required to communicate with your MySQL Server.\n", {Link = "https://github.com/FredyH/MySQLOO#install-instructions"})
			elseif (not file.Exists("libmysqlclient.so.18", "BASE_PATH")) then
				GAS.BillysErrors:AddMessage(BillysErrors.IMPORTANCE_FATAL, "You have installed the MySQLOO module to your server correctly, but you did not install the libmysqlclient.so.18 dependency to your server as instructed by the MySQLOO installation instructions.\n", {Link = "https://github.com/FredyH/MySQLOO#install-instructions"})
			else
				mysqloo_installed = true
			end
		elseif (system.IsWindows()) then
			if (file.Exists("lua/bin/gmsv_mysqloo_linux.dll", "GAME") and not file.Exists("lua/bin/gmsv_mysqloo_win32.dll", "GAME")) then
				GAS.BillysErrors:AddMessage(BillysErrors.IMPORTANCE_FATAL, "You have the wrong version of MySQLOO installed. Your server is running on Windows, but you have the Linux version of the module installed.\n", {Link = "https://github.com/FredyH/MySQLOO#install-instructions"})
			elseif (not file.Exists("lua/bin/gmsv_mysqloo_win32.dll", "GAME")) then
				GAS.BillysErrors:AddMessage(BillysErrors.IMPORTANCE_FATAL, "You do not have the required MySQLOO module installed on your server. MySQLOO is required to communicate with your MySQL Server.\n", {Link = "https://github.com/FredyH/MySQLOO#install-instructions"})
			elseif (not file.Exists("libmysql.dll", "BASE_PATH")) then
				GAS.BillysErrors:AddMessage(BillysErrors.IMPORTANCE_FATAL, "You have installed the MySQLOO module to your server correctly, but you did not install the libmysql.dll dependency to your server as instructed by the MySQLOO installation instructions.\n", {Link = "https://github.com/FredyH/MySQLOO#install-instructions"})
			else
				mysqloo_installed = true
			end
		else
			GAS.BillysErrors:AddMessage(BillysErrors.IMPORTANCE_FATAL, "You must be running Linux or Windows to use MySQL and its required module, MySQLOO.\n", {Link = "https://github.com/FredyH/MySQLOO#install-instructions"})
		end
		if (mysqloo_installed) then
			GAS:HeaderPrint("MySQLOO is installed!", GAS_PRINT_COLOR_GOOD, GAS_PRINT_TYPE_INFO)
		else
			return
		end
	else
		--GAS:HeaderPrint("MySQL disabled, using local server database", GAS_PRINT_TYPE_INFO)
	end

	include("sv_database.lua")
	GAS:EndHeader()
else
	GAS:EndHeader()
end

--######## NETWORKING ########--

include("sh_networking.lua")

--######## HOOKING ########--

function GAS:hook(event, identifier, func)
	GAS:unhook(event, identifier)
	hook.Add(event, "gmodadminsuite:" .. identifier, func)
end
function GAS:unhook(event, identifier)
	hook.Remove(event, "gmodadminsuite:" .. identifier)
end

include("gmodadminsuite/sh_hooks.lua")

--######## TIMERS ########--

function GAS:timer(name, ...)
	GAS:untimer(name)
	timer.Create("gmodadminsuite:" .. name, ...)
end
function GAS:untimer(name)
	timer.Remove("gmodadminsuite:" .. name)
end

--######## CONFIGS ########--

if (not file.IsDir("gmodadminsuite/configs", "DATA")) then
	file.CreateDir("gmodadminsuite/configs", "DATA")
end
if (SERVER) then
	GAS:netInit("getconfig")
	GAS:netInit("uncacheconfig")

	function GAS:DeleteConfig(config_name)
		file.Delete("gmodadminsuite/configs/" .. config_name .. ".txt")
		GAS.ConfigCache[config_name] = nil
	end

	GAS.ConfigCache = {}
	function GAS:GetConfig(config_name, default_config)
		if (GAS.ConfigCache[config_name]) then return GAS.ConfigCache[config_name] end
		if (file.Exists("gmodadminsuite/configs/" .. config_name .. ".txt", "DATA")) then
			local config = file.Read("gmodadminsuite/configs/" .. config_name .. ".txt", "DATA")
			if (config) then
				config = GAS:DeserializeTable(config)
				if (config) then
					GAS.ConfigCache[config_name] = config
					return config
				end
			end
			GAS:print("Failed to load config: " .. config_name .. "; reverting to default config.", GAS_PRINT_COLOR_BAD, GAS_PRINT_TYPE_FAIL)
			GAS.BillysErrors:AddMessage({"Failed to load config: " .. config_name .. "; reverting to default config."})
		end
		if (default_config) then
			GAS:SaveConfig(config_name, default_config)
			return default_config
		end
	end
	function GAS:SaveConfig(config_name, config)
		GAS.ConfigCache[config_name] = config

		local serialized_config = GAS:SerializeTable(config)

		file.Write("gmodadminsuite/configs/" .. config_name .. ".txt", serialized_config)

		GAS:netStart("uncacheconfig")
			net.WriteString(config_name)
		net.Broadcast()

		return config
	end

	GAS:netReceive("getconfig", function(ply)
		local config_name = net.ReadString()
		if (file.Exists("gmodadminsuite/configs/" .. config_name .. ".txt", "DATA")) then
			local data = util.Compress(file.Read("gmodadminsuite/configs/" .. config_name .. ".txt", "DATA"))
			local data_len = #data
			GAS:netStart("getconfig")
				net.WriteString(config_name)
				net.WriteUInt(data_len, 32)
				net.WriteData(data, data_len)
			net.Send(ply)
		end
	end)
else
	GAS.ConfigCache = {}

	GAS.ConfigCallbacks = {}
	function GAS:GetConfig(config_name, callback)
		if (callback) then
			GAS.ConfigCallbacks[config_name] = callback
		end
		if (GAS.ConfigCache[config_name]) then
			if (callback) then
				callback(GAS.ConfigCache[config_name])
			end
			return GAS.ConfigCache[config_name]
		end
		GAS:netStart("getconfig")
			net.WriteString(config_name)
		net.SendToServer()
	end
	GAS:netReceive("getconfig", function()
		local config_name = net.ReadString()
		local data_len = net.ReadUInt(32)
		local data = net.ReadData(data_len)
		data = util.Decompress(data)
		data = GAS:DeserializeTable(data)

		GAS.ConfigCache[config_name] = data

		GAS.ConfigCallbacks[config_name](data)
	end)

	GAS.LocalConfigCache = {}
	function GAS:GetLocalConfig(config_name, default_config)
		if (GAS.LocalConfigCache[config_name]) then return GAS.LocalConfigCache[config_name] end

		if (file.Exists("gmodadminsuite/configs/" .. config_name .. ".txt", "DATA")) then
			local config = file.Read("gmodadminsuite/configs/" .. config_name .. ".txt", "DATA")
			if (config) then
				config = GAS:DeserializeTable(config)
				if (config) then
					GAS.LocalConfigCache[config_name] = config
					return config
				end
			end
		end

		if (default_config) then
			GAS:SaveLocalConfig(config_name, default_config)
			return default_config
		end
	end
	function GAS:SaveLocalConfig(config_name, config)
		GAS.LocalConfigCache[config_name] = config
		file.Write("gmodadminsuite/configs/" .. config_name .. ".txt", GAS:SerializeTable(config))
		return config
	end

	function GAS:UncacheConfig(config_name)
		GAS.ConfigCache[config_name] = nil
	end
	GAS:netReceive("uncacheconfig", function()
		GAS:UncacheConfig(net.ReadString())
	end)
end

--######## SERIALIZATION ########--

GAS.von = include("gmodadminsuite/thirdparty/von.lua")
GAS.pon = include("gmodadminsuite/thirdparty/pon.lua")
GAS.spon = include("gmodadminsuite/thirdparty/spon.lua")
function GAS:SerializeTable(tbl)
	return GAS.von.serialize(tbl)
end
function GAS:DeserializeTable(tbl)
	local succ, r = pcall(GAS.von.deserialize, tbl)
	if (not succ) then
		return GAS.spon.decode(tbl)
	else
		return r
	end
end

--######## LANGUAGE ########--

include("gmodadminsuite/sh_language.lua")

--######## OFFLINE PLAYER DATA ########--

include("gmodadminsuite/sh_offline_player_data.lua")

--######## TEAMS ########--

include("gmodadminsuite/sh_teams.lua")

--######## STEAM API ########--

if (SERVER) then include("gmodadminsuite/sv_steam_avatar.lua") end

--######## AFK ########--

include("gmodadminsuite/sh_afk.lua")

--######## COUNTRY CODES ########--

if (CLIENT) then include("gmodadminsuite/cl_country_codes.lua") end

--######## COMMANDS ########--

local CmdRegistrations = {}
function GAS:RegisterCommand(text, module_name)
	if (GAS.Commands and GAS.Commands.Loaded) then
		GAS.Commands:RegisterCommand(text, module_name)
	else
		table.insert(CmdRegistrations, {text, module_name})
	end
end
GAS:hook("gmodadminsuite:Commands:Loaded", "CommandManagerLoaded", function()
	if (not CmdRegistrations) then return end
	for _,v in ipairs(CmdRegistrations) do
		GAS.Commands:RegisterCommand(unpack(v))
	end
	CmdRegistrations = nil
end)

--######## REGISTRY TABLES ########--

include("gmodadminsuite/sh_registry_tbl.lua")

--######## XEON ########--

if (SERVER) then include("gmodadminsuite/sv_xeon.lua") end

--######## INCLUDE FILES ########--

function GAS:Init()
	include("gmodadminsuite/sh_modules.lua")
	include("gmodadminsuite/sh_permissions.lua")

	if (CLIENT) then
		include("gmodadminsuite/cl_contextmenu.lua")
		include("gmodadminsuite/cl_selection_prompts.lua")
		include("gmodadminsuite/cl_menu.lua")
	else
		include("gmodadminsuite/sv_menu.lua")
	end
end
GAS:Init()