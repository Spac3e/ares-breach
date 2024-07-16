--[[


addons/[weapons]_no_260_kk_ins2/lua/weapons/cw_kk_ins2_doi_stg44/sh_soundscript.lua

--]]


SWEP.Sounds = {
	base_ready = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_DRAW"},
		{time = 24/32, sound = "CW_KK_INS2_DOI_STG44_BOLTBACK"},
		{time = 35/32, sound = "CW_KK_INS2_DOI_STG44_BOLTRELEASE"},
		{time = 55/32, sound = "CW_KK_INS2_UNIVERSAL_LEANIN"},
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
		{time = 0, sound = "CW_KK_INS2_DOI_STG44_EMPTY"},
	},

	base_fireselect = {
		{time = 11/30, sound = "CW_KK_INS2_DOI_STG44_FIRESELECT"},
	},

	base_reload = {
		{time = 15/30, sound = "CW_KK_INS2_DOI_STG44_MAGRELEASE"},
		{time = 18/30, sound = "CW_KK_INS2_DOI_STG44_MAGOUT"},
		{time = 62/30, sound = "CW_KK_INS2_DOI_STG44_MAGIN"},
		// reload time = 64 ""},
	},

	base_reloadempty = {
		{time = 22/31.8, sound = "CW_KK_INS2_DOI_STG44_MAGRELEASE"},
		{time = 24/31.8, sound = "CW_KK_INS2_DOI_STG44_MAGOUT"},
		{time = 74/31.8, sound = "CW_KK_INS2_DOI_STG44_MAGIN"},
		// reload time = 76 ""},
		{time = 108/31.8, sound = "CW_KK_INS2_DOI_STG44_BOLTBACK"},
		{time = 118/31.8, sound = "CW_KK_INS2_DOI_STG44_BOLTRELEASE"},
	},

	iron_dryfire = {
		{time = 0, sound = "CW_KK_INS2_DOI_STG44_EMPTY"},
	},

	iron_fireselect = {
		{time = 8/30, sound = "CW_KK_INS2_DOI_STG44_FIRESELECT"},
	},

	base_melee_bash = {
		{time = 6/31, sound = "CW_KK_INS2_DOI_MELEE"},
	},
}
