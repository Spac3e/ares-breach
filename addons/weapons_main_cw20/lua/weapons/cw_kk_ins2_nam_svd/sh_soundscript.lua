--[[


addons/[weapons]_no_260_kk_ins2/lua/weapons/cw_kk_ins2_nam_svd/sh_soundscript.lua

--]]


SWEP.Sounds = {
	base_ready = {
		{time = 0/29, sound = "CW_KK_INS2_UNIVERSAL_DRAW"},
		{time = 13/29, sound = "CW_KK_INS2_AK74_FIRESELECT"},
		{time = 28/29, sound = "CW_KK_INS2_SKS_BOLTBACK"},
		{time = 34/29, sound = "CW_KK_INS2_SKS_BOLTRELEASE"},
	},

	base_draw = {
		{time = 0/29, sound = "CW_KK_INS2_UNIVERSAL_DRAW"},
		{time = 9/29, sound = "CW_KK_INS2_AK74_FIRESELECT"},
	},

	base_holster = {
		{time = 0/30, sound = "CW_KK_INS2_UNIVERSAL_HOLSTER"},
		{time = 12/30, sound = "CW_KK_INS2_AK74_FIRESELECT"},
	},

	base_crawl = {
		{time = 0/30, sound = "CW_KK_INS2_UNIVERSAL_LEFTCRAWL"},
		{time = 22/30, sound = "CW_KK_INS2_UNIVERSAL_RIGHTCRAWL"},
	},

	-- base_fire = {
		-- // { event AE_MUZZLEFLASH 0 ""},
		-- // { event AE_CL_CREATE_PARTICLE_BRASS 0 ""},
	-- },

	base_dryfire = {
		{time = 0/30, sound = "CW_KK_INS2_SKS_EMPTY"},
	},

	-- base_firelast = {
		-- // { event AE_MUZZLEFLASH 0 ""},
		-- // { event AE_CL_CREATE_PARTICLE_BRASS 0 ""},
	-- },

	base_reload = {
		{time = 17/30, sound = "CW_KK_INS2_SKS_MAGRELEASE"},
		{time = 23/30, sound = "CW_KK_INS2_SKS_MAGOUT"},
		{time = 71/30, sound = "CW_KK_INS2_SKS_MAGIN"},
		// { event 46 68 ""},
	},

	base_reloadempty = {
		{time = 20/30, sound = "CW_KK_INS2_SKS_MAGRELEASE"},
		{time = 25/30, sound = "CW_KK_INS2_SKS_MAGOUT"},
		{time = 79/30, sound = "CW_KK_INS2_SKS_MAGIN"},
		// { event 46 68 ""},
		{time = 106/30, sound = "CW_KK_INS2_SKS_BOLTBACK"},
		{time = 111/30, sound = "CW_KK_INS2_SKS_BOLTRELEASE"},
	},

	empty_draw = {
		{time = 0/30, sound = "CW_KK_INS2_UNIVERSAL_DRAW"},
	},

	empty_holster = {
		{time = 0/30, sound = "CW_KK_INS2_UNIVERSAL_HOLSTER"},
	},

	empty_crawl = {
		{time = 0/30, sound = "CW_KK_INS2_UNIVERSAL_LEFTCRAWL"},
		{time = 22/30, sound = "CW_KK_INS2_UNIVERSAL_RIGHTCRAWL"},
	},

	-- iron_fire = {
		-- // { event AE_MUZZLEFLASH 0 ""},
		-- // { event AE_CL_CREATE_PARTICLE_BRASS 0 ""},
	-- },

	iron_dryfire = {
		{time = 0/30, sound = "CW_KK_INS2_SKS_EMPTY"},
	},

	-- iron_firelast = {
		-- // { event AE_MUZZLEFLASH 0 ""},
		-- // { event AE_CL_CREATE_PARTICLE_BRASS 0 ""},
	-- },

	foregrip_ready = {
		{time = 0/30, sound = "CW_KK_INS2_UNIVERSAL_DRAW"},
		{time = 13/30, sound = "CW_KK_INS2_AK74_FIRESELECT"},
		{time = 28/30, sound = "CW_KK_INS2_SKS_BOLTBACK"},
		{time = 34/30, sound = "CW_KK_INS2_SKS_BOLTRELEASE"},
	},

	foregrip_draw = {
		{time = 0/30, sound = "CW_KK_INS2_UNIVERSAL_DRAW"},
		{time = 9/30, sound = "CW_KK_INS2_AK74_FIRESELECT"},
	},

	foregrip_holster = {
		{time = 12/30, sound = "CW_KK_INS2_AK74_FIRESELECT"},
		{time = 0/30, sound = "CW_KK_INS2_UNIVERSAL_HOLSTER"},
	},

	foregrip_crawl = {
		{time = 0/30, sound = "CW_KK_INS2_UNIVERSAL_LEFTCRAWL"},
		{time = 22/30, sound = "CW_KK_INS2_UNIVERSAL_RIGHTCRAWL"},
	},

	-- foregrip_fire = {
		-- // { event AE_MUZZLEFLASH 0 ""},
		-- // { event AE_CL_CREATE_PARTICLE_BRASS 0 ""},
	-- },

	foregrip_dryfire = {
		{time = 0/30, sound = "CW_KK_INS2_SKS_EMPTY"},
	},

	-- foregrip_firelast = {
		-- // { event AE_MUZZLEFLASH 0 ""},
		-- // { event AE_CL_CREATE_PARTICLE_BRASS 0 ""},
	-- },

	foregrip_reloadempty = {
		{time = 20/30, sound = "CW_KK_INS2_SKS_MAGRELEASE"},
		{time = 25/30, sound = "CW_KK_INS2_SKS_MAGOUT"},
		{time = 79/30, sound = "CW_KK_INS2_SKS_MAGIN"},
		// { event 46 68 ""},
		{time = 106/30, sound = "CW_KK_INS2_SKS_BOLTBACK"},
		{time = 111/30, sound = "CW_KK_INS2_SKS_BOLTRELEASE"},
	},

	foregrip_reload = {
		{time = 17/30, sound = "CW_KK_INS2_SKS_MAGRELEASE"},
		{time = 23/30, sound = "CW_KK_INS2_SKS_MAGOUT"},
		{time = 71/30, sound = "CW_KK_INS2_SKS_MAGIN"},
		// { event 46 68 ""},
	},

	-- foregrip_iron_fire_b = {
		-- // { event AE_MUZZLEFLASH 0 ""},
		-- // { event AE_CL_CREATE_PARTICLE_BRASS 0 ""},
	-- },

	foregrip_iron_dryfire_b = {
		{time = 0/30, sound = "CW_KK_INS2_SKS_EMPTY"},
	},

	-- foregrip_iron_firelast_b = {
		-- // { event AE_MUZZLEFLASH 0 ""},
		-- // { event AE_CL_CREATE_PARTICLE_BRASS 0 ""},
	-- },

	foregrip_empty_draw = {
		{time = 0/30, sound = "CW_KK_INS2_UNIVERSAL_DRAW"},
	},

	foregrip_empty_holster = {
		{time = 0/30, sound = "CW_KK_INS2_UNIVERSAL_HOLSTER"},
	},

	foregrip_empty_crawl = {
		{time = 0/30, sound = "CW_KK_INS2_UNIVERSAL_LEFTCRAWL"},
		{time = 22/30, sound = "CW_KK_INS2_UNIVERSAL_RIGHTCRAWL"},
	},

	deployed_in = {
		{time = 14/30, sound = "CW_KK_INS2_UNIVERSAL_BIPOD_DEPLOYSTART"},
		{time = 17/30, sound = "CW_KK_INS2_UNIVERSAL_BIPOD_DEPLOYEND"},
	},

	deployed_out = {
		{time = 11/30, sound = "CW_KK_INS2_UNIVERSAL_BIPOD_RETRACT"},
	},

	-- deployed_fire = {
		-- // { event AE_MUZZLEFLASH 0 ""},
		-- // { event AE_CL_CREATE_PARTICLE_BRASS 0 ""},
	-- },

	deployed_dryfire = {
		{time = 0/30, sound = "CW_KK_INS2_SKS_EMPTY"},
	},

	deployed_reload = {
		{time = 24/30, sound = "CW_KK_INS2_SKS_MAGRELEASE"},
		{time = 27/30, sound = "CW_KK_INS2_SKS_MAGOUT"},
		{time = 77/30, sound = "CW_KK_INS2_SKS_MAGIN"},
		// { event 46 66 ""},
	},

	deployed_reloadempty = {
		{time = 24/30, sound = "CW_KK_INS2_SKS_MAGRELEASE"},
		{time = 27/30, sound = "CW_KK_INS2_SKS_MAGOUT"},
		{time = 81/30, sound = "CW_KK_INS2_SKS_MAGIN"},
		// { event 46 68 ""},
		{time = 105/30, sound = "CW_KK_INS2_SKS_BOLTBACK"},
		{time = 114/30, sound = "CW_KK_INS2_SKS_BOLTRELEASE"},
	},

	-- deployed_iron_fire = {
		-- // { event AE_MUZZLEFLASH 0 ""},
		-- // { event AE_CL_CREATE_PARTICLE_BRASS 0 ""},
	-- },

	-- deployed_iron_fire_last = {
		-- // { event AE_MUZZLEFLASH 0 ""},
		-- // { event AE_CL_CREATE_PARTICLE_BRASS 0 ""},
	-- },

	deployed_iron_dryfire = {
		{time = 0/30, sound = "CW_KK_INS2_SKS_EMPTY"},
	},

	deployed_empty_in = {
		{time = 12/30, sound = "CW_KK_INS2_UNIVERSAL_BIPOD_DEPLOYSTART"},
		{time = 17/30, sound = "CW_KK_INS2_UNIVERSAL_BIPOD_DEPLOYEND"},
	},

	deployed_empty_out = {
		{time = 20/30, sound = "CW_KK_INS2_UNIVERSAL_BIPOD_RETRACT"},
	},

	deployed_empty_dryfire = {
		{time = 0/30, sound = "CW_KK_INS2_SKS_EMPTY"},
	},
}
