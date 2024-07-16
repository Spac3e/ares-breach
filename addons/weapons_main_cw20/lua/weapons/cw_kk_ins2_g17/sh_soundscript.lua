--[[


addons/[weapons]_no_260_kk_ins2/lua/weapons/cw_kk_ins2_g17/sh_soundscript.lua

--]]


SWEP.Sounds = {
	base_ready = {
		{time = 0/30, sound = "CW_KK_INS2_UNIVERSAL_PISTOL_DRAW"},
		{time = 4/30, sound = "CW_KK_INS2_M9_SAFETY"},
		{time = 9/30, sound = "CW_KK_INS2_M9_BOLTBACK"},
		{time = 19/30, sound = "CW_KK_INS2_M9_BOLTRELEASE"},
	},

	base_draw = {
		{time = 0/30, sound = "CW_KK_INS2_UNIVERSAL_PISTOL_DRAW"},
	},

	base_holster = {
		{time = 0/30, sound = "CW_KK_INS2_UNIVERSAL_PISTOL_HOLSTER"},
	},

	base_dryfire = {
		{time = 0/30, sound = "CW_KK_INS2_M9_EMPTY"},
	},

	base_reload = {
		{time = 0/30, sound = "CW_KK_INS2_M9_MAGRELEASE"},
		{time = 16/30, sound = "CW_KK_INS2_M9_MAGOUT"},
		{time = 48/30, sound = "CW_KK_INS2_M9_MAGIN"},
		{time = 54/30, sound = "CW_KK_INS2_M9_MAGHIT"},
	},

	base_reloadempty = {
		{time = 0/30, sound = "CW_KK_INS2_M9_MAGRELEASE"},
		{time = 10/30, sound = "CW_KK_INS2_M9_MAGOUT"},
		{time = 40/30, sound = "CW_KK_INS2_M9_MAGIN"},
		{time = 46/30, sound = "CW_KK_INS2_M9_MAGHIT"},
		{time = 65/30, sound = "CW_KK_INS2_M9_BOLTRELEASE"},
	},

	empty_draw = {
		{time = 0/30, sound = "CW_KK_INS2_UNIVERSAL_PISTOL_DRAW"},
	},

	empty_holster = {
		{time = 0/30, sound = "CW_KK_INS2_UNIVERSAL_PISTOL_HOLSTER"},
	},

	iron_dryfire = {
		{time = 0/30, sound = "CW_KK_INS2_M9_EMPTY"},
	},

	base_crawl = {
		{time = 0/35, sound = "CW_KK_INS2_UNIVERSAL_LEFTCRAWL"},
		{time = 22/35, sound = "CW_KK_INS2_UNIVERSAL_RIGHTCRAWL"},
	},

	empty_crawl = {
		{time = 0/35, sound = "CW_KK_INS2_UNIVERSAL_LEFTCRAWL"},
		{time = 22/35, sound = "CW_KK_INS2_UNIVERSAL_RIGHTCRAWL"},
	},
}
