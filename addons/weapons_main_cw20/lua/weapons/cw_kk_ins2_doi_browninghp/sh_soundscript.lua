--[[


addons/[weapons]_no_260_kk_ins2/lua/weapons/cw_kk_ins2_doi_browninghp/sh_soundscript.lua

--]]


SWEP.Sounds = {
	base_ready = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_PISTOL_DRAW"},
		{time = 17/30, sound = "CW_KK_INS2_DOI_BHP_SAFETY"},
		{time = 40/30, sound = "CW_KK_INS2_DOI_BHP_BOLTBACK"},
		{time = 45/30, sound = "CW_KK_INS2_DOI_BHP_BOLTRELEASE"},
	},

	base_draw = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_PISTOL_DRAW"},
	},

	base_holster = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_PISTOL_HOLSTER"},
	},

	base_crawl = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_LEFTCRAWL"},
		{time = 22/35, sound = "CW_KK_INS2_UNIVERSAL_RIGHTCRAWL"},
	},

	-- base_fire = {
		-- { event AE_MUZZLEFLASH 0 ""},
		-- { event AE_CL_CREATE_PARTICLE_BRASS 0 ""},
	-- },

	-- base_fire2 = {
		-- { event AE_MUZZLEFLASH 0 ""},
		-- { event AE_CL_CREATE_PARTICLE_BRASS 0 ""},
	-- },

	-- base_fire3 = {
		-- { event AE_MUZZLEFLASH 0 ""},
		-- { event AE_CL_CREATE_PARTICLE_BRASS 0 ""},
	-- },

	-- base_firelast = {
		-- { event AE_MUZZLEFLASH 0 ""},
		-- { event AE_CL_CREATE_PARTICLE_BRASS 0 ""},
	-- },

	base_dryfire = {
		{time = 0, sound = "CW_KK_INS2_DOI_BHP_EMPTY"},
	},

	base_reload = {
		{time = 10/31.5, sound = "CW_KK_INS2_DOI_BHP_MAGRELEASE"},
		{time = 12/31.5, sound = "CW_KK_INS2_DOI_BHP_MAGOUT"},
		{time = 49/31.5, sound = "CW_KK_INS2_DOI_BHP_MAGIN"},
		{time = 58/31.5, sound = "CW_KK_INS2_DOI_BHP_MAGHIT"},
		-- { event 46 60 ""},
	},

	base_reloadempty = {
		{time = 10/31.5, sound = "CW_KK_INS2_DOI_BHP_MAGRELEASE"},
		{time = 12/31.5, sound = "CW_KK_INS2_DOI_BHP_MAGOUT"},
		{time = 49/31.5, sound = "CW_KK_INS2_DOI_BHP_MAGIN"},
		{time = 58/31.5, sound = "CW_KK_INS2_DOI_BHP_MAGHIT"},
		-- { event 46 60 ""},
		{time = 77/31.5, sound = "CW_KK_INS2_DOI_BHP_BOLTRELEASE"},
	},

	empty_draw = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_PISTOL_DRAW"},
	},

	empty_holster = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_PISTOL_HOLSTER"},
	},

	empty_crawl = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_LEFTCRAWL"},
		{time = 22/35, sound = "CW_KK_INS2_UNIVERSAL_RIGHTCRAWL"},
	},

	-- iron_fire = {
		-- { event AE_MUZZLEFLASH 0 ""},
		-- { event AE_CL_CREATE_PARTICLE_BRASS 0 ""},
	-- },

	-- iron_fire2 = {
		-- { event AE_MUZZLEFLASH 0 ""},
		-- { event AE_CL_CREATE_PARTICLE_BRASS 0 ""},
	-- },

	-- iron_fire3 = {
		-- { event AE_MUZZLEFLASH 0 ""},
		-- { event AE_CL_CREATE_PARTICLE_BRASS 0 ""},
	-- },

	-- iron_firelast = {
		-- { event AE_MUZZLEFLASH 0 ""},
		-- { event AE_CL_CREATE_PARTICLE_BRASS 0 ""},
	-- },

	iron_dryfire = {
		{time = 0, sound = "CW_KK_INS2_DOI_BHP_EMPTY"},
	},

	base_melee_bash = {
		{time = 9/33, sound = "CW_KK_INS2_DOI_MELEE"},
	},

	empty_melee_bash = {
		{time = 9/33, sound = "CW_KK_INS2_DOI_MELEE"},
	},
}
