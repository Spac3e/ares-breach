--[[


addons/[weapons]_no_260_kk_ins2/lua/weapons/cw_kk_ins2_nam_mat49/sh_soundscript.lua

--]]


SWEP.Sounds = {
	base_ready = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_DRAW"},
		{time = 21/30, sound = "CW_KK_INS2_MP40_BOLTUNLOCK"},
		{time = 53/30, sound = "CW_KK_INS2_MP40_BOLTLOCK"},
		{time = 63/30, sound = "CW_KK_INS2_UNIVERSAL_LEANIN"},
	},

	base_draw = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_DRAW"},
	},

	base_holster = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_HOLSTER"},
	},

	base_crawl = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_LEFTCRAWL"},
		{time = 22/30, sound = "CW_KK_INS2_UNIVERSAL_RIGHTCRAWL"},
	},

	base_dryfire = {
		{time = 0, sound = "CW_KK_INS2_MP40_EMPTY"},
	},

	base_reload = {
		{time = 18/30, sound = "CW_KK_INS2_MP40_MAGRELEASE"},
		{time = 33/30, sound = "CW_KK_INS2_MP40_MAGOUT"},
		{time = 77/30, sound = "CW_KK_INS2_MP40_MAGIN"},
		{time = 84/30, sound = "CW_KK_INS2_MP40_MAGHIT"},
		// { event 46 84 ""},
	},

	base_reloadempty = {
		{time = 18/30, sound = "CW_KK_INS2_MP40_MAGRELEASE"},
		{time = 33/30, sound = "CW_KK_INS2_MP40_MAGOUT"},
		{time = 77/30, sound = "CW_KK_INS2_MP40_MAGIN"},
		{time = 84/30, sound = "CW_KK_INS2_MP40_MAGHIT"},
		// { event 46 109 ""},
		{time = 110/30, sound = "CW_KK_INS2_MP40_BOLTBACK"},
	},

	empty_draw = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_DRAW"},
	},

	empty_holster = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_HOLSTER"},
	},

	empty_crawl = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_LEFTCRAWL"},
		{time = 22/30, sound = "CW_KK_INS2_UNIVERSAL_RIGHTCRAWL"},
	},

	iron_dryfire = {
		{time = 0, sound = "CW_KK_INS2_MP40_EMPTY"},
	},
}
