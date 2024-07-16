--[[


addons/[weapons]_no_260_kk_ins2/lua/weapons/cw_kk_ins2_doi_fg42/sh_soundscript.lua

--]]


SWEP.Sounds = {
	base_draw = {
		{time = 0/31, sound = "CW_KK_INS2_UNIVERSAL_DRAW"},
	},

	base_holster = {
		{time = 0/34, sound = "CW_KK_INS2_UNIVERSAL_HOLSTER"},
	},

	base_crawl = {
		{time = 0/30, sound = "CW_KK_INS2_UNIVERSAL_LEFTCRAWL"},
		{time = 22/30, sound = "CW_KK_INS2_UNIVERSAL_RIGHTCRAWL"},
	},

	base_dryfire = {
		{time = 0/30, sound = "CW_KK_INS2_DOI_FG42_EMPTY"},
	},

	base_fireselect = {
		{time = 11/30, sound = "CW_KK_INS2_DOI_FG42_FIRESELECT"},
	},

	base_melee = {
		{time = 1/30, sound = "CW_KK_INS2_DOI_MELEE"},
	},

	base_melee_end = {
		{time = 1/30, sound = "CW_KK_INS2_DOI_MELEE"},
	},

	base_melee_bash = {
		{time = 6/31, sound = "CW_KK_INS2_DOI_MELEE"},
	},

	base_reload = {
		{time = 35/33.1, sound = "CW_KK_INS2_DOI_FG42_MAGRELEASE"},
		{time = 40/33.1, sound = "CW_KK_INS2_DOI_FG42_MAGOUT"},
		{time = 50/33.1, sound = "CW_KK_INS2_DOI_FG42_FETCHMAG"},
		{time = 107/33.1, sound = "CW_KK_INS2_DOI_FG42_MAGIN"},
		{time = 117/33.1, sound = "CW_KK_INS2_DOI_FG42_MAGHIT"},
		// { event 46 118 ""},
		{time = 142/33.1, sound = "CW_KK_INS2_DOI_FG42_RATTLE"},
	},

	base_reloadempty = {
		{time = 30/33.1, sound = "CW_KK_INS2_DOI_FG42_BOLTBACK"},
		{time = 88/33.1, sound = "CW_KK_INS2_DOI_FG42_MAGRELEASE"},
		{time = 93/33.1, sound = "CW_KK_INS2_DOI_FG42_MAGOUT"},
		{time = 103/33.1, sound = "CW_KK_INS2_DOI_FG42_FETCHMAG"},
		{time = 160/33.1, sound = "CW_KK_INS2_DOI_FG42_MAGIN"},
		{time = 173/33.1, sound = "CW_KK_INS2_DOI_FG42_MAGHIT"},
		// { event 46 174 ""},
		{time = 199/33.1, sound = "CW_KK_INS2_DOI_FG42_RATTLE"},
	},

	iron_dryfire = {
		{time = 0/30, sound = "CW_KK_INS2_DOI_FG42_EMPTY"},
	},

	iron_fireselect = {
		{time = 8/30, sound = "CW_KK_INS2_DOI_FG42_FIRESELECT"},
	},

	deployed_in = {
		{time = 20/36, sound = "CW_KK_INS2_UNIVERSAL_BIPOD_DEPLOYSTART"},
		{time = 28/36, sound = "CW_KK_INS2_UNIVERSAL_BIPOD_DEPLOYEND"},
	},

	deployed_out = {
		{time = 30/36, sound = "CW_KK_INS2_UNIVERSAL_BIPOD_RETRACT"},
	},

	deployed_dryfire = {
		{time = 0/30, sound = "CW_KK_INS2_DOI_FG42_EMPTY"},
	},

	deployed_fireselect = {
		{time = 13/30, sound = "CW_KK_INS2_DOI_FG42_FIRESELECT"},
	},

	deployed_reload = {
		{time = 35/33.1, sound = "CW_KK_INS2_DOI_FG42_MAGRELEASE"},
		{time = 40/33.1, sound = "CW_KK_INS2_DOI_FG42_MAGOUT"},
		{time = 50/33.1, sound = "CW_KK_INS2_DOI_FG42_FETCHMAG"},
		{time = 98/33.1, sound = "CW_KK_INS2_DOI_FG42_MAGIN"},
		{time = 110/33.1, sound = "CW_KK_INS2_DOI_FG42_MAGHIT"},
		// { event 46 112 ""},
	},

	deployed_reload_empty = {
		{time = 30/33.1, sound = "CW_KK_INS2_DOI_FG42_BOLTBACK"},
		{time = 88/33.1, sound = "CW_KK_INS2_DOI_FG42_MAGRELEASE"},
		{time = 93/33.1, sound = "CW_KK_INS2_DOI_FG42_MAGOUT"},
		{time = 103/33.1, sound = "CW_KK_INS2_DOI_FG42_FETCHMAG"},
		{time = 150/33.1, sound = "CW_KK_INS2_DOI_FG42_MAGIN"},
		{time = 166/33.1, sound = "CW_KK_INS2_DOI_FG42_MAGHIT"},
		// { event 46 168 ""},
	},

	deployed_iron_dryfire = {
		{time = 0/30, sound = "CW_KK_INS2_DOI_FG42_EMPTY"},
	},

	deployed_iron_fireselect = {
		{time = 13/30, sound = "CW_KK_INS2_DOI_FG42_FIRESELECT"},
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
		{time = 11/30, sound = "CW_KK_INS2_DOI_FG42_FIRESELECT"},
	},

	base_melee_empty = {
		{time = 1/30, sound = "CW_KK_INS2_DOI_MELEE"},
	},

	base_melee_end_empty = {
		{time = 1/30, sound = "CW_KK_INS2_DOI_MELEE"},
	},

	base_melee_bash_empty = {
		{time = 6/31, sound = "CW_KK_INS2_DOI_MELEE"},
	},

	iron_fireselect_empty = {
		{time = 11/30, sound = "CW_KK_INS2_DOI_FG42_FIRESELECT"},
	},

	deployed_in_empty = {
		{time = 20/36, sound = "CW_KK_INS2_UNIVERSAL_BIPOD_DEPLOYSTART"},
		{time = 28/36, sound = "CW_KK_INS2_UNIVERSAL_BIPOD_DEPLOYEND"},
	},

	deployed_out_empty = {
		{time = 30/36, sound = "CW_KK_INS2_UNIVERSAL_BIPOD_RETRACT"},
	},

	deployed_iron_fireselect_empty = {
		{time = 13/30, sound = "CW_KK_INS2_DOI_FG42_FIRESELECT"},
	},
}
