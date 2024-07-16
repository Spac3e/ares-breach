--[[


addons/[weapons]_no_260_kk_ins2/lua/weapons/cw_kk_ins2_ao5_m79/sh_soundscript.lua

--]]

--[[
lua/weapons/cw_kk_ins2_ao5_m79/sh_soundscript.lua
--]]

local function shell(wep)
	if SERVER then return end

	if !IsValid(wep) then return end

	wep:shellEventReload()
end

SWEP.Sounds = {
	base_ready = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_DRAW"},
		{time = 17/30, sound = "CW_KK_INS2_M203_CLOSEBARREL"},
	},

	base_draw = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_DRAW"},
	},

	base_holster = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_HOLSTER"},
	},

	base_crawl = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_LEFTCRAWL"},
		{time = 22/35, sound = "CW_KK_INS2_UNIVERSAL_RIGHTCRAWL"},
	},

	base_dryfire = {
		{time = 0, sound = "CW_KK_INS2_P2A1_EMPTY"},
	},

	base_reload = {
		{time = 9/30, sound = "CW_KK_INS2_P2A1_OPENBARREL"},
		{time = 40/30, sound = "CW_KK_INS2_P2A1_REMOVEFLARE"},
		{time = 45/30, sound = "CW_KK_INS2_m203_GrenadeDrop", callback = shell},
		-- {time = 62/30, sound = "CW_KK_INS2_m203_GrenadeDrop"},
		{time = 92/30, sound = "CW_KK_INS2_P2A1_INSERTFLARESTART"},
		{time = 94/30, sound = "CW_KK_INS2_M203_INSERTGRENADE"},
		{time = 133/30, sound = "CW_KK_INS2_M203_CLOSEBARREL"},
	},

	empty_draw = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_DRAW"},
	},

	empty_holster = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_HOLSTER"},
	},

	empty_crawl = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_LEFTCRAWL"},
		{time = 22/35, sound = "CW_KK_INS2_UNIVERSAL_RIGHTCRAWL"},
	},

	iron_dryfire = {
		{time = 0, sound = "CW_KK_INS2_P2A1_EMPTY"},
	},
}


