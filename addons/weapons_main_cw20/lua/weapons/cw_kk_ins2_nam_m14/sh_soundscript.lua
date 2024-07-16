--[[


addons/[weapons]_no_260_kk_ins2/lua/weapons/cw_kk_ins2_nam_m14/sh_soundscript.lua

--]]


SWEP.Sounds = {
	base_ready = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_DRAW"},
		{time = 26/30, sound = "CW_KK_INS2_M14_BOLTBACK"},
		{time = 31/30, sound = "CW_KK_INS2_M14_BOLTRELEASE"},
	},

	base_draw = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_DRAW"},
	},

	base_draw_empty = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_DRAW"},
	},

	base_holster = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_HOLSTER"},
	},

	base_holster_empty = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_HOLSTER"},
	},

	base_crawl = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_LEFTCRAWL"},
		{time = 22/30, sound = "CW_KK_INS2_UNIVERSAL_RIGHTCRAWL"},
	},

	base_crawl_empty = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_LEFTCRAWL"},
		{time = 22/30, sound = "CW_KK_INS2_UNIVERSAL_RIGHTCRAWL"},
	},

	base_dryfire = {
		{time = 0, sound = "CW_KK_INS2_M14_EMPTY"},
	},

	base_fireselect = {
		{time = 10/30, sound = "CW_KK_INS2_M14_FIRESELECT"},
	},

	base_fireselect_empty = {
		{time = 10/30, sound = "CW_KK_INS2_M14_FIRESELECT"},
	},

	base_reload = {
		{time = 19/30, sound = "CW_KK_INS2_M14_MAGRELEASE"},
		{time = 22/30, sound = "CW_KK_INS2_M14_MAGOUT"},
		{time = 66/30, sound = "CW_KK_INS2_M14_MAGIN"},
		// { event 46 78 ""},
	},

	base_reloadempty = {
		{time = 19/30, sound = "CW_KK_INS2_M14_MAGRELEASE"},
		{time = 22/30, sound = "CW_KK_INS2_M14_MAGOUT"},
		{time = 66/30, sound = "CW_KK_INS2_M14_MAGIN"},
		{time = 108/30, sound = "CW_KK_INS2_M14_BOLTBACK"},
		{time = 113/30, sound = "CW_KK_INS2_M14_BOLTRELEASE"},
		// { event 46 112 ""},
	},

	iron_dryfire = {
		{time = 0, sound = "CW_KK_INS2_M14_EMPTY"},
	},

	iron_fireselect = {
		{time = 10/30, sound = "CW_KK_INS2_M14_FIRESELECT"},
	},

	iron_fireselect_empty = {
		{time = 10/30, sound = "CW_KK_INS2_M14_FIRESELECT"},
	},
}
