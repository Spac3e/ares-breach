if (CLIENT and not file.Exists("gmodadminsuite/sh_networking.lua", "LUA")) then
	-- serverside code failed for some reason, abort loading GAS
	return
end

if (CLIENT and GAS) then
	if (IsValid(GAS.Menu)) then
		GAS.Menu:Close()
	end
	if (IsValid(GAS.ModuleFrame)) then
		GAS.ModuleFrame:Close()
	end
end

if (not file.IsDir("gmodadminsuite", "DATA")) then
	file.CreateDir("gmodadminsuite", "DATA")
end

GAS = {}

--######## InitPostEntity ########--

function GAS:InitPostEntity(func)
	if (GAS_InitPostEntity) then
		func()
	else
		table.insert(GAS.InitPostEntity_hooks, func)
	end
end
GAS.InitPostEntity_hooks = {}
function GAS:InitPostEntity_Run()
	GAS_InitPostEntity = true
	for _,v in ipairs(GAS.InitPostEntity_hooks) do v() end
end
if (SERVER) then
	util.AddNetworkString("GAS.InitPostEntityNetworking")

	net.Receive("GAS.InitPostEntityNetworking", function(_, ply)
		if (not ply.GAS_InitPostEntityNetworking) then
			ply.GAS_InitPostEntityNetworking = true
			net.Start("GAS.InitPostEntityNetworking")
			net.Send(ply)
		end
	end)
end

if (not GAS_InitPostEntity) then
	if (SERVER) then
		hook.Add("InitPostEntity", "gmodadminsuite:InitPostEntity_Loader", GAS.InitPostEntity_Run)
	else
		hook.Add("InitPostEntity", "gmodadminsuite:InitPostEntity_Loader", function()
			net.Receive("GAS.InitPostEntityNetworking", function()
				timer.Remove("GAS.InitPostEntityNetworking")
				GAS:InitPostEntity_Run()
			end)
			local function DoPing()
				net.Start("GAS.InitPostEntityNetworking")
				net.SendToServer()
			end
			DoPing()
			timer.Create("GAS.InitPostEntityNetworking", 2, 0, DoPing)
		end)
	end
end

--######## Initialize ########--

GAS_GMInitialize = GAS_GMInitialize == true or GM ~= nil or GAMEMODE ~= nil
GAS.GMInitialize_hooks = {}
function GAS:GMInitialize(func)
	if (GAS_GMInitialize) then
		func()
	else
		table.insert(GAS.GMInitialize_hooks, func)
	end
end
if (not GAS_GMInitialize) then
	local function GMInitialize()
		GAS_GMInitialize = true
		for _,v in ipairs(GAS.GMInitialize_hooks) do v() end
		GAS.GMInitialize_hooks = {}

		timer.Remove("gmodadminsuite:GMInitialize_Loader")
		hook.Remove("Initialize", "gmodadminsuite:GMInitialize_Loader")
	end
	hook.Add("Initialize", "gmodadminsuite:GMInitialize_Loader", function()
		timer.Remove("gmodadminsuite:GMInitialize_Loader")

		GAS:print("Gamemode initialized")

		GAS_GMInitialize = true
		for _,v in ipairs(GAS.GMInitialize_hooks) do v() end
		GAS.GMInitialize_hooks = {}
	end)
	timer.Simple(0, function()
		if (GM or GAMEMODE) then
			GMInitialize()
		else
			timer.Create("gmodadminsuite:GMInitialize_Loader", 1, 0, function()
				if (GM or GAMEMODE) then
					GAS:print("Gamemode initialized (late/did not fire)", GAS_PRINT_TYPE_WARN)
					GMInitialize()
				end
			end)
		end
	end)
end

--######## sv_hibernate_think ########--

if (SERVER) then
	RunConsoleCommand("sv_hibernate_think", "1")
end

--######## Clientside Lua Files ########--

AddCSLuaFile("gmodadminsuite_lua_functions.lua")
AddCSLuaFile("gmodadminsuite_config.lua")

AddCSLuaFile("gmodadminsuite/cl_contextmenu.lua")
AddCSLuaFile("gmodadminsuite/sh_teams.lua")
AddCSLuaFile("gmodadminsuite/sh_hooks.lua")
AddCSLuaFile("gmodadminsuite/sh_modules.lua")
AddCSLuaFile("gmodadminsuite/sh_language.lua")
AddCSLuaFile("gmodadminsuite/sh_afk.lua")
AddCSLuaFile("gmodadminsuite/cl_selection_prompts.lua")
AddCSLuaFile("gmodadminsuite/cl_menu.lua")
AddCSLuaFile("gmodadminsuite/cl_country_codes.lua")

