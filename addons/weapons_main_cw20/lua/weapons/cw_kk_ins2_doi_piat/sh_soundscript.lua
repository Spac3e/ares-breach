--[[


addons/[weapons]_no_260_kk_ins2/lua/weapons/cw_kk_ins2_doi_piat/sh_soundscript.lua

--]]


SWEP.Sounds = {
	base_ready = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_DRAW"},
	},

	base_draw = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_DRAW"},
	},

	empty_draw = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_DRAW"},
	},

	base_holster = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_HOLSTER"},
	},

	empty_holster = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_HOLSTER"},
	},

	base_crawl = {
		{time = 0/32, sound = "CW_KK_INS2_UNIVERSAL_RIGHTCRAWL"},
		{time = 13/32, sound = "CW_KK_INS2_UNIVERSAL_LEFTCRAWL"},
	},

	empty_crawl = {
		{time = 0/32, sound = "CW_KK_INS2_UNIVERSAL_RIGHTCRAWL"},
		{time = 13/32, sound = "CW_KK_INS2_UNIVERSAL_LEFTCRAWL"},
	},

	base_dryfire = {
		{time = 0, sound = "CW_KK_INS2_DOI_PIAT_EMPTY"},
	},

	base_reload = {
		{time = 10/32.5, sound = "CW_KK_INS2_DOI_PIAT_FETCH"},
		{time = 66/32.5, sound = "CW_KK_INS2_DOI_PIAT_LOAD1"},
		{time = 84/32.5, sound = "CW_KK_INS2_DOI_PIAT_LOAD2"},
		{time = 112/32.5, sound = "CW_KK_INS2_DOI_PIAT_ENDGRAB"},
		{time = 125/32.5, sound = "CW_KK_INS2_DOI_PIAT_SHOULDER"},
		-- { event 46 87 ""},
	},

	iron_dryfire = {
		{time = 1/30, sound = "CW_KK_INS2_DOI_PIAT_EMPTY"},
	},

	iron_dryfire_preblend = {
		{time = 1/30, sound = "CW_KK_INS2_DOI_PIAT_EMPTY"},
	},

	base_melee = {
		{time = 5/31, sound = "CW_KK_INS2_DOI_MELEE"},
	},

	empty_melee = {
		{time = 5/31, sound = "CW_KK_INS2_DOI_MELEE"},
	},
}
