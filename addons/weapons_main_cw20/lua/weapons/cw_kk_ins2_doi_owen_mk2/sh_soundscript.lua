--[[


addons/[weapons]_no_260_kk_ins2/lua/weapons/cw_kk_ins2_doi_owen_mk2/sh_soundscript.lua

--]]


SWEP.Sounds = {
	base_ready = {
		{time = 0/30, sound = "CW_KK_INS2_UNIVERSAL_DRAW"},
		{time = 22/30, sound = "CW_KK_INS2_DOI_OWEN_BOLTBACK"},
		{time = 46/30, sound = "CW_KK_INS2_DOI_OWEN_RATTLE"},
	},

	base_draw = {
		{time = 0/30, sound = "CW_KK_INS2_UNIVERSAL_DRAW"},
	},

	base_holster = {
		{time = 0/30, sound = "CW_KK_INS2_UNIVERSAL_HOLSTER"},
	},

	base_crawl = {
		{time = 0/30, sound = "CW_KK_INS2_UNIVERSAL_LEFTCRAWL"},
		{time = 22/30, sound = "CW_KK_INS2_UNIVERSAL_RIGHTCRAWL"},
	},

	base_dryfire = {
		{time = 0/30, sound = "CW_KK_INS2_DOI_OWEN_EMPTY"},
	},

	base_fireselect = {
		{time = 11/30, sound = "CW_KK_INS2_DOI_OWEN_FIRESELECT"},
	},

	iron_fireselect = {
		{time = 11/30, sound = "CW_KK_INS2_DOI_OWEN_FIRESELECT"},
	},

	base_reload = {
		{time = 25/31.5, sound = "CW_KK_INS2_DOI_OWEN_MAGRELEASE"},
		{time = 29/31.5, sound = "CW_KK_INS2_DOI_OWEN_MAGOUT"},
		{time = 33/31.5, sound = "CW_KK_INS2_DOI_OWEN_FETCHMAG"},
		{time = 81/31.5, sound = "CW_KK_INS2_DOI_OWEN_MAGIN"},
		// { event 46 85 ""},
		{time = 110/31.5, sound = "CW_KK_INS2_DOI_OWEN_RATTLE"},
	},

	base_reload_empty = {
		{time = 25/31.5, sound = "CW_KK_INS2_DOI_OWEN_MAGRELEASE"},
		{time = 29/31.5, sound = "CW_KK_INS2_DOI_OWEN_MAGOUT"},
		{time = 33/31.5, sound = "CW_KK_INS2_DOI_OWEN_FETCHMAG"},
		{time = 81/31.5, sound = "CW_KK_INS2_DOI_OWEN_MAGIN"},
		// { event 46 85 ""},
		{time = 114/31.5, sound = "CW_KK_INS2_DOI_OWEN_BOLTBACK"},
		{time = 143/31.5, sound = "CW_KK_INS2_DOI_OWEN_RATTLE"},
	},

	base_melee_bash = {
		{time = 6/31, sound = "CW_KK_INS2_DOI_MELEE"},
		// { event 1338 9 ""},
		// { event AE_WPN_READY 26 ""},
	},

	iron_dryfire = {
		{time = 0/30, sound = "CW_KK_INS2_DOI_OWEN_EMPTY"},
	},

	base_draw_empty = {
		{time = 0/30, sound = "CW_KK_INS2_UNIVERSAL_DRAW"},
	},

	base_holster_empty = {
		{time = 0/30, sound = "CW_KK_INS2_UNIVERSAL_HOLSTER"},
	},

	base_crawl_empty = {
		{time = 0/30, sound = "CW_KK_INS2_UNIVERSAL_LEFTCRAWL"},
		{time = 22/30, sound = "CW_KK_INS2_UNIVERSAL_RIGHTCRAWL"},
	},

	base_fireselect_empty = {
		{time = 11/30, sound = "CW_KK_INS2_DOI_OWEN_FIRESELECT"},
	},

	iron_fireselect_empty = {
		{time = 11/30, sound = "CW_KK_INS2_DOI_OWEN_FIRESELECT"},
	},

	base_melee_empty = {
		{time = 1/30, sound = "CW_KK_INS2_DOI_MELEE"},
	},

	base_melee_bash_empty = {
		{time = 6/31, sound = "CW_KK_INS2_DOI_MELEE"},
		// { event 1338 9 ""},
		// { event AE_WPN_READY 26 ""},
	},
}
