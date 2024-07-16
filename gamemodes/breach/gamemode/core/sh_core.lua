-- [[ Global Locals ]]--
BREACH = BREACH or {
	Util = {},
	Meta = {},
	Config = {},
	Round = {GameStarted = GameStarted || false, RoundsTillRestart = RoundsTillRestart or 10},
	NukePos = Vector(-712.862427, 6677.729492, 2225.919189),
	BlackListedSCPPlayers = {}
}

BREACH.Music = BREACH.Music or {}
BREACH.Music.VolumeThinkRate = 0.2
BREACH.Music.IgnoreThinkRate = BREACH.Music.IgnoreThinkRate or false
BREACH.Music.Custom_Volumes = {
	["entrance_zone_2.ogg"] = 0.3,
	["entrance_zone_1.ogg"] = 0.3,

	["light_zone_2.ogg"] = 0.3,
	["light_zone_1.ogg"] = 0.8,

	["heavy_zone_5.ogg"] = 0.3,
	["heavy_zone_2.ogg"] = 0.8,
	["uiu_mission_complete.ogg"] = 1.4,		
}

function BREACH.Msg(txt, color, ...)
    color = color or Color(255, 255, 255)
    MsgC(brlib.colors.blue, "[Ares Breach]", color, os.date(' %H:%M:%S - ', os.time()) .. string.format(txt, ...))
end

function BREACH.Include(strFile)
	if !strFile then
		return
	end

	if strFile:find("sv_module.lua") or strFile:find("sh_module.lua") or strFile:find("cl_module.lua") then
		return
	end

	if SERVER then
		if strFile:find("cl_") then
			BREACH.Msg("Pooling CLIENT file: "..strFile..'\n', CLR_MSG_ORANGE)

			AddCSLuaFile(strFile)
		elseif strFile:find("sv_") then
			BREACH.Msg("Loading SERVER file: "..strFile..'\n', CLR_MSG_CYAN)

			return include(strFile)
		else
			BREACH.Msg("Pooling and loading SHARED file: "..strFile..'\n', CLR_MSG_YELLOW)

			AddCSLuaFile(strFile)
			return include(strFile)
		end
	else
		if !strFile:find("sv_") then
			local v1 = strFile:find("cl_") and "CLIENT" or "SHARED"
			local v2 = strFile:find("cl_") and CLR_MSG_CYAN or CLR_MSG_YELLOW
			BREACH.Msg("Loading "..v1.." file: "..strFile..'\n', v2)

			return include(strFile)
		end
	end
end

function BREACH.IncludeDir(strDir, bRecursive)
	if !strDir:EndsWith("/") then
		strDir = strDir.."/"
	end

	local dir = GM.FolderName.."/gamemode/"..strDir

	if dir:find("breach_module") or dir:find("core/hooks") or dir:find("core/libs") or dir:find("configs/mapconfigs") then
		return
	end

	if bRecursive then
		local files, folders = file.Find(dir.."*", "LUA", "namedesc")
		
		for _, folder in SortedPairs(folders, true) do
			for _, File in SortedPairs(file.Find(dir .. folder .."/sh_*.lua", "LUA"), true) do
				BREACH.Include(dir .. folder .. "/" .. File)
			end
		end

		for _, folder in SortedPairs(folders, true) do
			for _, File in SortedPairs(file.Find(dir .. folder .."/sv_*.lua", "LUA"), true) do
				BREACH.Include(dir .. folder .. "/" .. File)
			end
		end

		for _, folder in SortedPairs(folders, true) do
			for _, File in SortedPairs(file.Find(dir .. folder .."/cl_*.lua", "LUA"), true) do
				BREACH.Include(dir .. folder .. "/" .. File)
			end
		end

		for k, v in SortedPairs(folders, true) do
			BREACH.IncludeDir(strDir..v, bRecursive)
		end
	else
		local files, _ = file.Find(dir.."*.lua", "LUA", "namedesc")

		for k, v in SortedPairs(files, true) do
			BREACH.Include(dir..v)
		end
	end
end

--ARG
BREACH.ARG_TYPE_BOOL = 0
BREACH.ARG_TYPE_COLOR = 1
BREACH.ARG_TYPE_PLAYER = 2
BREACH.ARG_TYPE_PLAYERLIST = 3
BREACH.ARG_TYPE_LIST = 4
BREACH.ARG_TYPE_NUMBER = 5
BREACH.ARG_TYPE_STRING = 6
BREACH.ARG_TYPE_TIME = 7

