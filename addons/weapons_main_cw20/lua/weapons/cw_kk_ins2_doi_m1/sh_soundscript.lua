--[[


addons/[weapons]_no_260_kk_ins2/lua/weapons/cw_kk_ins2_doi_m1/sh_soundscript.lua

--]]


SWEP.Sounds = {
	base_ready = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_DRAW"},
		{time = 20/30, sound = "CW_KK_INS2_DOI_M1_BOLTBACK"},
		{time = 31/30, sound = "CW_KK_INS2_DOI_M1_BOLTRELEASE"},
	},

	base_draw = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_DRAW"},
	},

	base_holster = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_HOLSTER"},
	},

	base_crawl = {
		{time = 0/30, sound = "CW_KK_INS2_UNIVERSAL_LEFTCRAWL"},
		{time = 22/30, sound = "CW_KK_INS2_UNIVERSAL_RIGHTCRAWL"},
	},

	base_dryfire = {
		{time = 0, sound = "CW_KK_INS2_DOI_M1_EMPTY"},
	},

	base_reload = {
		{time = 18/35, sound = "CW_KK_INS2_DOI_M1_MAGRELEASE"},
		{time = 24/35, sound = "CW_KK_INS2_DOI_M1_MAGOUT"},
		{time = 71/35, sound = "CW_KK_INS2_DOI_M1_MAGIN"},
		-- { event 46 72 ""},
	},

	base_reloadempty = {
		{time = 18/35, sound = "CW_KK_INS2_DOI_M1_MAGRELEASE"},
		{time = 24/35, sound = "CW_KK_INS2_DOI_M1_MAGOUT"},
		{time = 78/35, sound = "CW_KK_INS2_DOI_M1_MAGIN"},
		-- { event 46 79 ""},
		{time = 123/35, sound = "CW_KK_INS2_DOI_M1_BOLTBACK"},
		{time = 131/35, sound = "CW_KK_INS2_DOI_M1_BOLTRELEASE"},
	},

	base_reload_ext = {
		{time = 18/35, sound = "CW_KK_INS2_DOI_M1_MAGRELEASE"},
		{time = 24/35, sound = "CW_KK_INS2_DOI_M1_MAGOUT"},
		{time = 71/35, sound = "CW_KK_INS2_DOI_M1_MAGIN"},
		-- { event 46 72 ""},
	},

	base_reloadempty_ext = {
		{time = 18/35, sound = "CW_KK_INS2_DOI_M1_MAGRELEASE"},
		{time = 24/35, sound = "CW_KK_INS2_DOI_M1_MAGOUT"},
		{time = 78/35, sound = "CW_KK_INS2_DOI_M1_MAGIN"},
		-- { event 46 79 ""},
		{time = 123/35, sound = "CW_KK_INS2_DOI_M1_BOLTBACK"},
		{time = 131/35, sound = "CW_KK_INS2_DOI_M1_BOLTRELEASE"},
	},

	iron_dryfire = {
		{time = 0, sound = "CW_KK_INS2_DOI_M1_EMPTY"},
	},

	base_melee_bash = {
		{time = 6/31, sound = "CW_KK_INS2_DOI_MELEE"},
	},

	base_melee = {
		{time = 1/30, sound = "CW_KK_INS2_DOI_MELEE"},
	},

	base_melee_end = {
		{time = 1/30, sound = "CW_KK_INS2_DOI_MELEE"},
	},
}
