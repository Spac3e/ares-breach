--[[


addons/[weapons]_no_260_kk_ins2/lua/weapons/cw_kk_ins2_nam_m4/sh_soundscript.lua

--]]


SWEP.Sounds = {
	base_ready = {
		{time = 0/30, sound = "CW_KK_INS2_UNIVERSAL_DRAW"},
		{time = 19/30, sound = "CW_KK_INS2_M4A1_BOLTBACK"},
		{time = 25/30, sound = "CW_KK_INS2_M4A1_BOLTRELEASE"},
		{time = 42/30, sound = "CW_KK_INS2_M4A1_HIT"},
		{time = 53/30, sound = "CW_KK_INS2_UNIVERSAL_LEANIN"},
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

	-- base_fire = {
		-- // { event AE_MUZZLEFLASH 0 ""},
		-- // { event AE_CL_CREATE_PARTICLE_BRASS 0 ""},
	-- },

	base_dryfire = {
		{time = 1/30, sound = "CW_KK_INS2_M4A1_EMPTY"},
	},

	base_fireselect = {
		{time = 10/30, sound = "CW_KK_INS2_M4A1_FIRESELECT"},
	},

	base_reload = {
		{time = 13/30, sound = "CW_KK_INS2_M4A1_MAGRELEASE"},
		{time = 18/30, sound = "CW_KK_INS2_M4A1_MAGOUT"},
		{time = 71/30, sound = "CW_KK_INS2_M4A1_MAGIN"},
		{time = 84/30, sound = "CW_KK_INS2_M4A1_HIT"},
		{time = 102/30, sound = "CW_KK_INS2_UNIVERSAL_LEANIN"},
		{time = 114/30, sound = "CW_KK_INS2_UNIVERSAL_LEANIN"},
	},

	base_reloadempty = {
		{time = 13/30, sound = "CW_KK_INS2_M4A1_MAGRELEASE"},
		{time = 18/30, sound = "CW_KK_INS2_M4A1_MAGOUT"},
		{time = 71/30, sound = "CW_KK_INS2_M4A1_MAGIN"},
		{time = 84/30, sound = "CW_KK_INS2_M4A1_HIT"},
		{time = 109/30, sound = "CW_KK_INS2_M4A1_BOLTBACK"},
		{time = 115/30, sound = "CW_KK_INS2_M4A1_BOLTRELEASE"},
		{time = 124/30, sound = "CW_KK_INS2_UNIVERSAL_LEANIN"},
		{time = 134/30, sound = "CW_KK_INS2_UNIVERSAL_LEANIN"},
	},

	base_reload_ext = {
		{time = 13/30, sound = "CW_KK_INS2_M4A1_MAGRELEASE"},
		{time = 18/30, sound = "CW_KK_INS2_M4A1_MAGOUT"},
		{time = 71/30, sound = "CW_KK_INS2_M4A1_MAGIN"},
		{time = 84/30, sound = "CW_KK_INS2_M4A1_HIT"},
		{time = 102/30, sound = "CW_KK_INS2_UNIVERSAL_LEANIN"},
		{time = 114/30, sound = "CW_KK_INS2_UNIVERSAL_LEANIN"},
	},

	base_reloadempty_ext = {
		{time = 13/30, sound = "CW_KK_INS2_M4A1_MAGRELEASE"},
		{time = 18/30, sound = "CW_KK_INS2_M4A1_MAGOUT"},
		{time = 71/30, sound = "CW_KK_INS2_M4A1_MAGIN"},
		{time = 84/30, sound = "CW_KK_INS2_M4A1_HIT"},
		{time = 109/30, sound = "CW_KK_INS2_M4A1_BOLTBACK"},
		{time = 115/30, sound = "CW_KK_INS2_M4A1_BOLTRELEASE"},
		{time = 124/30, sound = "CW_KK_INS2_UNIVERSAL_LEANIN"},
		{time = 134/30, sound = "CW_KK_INS2_UNIVERSAL_LEANIN"},
	},

	-- iron_fire = {
		-- // { event AE_MUZZLEFLASH 0 ""},
		-- // { event AE_CL_CREATE_PARTICLE_BRASS 0 ""},
	-- },

	iron_dryfire = {
		{time = 0/30, sound = "CW_KK_INS2_M4A1_EMPTY"},
	},

	iron_fireselect = {
		{time = 0/30, sound = "CW_KK_INS2_M4A1_FIRESELECT"},
	},
}
