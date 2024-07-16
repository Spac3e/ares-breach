--[[


addons/[weapons]_no_260_kk_ins2/lua/weapons/cw_kk_ins2_nam_vz61/sh_soundscript.lua

--]]


SWEP.Sounds = {
	base_ready = {
		{time = 0/30, sound = "CW_KK_INS2_UNIVERSAL_DRAW"},
		{time = 14/30, sound = "CW_KK_INS2_MP5K_BOLTBACK"},
		{time = 20/30, sound = "CW_KK_INS2_MP5K_BOLTRELEASE"},
	},

	base_draw = {
		{time = 0/31, sound = "CW_KK_INS2_UNIVERSAL_DRAW"},
	},

	base_holster = {
		{time = 0/32, sound = "CW_KK_INS2_UNIVERSAL_HOLSTER"},
	},

	base_crawl = {
		{time = 0/30, sound = "CW_KK_INS2_UNIVERSAL_LEFTCRAWL"},
		{time = 22/30, sound = "CW_KK_INS2_UNIVERSAL_RIGHTCRAWL"},
	},

	-- base_fire = {
		-- // { event AE_MUZZLEFLASH 0 ""},
		-- // { event AE_CL_CREATE_PARTICLE_BRASS 0 ""},
	-- },

	-- base_firelast = {
		-- // { event AE_MUZZLEFLASH 0 ""},
		-- // { event AE_CL_CREATE_PARTICLE_BRASS 0 ""},
	-- },

	base_dryfire = {
		{time = 0/30, sound = "CW_KK_INS2_MP5K_EMPTY"},
	},

	base_fireselect = {
		{time = 10/29, sound = "CW_KK_INS2_MP5K_FIRESELECT"},
	},

	base_fireselect_empty = {
		{time = 10/30, sound = "CW_KK_INS2_MP5K_FIRESELECT"},
	},

	base_reload = {
		{time = 20/30, sound = "CW_KK_INS2_MP5K_MAGRELEASE"},
		{time = 24/30, sound = "CW_KK_INS2_MP5K_MAGOUT"},
		{time = 65/30, sound = "CW_KK_INS2_MP5K_MAGIN"},
		// { event 46 68 ""},
	},

	base_reloadempty = {
		{time = 20/30, sound = "CW_KK_INS2_MP5K_MAGRELEASE"},
		{time = 24/30, sound = "CW_KK_INS2_MP5K_MAGOUT"},
		{time = 65/30, sound = "CW_KK_INS2_MP5K_MAGIN"},
		// { event 46 93 ""},
		{time = 92/30, sound = "CW_KK_INS2_MP5K_BOLTBACK"},
		{time = 98/30, sound = "CW_KK_INS2_MP5K_BOLTRELEASE"},
	},

	base_reloadempty2 = {
		{time = 20/30, sound = "CW_KK_INS2_MP5K_MAGRELEASE"},
		{time = 24/30, sound = "CW_KK_INS2_MP5K_MAGOUT"},
		{time = 65/30, sound = "CW_KK_INS2_MP5K_MAGIN"},
		// { event 46 93 ""},
		{time = 92/30, sound = "CW_KK_INS2_MP5K_BOLTBACK"},
		{time = 98/30, sound = "CW_KK_INS2_MP5K_BOLTRELEASE"},
	},

	empty_draw = {
		{time = 0/31, sound = "CW_KK_INS2_UNIVERSAL_DRAW"},
	},

	empty_holster = {
		{time = 0/31, sound = "CW_KK_INS2_UNIVERSAL_HOLSTER"},
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

	-- iron_fire_c = {
		-- // { event AE_MUZZLEFLASH 0 ""},
		-- // { event AE_CL_CREATE_PARTICLE_BRASS 0 ""},
	-- },

	-- iron_fire_d = {
		-- // { event AE_MUZZLEFLASH 0 ""},
		-- // { event AE_CL_CREATE_PARTICLE_BRASS 0 ""},
	-- },

	-- iron_fire_e = {
		-- // { event AE_MUZZLEFLASH 0 ""},
		-- // { event AE_CL_CREATE_PARTICLE_BRASS 0 ""},
	-- },

	-- iron_fire_f = {
		-- // { event AE_MUZZLEFLASH 0 ""},
		-- // { event AE_CL_CREATE_PARTICLE_BRASS 0 ""},
	-- },

	-- iron_firelast = {
		-- // { event AE_MUZZLEFLASH 0 ""},
		-- // { event AE_CL_CREATE_PARTICLE_BRASS 0 ""},
	-- },

	iron_dryfire = {
		{time = 0/30, sound = "CW_KK_INS2_MP5K_EMPTY"},
	},

	iron_fireselect = {
		{time = 10/28, sound = "CW_KK_INS2_MP5K_FIRESELECT"},
	},

	iron_fireselect_empty = {
		{time = 10/30, sound = "CW_KK_INS2_MP5K_FIRESELECT"},
	},
}
