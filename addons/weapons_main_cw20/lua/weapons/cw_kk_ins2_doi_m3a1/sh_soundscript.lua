--[[


addons/[weapons]_no_260_kk_ins2/lua/weapons/cw_kk_ins2_doi_m3a1/sh_soundscript.lua

--]]


SWEP.Sounds = {
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

	-- base_firelast = {
		-- // { event AE_MUZZLEFLASH 0 ""},
		-- // { event AE_CL_CREATE_PARTICLE_BRASS 0 ""},
	-- },

	base_dryfire = {
		{time = 0/30, sound = "CW_KK_INS2_DOI_GREASE_EMPTY"},
	},

	base_reload = {
		{time = 23/32.5, sound = "CW_KK_INS2_DOI_GREASE_MAGRELEASE"},
		{time = 31/32.5, sound = "CW_KK_INS2_DOI_GREASE_MAGOUT"},
		{time = 64/32.5, sound = "CW_KK_INS2_DOI_GREASE_MAGIN"},
		{time = 76/32.5, sound = "CW_KK_INS2_DOI_GREASE_MAGHIT"},
		// { event 46 77 ""},
	},

	base_reloadempty = {
		{time = 23/32.5, sound = "CW_KK_INS2_DOI_GREASE_MAGRELEASE"},
		{time = 31/32.5, sound = "CW_KK_INS2_DOI_GREASE_MAGOUT"},
		{time = 64/32.5, sound = "CW_KK_INS2_DOI_GREASE_MAGIN"},
		{time = 76/32.5, sound = "CW_KK_INS2_DOI_GREASE_MAGHIT"},
		// { event 46 77 ""},
		{time = 121/32.5, sound = "CW_KK_INS2_DOI_GREASE_BOLTBACK"},
	},

	empty_draw = {
		{time = 0/31.8, sound = "CW_KK_INS2_UNIVERSAL_DRAW"},
	},

	empty_holster = {
		{time = 0/34, sound = "CW_KK_INS2_UNIVERSAL_HOLSTER"},
	},

	empty_crawl = {
		{time = 0/30, sound = "CW_KK_INS2_UNIVERSAL_LEFTCRAWL"},
		{time = 22/30, sound = "CW_KK_INS2_UNIVERSAL_RIGHTCRAWL"},
	},

	-- iron_fire = {
		-- // { event AE_MUZZLEFLASH 0 ""},
		-- // { event AE_CL_CREATE_PARTICLE_BRASS 0 ""},
	-- },

	-- iron_fire_a = {
		-- // { event AE_MUZZLEFLASH 0 ""},
		-- // { event AE_CL_CREATE_PARTICLE_BRASS 0 ""},
	-- },

	-- iron_fire_b = {
		-- // { event AE_MUZZLEFLASH 0 ""},
		-- // { event AE_CL_CREATE_PARTICLE_BRASS 0 ""},
	-- },

	-- iron_firelast = {
		-- // { event AE_MUZZLEFLASH 0 ""},
		-- // { event AE_CL_CREATE_PARTICLE_BRASS 0 ""},
	-- },

	iron_dryfire = {
		{time = 0/30, sound = "CW_KK_INS2_DOI_GREASE_EMPTY"},
	},

	base_melee_bash = {
		{time = 6/31, sound = "CW_KK_INS2_DOI_MELEE"},
	},

	empty_melee_bash = {
		{time = 6/31, sound = "CW_KK_INS2_DOI_MELEE"},
	},
}
