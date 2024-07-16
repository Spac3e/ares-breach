--[[


addons/[weapons]_no_260_kk_ins2/lua/weapons/cw_kk_ins2_nam_m72/sh_soundscript.lua

--]]


SWEP.Sounds = {
	base_crawl = {
		{time = 15/30, sound = "CW_KK_INS2_UNIVERSAL_RIGHTCRAWL"},
		{time = 38/30, sound = "CW_KK_INS2_UNIVERSAL_LEFTCRAWL"},
	},

	base_fire = {
		// { event AE_MUZZLEFLASH 0 "AT4 MUZZLE"},
		// { event RPG_EMIT_EVENT 10 ""},
		{time = 3/30, sound = "CW_KK_INS2_M9_SAFETY"},
	},

	base_iron_fire = {
		// { event AE_MUZZLEFLASH 0 "AT4 MUZZLE"},
		// { event RPG_EMIT_EVENT 10 ""},
		{time = 3/30, sound = "CW_KK_INS2_M9_SAFETY"},
	},

	base_draw = {
		{time = 0/30, sound = "CW_KK_INS2_UNIVERSAL_DRAW"},
	},

	base_holster = {
		{time = 0/30, sound = "CW_KK_INS2_UNIVERSAL_HOLSTER"},
	},

	base_ready = {
		{time = 0/31, sound = "CW_KK_INS2_UNIVERSAL_DRAW"},
		{time = 35/31, sound = "CW_KK_INS2_AT4_LATCH02"},
		{time = 46/31, sound = "CW_KK_INS2_AT4_READY"},
		{time = 66/31, sound = "CW_KK_INS2_AT4_LATCH01"},
		{time = 76/31, sound = "CW_KK_INS2_AT4_SHOULDER"},
		{time = 90/31, sound = "CW_KK_INS2_AT4_LATCH02"},
	},

	base_toss = {
		{time = 0/31, sound = "CW_KK_INS2_UNIVERSAL_LEANOUT"},
		{time = 21/31, sound = "CW_KK_INS2_UNIVERSAL_WEAPONLOWER"},
	},
}
