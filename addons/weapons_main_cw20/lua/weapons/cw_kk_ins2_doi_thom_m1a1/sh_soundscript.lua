--[[


addons/[weapons]_no_260_kk_ins2/lua/weapons/cw_kk_ins2_doi_thom_m1a1/sh_soundscript.lua

--]]


SWEP.Sounds = {
	base_ready = {
		{time = 0/31, sound = "CW_KK_INS2_UNIVERSAL_DRAW"},
		{time = 22/31, sound = "CW_KK_INS2_DOI_THOM_M1A1_BOLTRELEASE"},
		{time = 43/31, sound = "CW_KK_INS2_DOI_THOM_M1A1_RATTLE"},
	},

	base_draw = {
		{time = 0/31.8, sound = "CW_KK_INS2_UNIVERSAL_DRAW"},
	},

	base_holster = {
		{time = 0/34, sound = "CW_KK_INS2_UNIVERSAL_HOLSTER"},
	},

	base_crawl = {
		{time = 0/30, sound = "CW_KK_INS2_UNIVERSAL_LEFTCRAWL"},
		{time = 22/30, sound = "CW_KK_INS2_UNIVERSAL_RIGHTCRAWL"},
	},

	-- base_fire = {
		-- // { event AE_MUZZLEFLASH 0 ""},
		-- // { event AE_CL_CREATE_PARTICLE_BRASS 0 ""},
	-- },

	-- base_fire_2 = {
		-- // { event AE_MUZZLEFLASH 0 ""},
		-- // { event AE_CL_CREATE_PARTICLE_BRASS 0 ""},
	-- },

	-- base_fire_3 = {
		-- // { event AE_MUZZLEFLASH 0 ""},
		-- // { event AE_CL_CREATE_PARTICLE_BRASS 0 ""},
	-- },

	base_dryfire = {
		{time = 0/30, sound = "CW_KK_INS2_DOI_THOM_M1A1_EMPTY"},
	},

	base_fireselect = {
		{time = 13/31.2, sound = "CW_KK_INS2_DOI_THOM_M1A1_FIRESELECT"},
	},

	base_reload = {
		{time = 17/31.5, sound = "CW_KK_INS2_DOI_THOM_M1A1_MAGRELEASE"},
		{time = 20/31.5, sound = "CW_KK_INS2_DOI_THOM_M1A1_MAGOUT"},
		{time = 27/31.5, sound = "CW_KK_INS2_DOI_THOM_M1A1_MAGOUTRATTLE"},
		{time = 60/31.5, sound = "CW_KK_INS2_DOI_THOM_M1A1_MAGHIT"},
		{time = 76/31.5, sound = "CW_KK_INS2_DOI_THOM_M1A1_MAGIN"},
		// { event 46 77 ""},
		{time = 95/31.5, sound = "CW_KK_INS2_DOI_THOM_M1A1_RATTLE"},
	},

	base_reloadempty_1 = {
		{time = 17/31.5, sound = "CW_KK_INS2_DOI_THOM_M1A1_MAGRELEASE"},
		{time = 20/31.5, sound = "CW_KK_INS2_DOI_THOM_M1A1_MAGOUT"},
		{time = 27/31.5, sound = "CW_KK_INS2_DOI_THOM_M1A1_MAGOUTRATTLE"},
		{time = 82/31.5, sound = "CW_KK_INS2_DOI_THOM_M1A1_MAGTAP"},
		{time = 104/31.5, sound = "CW_KK_INS2_DOI_THOM_M1A1_MAGHIT"},
		{time = 118/31.5, sound = "CW_KK_INS2_DOI_THOM_M1A1_MAGIN"},
		// { event 46 119 ""},
		{time = 141/31.5, sound = "CW_KK_INS2_DOI_THOM_M1A1_RATTLE"},
	},

	base_reloadempty_2 = {
		{time = 41/31.5, sound = "CW_KK_INS2_DOI_THOM_M1A1_MAGRELEASE"},
		{time = 45/31.5, sound = "CW_KK_INS2_DOI_THOM_M1A1_MAGOUT"},
		{time = 52/31.5, sound = "CW_KK_INS2_DOI_THOM_M1A1_MAGOUTRATTLE"},
		{time = 105/31.5, sound = "CW_KK_INS2_DOI_THOM_M1A1_MAGHIT"},
		{time = 118/31.5, sound = "CW_KK_INS2_DOI_THOM_M1A1_MAGIN"},
		// { event 46 119 ""},
		{time = 141/31.5, sound = "CW_KK_INS2_DOI_THOM_M1A1_RATTLE"},
	},

	-- iron_fire_1 = {
		-- // { event AE_MUZZLEFLASH 0 ""},
		-- // { event AE_CL_CREATE_PARTICLE_BRASS 0 ""},
	-- },

	-- iron_fire_2 = {
		-- // { event AE_MUZZLEFLASH 0 ""},
		-- // { event AE_CL_CREATE_PARTICLE_BRASS 0 ""},
	-- },

	-- iron_fire_3 = {
		-- // { event AE_MUZZLEFLASH 0 ""},
		-- // { event AE_CL_CREATE_PARTICLE_BRASS 0 ""},
	-- },

	iron_dryfire = {
		{time = 0/30, sound = "CW_KK_INS2_DOI_THOM_M1A1_EMPTY"},
	},

	iron_fireselect = {
		{time = 13/31.2, sound = "CW_KK_INS2_DOI_THOM_M1A1_FIRESELECT"},
	},

	base_melee_bash = {
		{time = 6/31, sound = "CW_KK_INS2_DOI_MELEE"},
	},
}
