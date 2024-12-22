--[[


addons/[weapons]_no_260_kk_ins2/lua/weapons/cw_kk_ins2_doi_g43/sh_soundscript.lua

--]]


SWEP.Sounds = {
	base_ready = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_DRAW"},
		{time = 24/30, sound = "CW_KK_INS2_DOI_G43_BOLTRELEASE"},
		{time = 41/30, sound = "CW_KK_INS2_UNIVERSAL_LEANIN"},
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
		{time = 0, sound = "CW_KK_INS2_DOI_G43_EMPTY"},
	},

	base_reloadfull = {
		{time = 14/32, sound = "CW_KK_INS2_DOI_G43_MAGRELEASE"},
		{time = 24/32, sound = "CW_KK_INS2_DOI_G43_MAGOUT"},
		{time = 30/32, sound = "CW_KK_INS2_DOI_G43_FETCHMAG"},
		{time = 79/32, sound = "CW_KK_INS2_DOI_G43_MAGIN"},
		// reload time = 80 ""},
		{time = 98/32, sound = "CW_KK_INS2_DOI_G43_RATTLE"},
	},

	-- base_reloadempty = {
		-- {time = 14/31, sound = "CW_KK_INS2_DOI_G43_MAGRELEASE"},
		-- {time = 24/31, sound = "CW_KK_INS2_DOI_G43_MAGOUT"},
		-- {time = 30/31, sound = "CW_KK_INS2_DOI_G43_FETCHMAG"},
		-- {time = 79/31, sound = "CW_KK_INS2_DOI_G43_MAGIN"},
		-- // reload time = 80 ""},
		-- {time = 108/31, sound = "CW_KK_INS2_DOI_G43_BOLTRELEASE"},
		-- {time = 127/31, sound = "CW_KK_INS2_DOI_G43_RATTLE"},
	-- },

	base_reloadempty = {
		{time = 20/31, sound = "CW_KK_INS2_DOI_G43_MAGRELEASE"},
		{time = 24/31, sound = "CW_KK_INS2_DOI_G43_MAGOUT"},
		{time = 30/31, sound = "CW_KK_INS2_DOI_G43_FETCHMAG"},
		{time = 78/31, sound = "CW_KK_INS2_DOI_G43_MAGIN"},
		// reload time = 80 ""},
		{time = 110/31, sound = "CW_KK_INS2_DOI_G43_BOLTBACK"},
		{time = 122/31, sound = "CW_KK_INS2_DOI_G43_BOLTRELEASE"},
		{time = 141/31, sound = "CW_KK_INS2_DOI_G43_RATTLE"},
	},

	iron_dryfire = {
		{time = 0, sound = "CW_KK_INS2_DOI_G43_EMPTY"},
	},

	base_draw_empty = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_DRAW"},
	},

	base_holster_empty = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_HOLSTER"},
	},

	base_crawl_empty = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_LEFTCRAWL"},
		{time = 22/30, sound = "CW_KK_INS2_UNIVERSAL_RIGHTCRAWL"},
	},

	base_melee_bash = {
		{time = 6/31, sound = "CW_KK_INS2_DOI_MELEE"},
	},
}
