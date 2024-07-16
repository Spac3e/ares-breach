--[[


addons/[weapons]_no_260_kk_ins2/lua/weapons/cw_kk_ins2_nam_vz58/sh_soundscript.lua

--]]


SWEP.Sounds = {
	base_ready = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_DRAW"},
		{time = 20/30, sound = "CW_KK_INS2_AK74_FIRESELECT"},
		{time = 42/30, sound = "CW_KK_INS2_AK74_BOLTBACK"},
		{time = 52/30, sound = "CW_KK_INS2_AK74_BOLTRELEASE"},
	},

	base_draw = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_DRAW"},
		{time = 12/31, sound = "CW_KK_INS2_AK74_FIRESELECT"},
	},

	base_holster = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_HOLSTER"},
		{time = 12/30, sound = "CW_KK_INS2_AK74_FIRESELECT"},
	},

	base_crawl = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_LEFTCRAWL"},
		{time = 22/30, sound = "CW_KK_INS2_UNIVERSAL_RIGHTCRAWL"},
	},

	base_dryfire = {
		{time = 0, sound = "CW_KK_INS2_AK74_EMPTY"},
	},

	base_fireselect = {
		{time = 12/30, sound = "CW_KK_INS2_AK74_FIRESELECT"},
	},

	base_fireselect_empty = {
		{time = 12/30, sound = "CW_KK_INS2_AK74_FIRESELECT"},
	},

	base_reload = {
		{time = 16/30, sound = "CW_KK_INS2_AK74_MAGRELEASE"},
		{time = 22/30, sound = "CW_KK_INS2_AK74_MAGOUT"},
		{time = 85/30, sound = "CW_KK_INS2_AK74_MAGIN"},
		// { event 46 68 ""},
	},

	base_reloadempty = {
		{time = 16/30, sound = "CW_KK_INS2_AK74_MAGRELEASE"},
		{time = 22/30, sound = "CW_KK_INS2_AK74_MAGOUT"},
		{time = 84/30, sound = "CW_KK_INS2_AK74_MAGIN"},
		// { event 46 124 ""},
		{time = 119/30, sound = "CW_KK_INS2_AK74_BOLTRELEASE"},
	},

	empty_draw = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_DRAW"},
		{time = 12/31, sound = "CW_KK_INS2_AK74_FIRESELECT"},
	},

	empty_holster = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_HOLSTER"},
		{time = 12/31, sound = "CW_KK_INS2_AK74_FIRESELECT"},
	},

	empty_crawl = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_LEFTCRAWL"},
		{time = 22/30, sound = "CW_KK_INS2_UNIVERSAL_RIGHTCRAWL"},
	},

	iron_dryfire = {
		{time = 0, sound = "CW_KK_INS2_AK74_EMPTY"},
	},

	iron_fireselect = {
		{time = 12/30, sound = "CW_KK_INS2_AK74_FIRESELECT"},
	},

	iron_fireselect_empty = {
		{time = 10/30, sound = "CW_KK_INS2_AK74_FIRESELECT"},
	},
}
