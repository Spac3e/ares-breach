--[[


addons/[weapons]_no_260_kk_ins2/lua/weapons/cw_kk_ins2_doi_c96_c/sh_soundscript.lua

--]]


SWEP.Sounds = {
	base_ready = {
		{time = 0/30, sound = "CW_KK_INS2_UNIVERSAL_DRAW"},
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

	-- base_fire_1 = {
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

	-- base_firelast = {
		-- // { event AE_MUZZLEFLASH 0 ""},
		-- // { event AE_CL_CREATE_PARTICLE_BRASS 0 ""},
	-- },

	base_dryfire = {
		{time = 0/30, sound = "CW_KK_INS2_DOI_C96_EMPTY"},
	},

	base_fireselect = {
		{time = 13/31.2, sound = "CW_KK_INS2_DOI_THOMPSON_FIRESELECT"},
	},

	base_reload = {
		{time = 19/31.8, sound = "CW_KK_INS2_DOI_C96_MAGRELEASE"},
		{time = 25/31.8, sound = "CW_KK_INS2_DOI_C96_MAGOUT"},
		{time = 32/31.8, sound = "CW_KK_INS2_DOI_C96_FETCHMAG"},
		{time = 64/31.8, sound = "CW_KK_INS2_DOI_C96_MAGFIDDLE"},
		{time = 71/31.8, sound = "CW_KK_INS2_DOI_C96_MAGIN"},
		// { event 46 72 ""},
		{time = 89/31.8, sound = "CW_KK_INS2_DOI_C96_RATTLE"},
	},

	base_reloadempty = {
		{time = 19/31.8, sound = "CW_KK_INS2_DOI_C96_MAGRELEASE"},
		{time = 25/31.8, sound = "CW_KK_INS2_DOI_C96_MAGOUT"},
		{time = 32/31.8, sound = "CW_KK_INS2_DOI_C96_FETCHMAG"},
		{time = 64/31.8, sound = "CW_KK_INS2_DOI_C96_MAGFIDDLE"},
		{time = 71/31.8, sound = "CW_KK_INS2_DOI_C96_MAGIN"},
		{time = 106/31.8, sound = "CW_KK_INS2_DOI_C96_BOLTRELEASE"},
		// { event 46 72 ""},
		{time = 124/31.8, sound = "CW_KK_INS2_DOI_C96_RATTLE"},
	},

	base_reload_ext = {
		{time = 19/31.8, sound = "CW_KK_INS2_DOI_C96_MAGRELEASE"},
		{time = 25/31.8, sound = "CW_KK_INS2_DOI_C96_MAGOUT"},
		{time = 32/31.8, sound = "CW_KK_INS2_DOI_C96_FETCHMAG"},
		{time = 64/31.8, sound = "CW_KK_INS2_DOI_C96_MAGFIDDLE"},
		{time = 71/31.8, sound = "CW_KK_INS2_DOI_C96_MAGIN"},
		// { event 46 72 ""},
		{time = 89/31.8, sound = "CW_KK_INS2_DOI_C96_RATTLE"},
	},

	base_reloadempty_ext = {
		{time = 19/31.8, sound = "CW_KK_INS2_DOI_C96_MAGRELEASE"},
		{time = 25/31.8, sound = "CW_KK_INS2_DOI_C96_MAGOUT"},
		{time = 32/31.8, sound = "CW_KK_INS2_DOI_C96_FETCHMAG"},
		{time = 64/31.8, sound = "CW_KK_INS2_DOI_C96_MAGFIDDLE"},
		{time = 71/31.8, sound = "CW_KK_INS2_DOI_C96_MAGIN"},
		{time = 106/31.8, sound = "CW_KK_INS2_DOI_C96_BOLTRELEASE"},
		// { event 46 72 ""},
		{time = 124/31.8, sound = "CW_KK_INS2_DOI_C96_RATTLE"},
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

	-- iron_firelast = {
		-- // { event AE_MUZZLEFLASH 0 ""},
		-- // { event AE_CL_CREATE_PARTICLE_BRASS 0 ""},
	-- },

	iron_dryfire = {
		{time = 0/30, sound = "CW_KK_INS2_DOI_C96_EMPTY"},
	},

	iron_fireselect = {
		{time = 13/31.2, sound = "CW_KK_INS2_DOI_THOMPSON_FIRESELECT"},
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
		{time = 13/31.2, sound = "CW_KK_INS2_DOI_THOMPSON_FIRESELECT"},
	},

	iron_fireselect_empty = {
		{time = 13/31.2, sound = "CW_KK_INS2_DOI_THOMPSON_FIRESELECT"},
	},

	base_melee_bash = {
		{time = 6/33, sound = "CW_KK_INS2_DOI_MELEE"},
	},

	base_melee_bash_empty = {
		{time = 6/33, sound = "CW_KK_INS2_DOI_MELEE"},
	},
}