--Mute types
BREACH.MUTE_TYPE_NONE = 0
BREACH.MUTE_TYPE_CHAT = 2^0
BREACH.MUTE_TYPE_VOICE = 2^1
BREACH.MUTE_TYPE_ALL = bit.bor( BREACH.MUTE_TYPE_CHAT, BREACH.MUTE_TYPE_VOICE )

--Script side
BREACH.SIDE_CLIENT = 2^0
BREACH.SIDE_SERVER = 2^1
BREACH.SIDE_SHARED = bit.bor( BREACH.SIDE_CLIENT, BREACH.SIDE_SERVER )

--Var type
BREACH.VAR_TYPE_ANY = 0
BREACH.VAR_TYPE_BOOL = 1
BREACH.VAR_TYPE_INTEGER = 2
BREACH.VAR_TYPE_REAL = 3
BREACH.VAR_TYPE_STRING = 4

BREACH.Enums = {}

local enumToSide = {}
enumToSide[ BREACH.SIDE_CLIENT ] = "cl"
enumToSide[ BREACH.SIDE_SERVER ] = "sv"
enumToSide[ BREACH.SIDE_SHARED ] = "sh"

local sideToEnum = {}
sideToEnum[ "cl" ] = BREACH.SIDE_CLIENT
sideToEnum[ "sv" ] = BREACH.SIDE_SERVER
sideToEnum[ "sh" ] = BREACH.SIDE_SHARED

function BREACH.Enums:MuteTypeToString( muteType )
	if ( muteType == BREACH.MUTE_TYPE_ALL ) then
		return "Chat/Voice"
	elseif ( muteType == BREACH.MUTE_TYPE_CHAT ) then
		return "Chat"
	elseif ( muteType == BREACH.MUTE_TYPE_VOICE ) then
		return "Voice"
	else
		return "*ERROR*"
	end
end

function BREACH.Enums:TranslateEnumToSide( enum )
	return enumToSide[ enum ]
end

function BREACH.Enums:TranslateSideToEnum( enum )
	return sideToEnum[ enum ]
end

BREACH.ZombieTextureMaterials = {
	"models/all_scp_models/shared/arms_new",
	"models/all_scp_models/class_d/arms",
	"models/all_scp_models/class_d/arms_b",
	"models/all_scp_models/mog/skin_full_arm_wht_col",
	"models/all_scp_models/class_d/fatheads/fat_head",
	"models/all_scp_models/class_d/fatheads/fat_torso",
	"models/all_scp_models/class_d/body_b",
	"models/all_scp_models/class_d/prisoner_lt_head_d",
	"models/all_scp_models/shared/f_hands/f_hands_white",
	"models/all_scp_models/shared/heads/female/head_1",
	"models/all_scp_models/cultists/vrancis_head",
	"models/all_scp_models/cultists/footmale",
	"models/all_scp_models/sci/shirt_boss",
	"models/all_scp_models/sci/dispatch/dispatch_head",
	"models/all_scp_models/sci/dispatch/dispatch_face",
	"models/all_scp_models/sci/dispatch/skirt",
	"models/all_scp_models/special_sci/special_4/head_sci_4",
	"models/all_scp_models/special_sci/special_4/face_sci_4",
	"models/all_scp_models/special_sci/sci_3_materials/sci_3_head",
	"models/all_scp_models/special_sci/sci_3_materials/sci_3_face",
	"models/all_scp_models/special_sci/arms",
	"models/all_scp_models/special_sci/tex_0160_0",
	"models/all_scp_models/special_sci/sci_2_materials/sci_2_face",
	"models/all_scp_models/special_sci/sci_2_materials/sci_2_head",
	"models/all_scp_models/special_sci/special_1/face_sci_1",
	"models/all_scp_models/special_sci/special_1/head_sci_1",
	"models/all_scp_models/special_sci/sci_7_materials/sci_7_face",
	"models/all_scp_models/special_sci/sci_7_materials/sci_7_head",
	"models/all_scp_models/special_sci/sci_9_materials/sci_9_face",
	"models/all_scp_models/special_sci/sci_9_materials/sci_9_head",
	"models/all_scp_models/special_sci/mutantskin_diff",
	"models/all_scp_models/special_sci/zed_hans_d",
	"models/all_scp_models/special_sci/spes_head"
}