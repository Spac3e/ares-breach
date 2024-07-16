--[[


addons/[weapons]_no_260_kk_ins2/lua/weapons/cw_kk_ins2_nam_mac10/sh_soundscript.lua

--]]


SWEP.Sounds = {
	base_ready = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_DRAW"},
		{time = 13/30, sound = "CW_KK_INS2_M4A1_HIT"},
		{time = 27/30, sound = "CW_KK_INS2_M1A1_BOLTBACK"},
		{time = 35/30, sound = "CW_KK_INS2_AKM_MAGOUTRATTLE"},
	},

	base_draw = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_DRAW"},
	},

	base_holster = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_HOLSTER"},
	},

	base_crawl = {
		{time = 14/30, sound = "CW_KK_INS2_UNIVERSAL_RIGHTCRAWL"},
		{time = 38/30, sound = "CW_KK_INS2_UNIVERSAL_LEFTCRAWL"},
	},

	base_dryfire = {
		{time = 0, sound = "CW_KK_INS2_MP40_EMPTY"},
	},

	base_fireselect = {
		{time = 6/30, sound = "CW_KK_INS2_MP5K_FIRESELECT"},
	},

	base_reload = {
		{time = 17/30, sound = "CW_KK_INS2_MP40_MAGRELEASE"},
		{time = 23/30, sound = "CW_KK_INS2_MP40_MAGOUT"},
		{time = 69/30, sound = "CW_KK_INS2_MP40_MAGIN"},
		{time = 76/30, sound = "CW_KK_INS2_MP40_MAGHIT"},
		// { event 46 76 ""},
		{time = 95/30, sound = "CW_KK_INS2_AKM_MAGOUTRATTLE"},
	},

	base_reloadempty = {
		{time = 28/30, sound = "CW_KK_INS2_MP40_BOLTBACK"},
		{time = 31/30, sound = "CW_KK_INS2_MP40_BOLTLOCK"},
		{time = 36/30, sound = "CW_KK_INS2_MP40_BOLTUNLOCK"},
		{time = 61/30, sound = "CW_KK_INS2_MP40_MAGRELEASE"},
		{time = 69/30, sound = "CW_KK_INS2_MP40_MAGOUT"},
		{time = 120/30, sound = "CW_KK_INS2_MP40_MAGIN"},
		{time = 129/30, sound = "CW_KK_INS2_MP40_MAGHIT"},
		// { event 46 129 ""},
		{time = 150/30, sound = "CW_KK_INS2_AKM_MAGOUTRATTLE"},
	},

	iron_dryfire = {
		{time = 0, sound = "CW_KK_INS2_MP40_EMPTY"},
	},

	iron_fireselect = {
		{time = 6/30, sound = "CW_KK_INS2_MP5K_FIRESELECT"},
	},
}