AddCSLuaFile("gmodadminsuite/thirdparty/pon.lua")
AddCSLuaFile("gmodadminsuite/thirdparty/spon.lua")
AddCSLuaFile("gmodadminsuite/thirdparty/von.lua")

--######## PRINTING ########--

GAS_COLOR_WHITE = Color(255,255,255)

GAS_PRINT_COLOR_GOOD    = Color(0,255,0)
GAS_PRINT_COLOR_BAD     = Color(255,0,0)
GAS_PRINT_COLOR_NEUTRAL = Color(0,255,255)

GAS_PRINT_TYPE_INFO  = "[INFO]"
GAS_PRINT_TYPE_WARN  = "[WARN]"
GAS_PRINT_TYPE_FAIL  = "[FAIL]"
GAS_PRINT_TYPE_DEBUG = "[DEBUG]"
function GAS:print(print_text, print_status_or_type, print_type)
	local type_str = ""
	local print_status = GAS_PRINT_COLOR_NEUTRAL
	if (print_type) then
		print_status = print_status_or_type
		type_str = print_type .. " "
	else
		if (type(print_status_or_type) == "string") then
			type_str = print_status_or_type .. " "
		end
		if (type(print_status_or_type) == "table") then
			print_status = print_status_or_type
		end
	end
	--MsgC(print_status, "[GmodAdminSuite] ", type_str, GAS_COLOR_WHITE, print_text .. "\n")
end

if (CLIENT) then
	function GAS:chatPrint(print_text, print_status_or_type, print_type)
		local type_str = ""
		local print_status = GAS_PRINT_COLOR_NEUTRAL
		if (print_type) then
			print_status = print_status_or_type
			type_str = print_type .. " "
		else
			if (type(print_status_or_type) == "string") then
				type_str = print_status_or_type .. " "
			end
			if (type(print_status_or_type) == "table") then
				print_status = print_status_or_type
			end
		end
		chat.AddText(print_status, "[GmodAdminSuite] ", type_str, GAS_COLOR_WHITE, print_text)
	end
end

local first_header = true
local header_space_len = 85
local header_padding = 3
function GAS:StartHeader(header)
	if (first_header) then
		first_header = false
	else
		GAS:print("")
	end
	local header_len = #header + (header_padding * 2)
	GAS:print("[" .. ("="):rep(math.floor(header_space_len / 2 - header_len / 2)) .. (" "):rep(header_padding) .. header .. (" "):rep(header_padding) .. ("="):rep(math.ceil(header_space_len / 2 - header_len / 2)) .. "]")
end
function GAS:HeaderPrint(str, print_status_or_type, print_type)
	local str_len = utf8.len(str)

	local type_str = ""
	local print_status = GAS_PRINT_COLOR_NEUTRAL
	if (print_type) then
		print_status = print_status_or_type
		type_str = print_type .. " "
	else
		if (type(print_status_or_type) == "string") then
			type_str = print_status_or_type .. " "
		end
		if (type(print_status_or_type) == "table") then
			print_status = print_status_or_type
		end
	end

	local header_space_len_padded = header_space_len - 2 - #type_str
	if (str_len > header_space_len_padded) then
		for i = 1, math.ceil(str_len / header_space_len_padded) do
			GAS:HeaderPrint(str:sub(((i - 1) * header_space_len_padded) + 1, i * header_space_len_padded), print_status_or_type, print_type)
		end
		return
	else
		--MsgC(print_status, "[GmodAdminSuite] ", GAS_COLOR_WHITE, "[ ", print_status, type_str, GAS_COLOR_WHITE, str .. (" "):rep(header_space_len - str_len - #type_str - 2) .. " ]\n")
	end
end
function GAS:EndHeader()
	GAS:print("[" .. ("="):rep(header_space_len) .. "]")
end

--######## PRINT INFO ########--

GAS:StartHeader("GmodAdminSuite")

GAS.Version = "v1"

--######## BillysErrors ########--

require("billyserrors")
if (SERVER) then
	GAS.BillysErrors = BillysErrors:AddAddon({
		Name  = "GmodAdminSuite",
		Color = Color(0,125,255),
		Icon  = "icon16/shield.png"
	})
end

--######## INITIALIZE ########--

include("gmodadminsuite/sh_core.lua")

--######## RELOADER ########--

concommand.Add("gas_reload", function(ply)
	if (SERVER and IsValid(ply)) then return end
	include("autorun/gmodadminsuite.lua")
end)