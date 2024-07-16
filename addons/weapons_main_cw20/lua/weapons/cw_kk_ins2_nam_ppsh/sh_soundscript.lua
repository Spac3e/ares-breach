--[[


addons/[weapons]_no_260_kk_ins2/lua/weapons/cw_kk_ins2_nam_ppsh/sh_soundscript.lua

--]]


SWEP.Sounds = {
	base_ready = {
		{time = 0/30, sound = "CW_KK_INS2_UNIVERSAL_DRAW"},
		{time = 17/30, sound = "CW_KK_INS2_STERLING_BOLTBACK"},
	},

	base_draw = {
		{time = 0/31, sound = "CW_KK_INS2_UNIVERSAL_DRAW"},
	},

	base_draw_empty = {
		{time = 0/31, sound = "CW_KK_INS2_UNIVERSAL_DRAW"},
	},

	base_holster = {
		{time = 0/31, sound = "CW_KK_INS2_UNIVERSAL_HOLSTER"},
	},

	base_holster_empty = {
		{time = 0/33, sound = "CW_KK_INS2_UNIVERSAL_HOLSTER"},
	},

	base_crawl = {
		{time = 0/30, sound = "CW_KK_INS2_UNIVERSAL_LEFTCRAWL"},
		{time = 22/30, sound = "CW_KK_INS2_UNIVERSAL_RIGHTCRAWL"},
	},

	base_crawl_empty = {
		{time = 0/30, sound = "CW_KK_INS2_UNIVERSAL_LEFTCRAWL"},
		{time = 22/30, sound = "CW_KK_INS2_UNIVERSAL_RIGHTCRAWL"},
	},

	-- base_fire = {
		-- // { event AE_MUZZLEFLASH 0 "mini14 MUZZLE"},
		-- // { event AE_CL_CREATE_PARTICLE_BRASS 0 "mini14 EJECT"},
	-- },

	-- base_fire_last = {
		-- // { event AE_MUZZLEFLASH 0 "mini14 MUZZLE"},
		-- // { event AE_CL_CREATE_PARTICLE_BRASS 0 "mini14 EJECT"},
	-- },

	base_dryfire = {
		{time = 0/30, sound = "CW_KK_INS2_M14_EMPTY"},
	},

	base_fireselect = {
		{time = 7/30, sound = "CW_KK_INS2_M14_FIRESELECT"},
	},

	base_fireselect_empty = {
		{time = 7/30, sound = "CW_KK_INS2_M14_FIRESELECT"},
	},

	base_reload = {
		{time = 21/30, sound = "CW_KK_INS2_STERLING_MAGRELEASE"},
		{time = 27/30, sound = "CW_KK_INS2_STERLING_MAGOUT"},
		{time = 46/30, sound = "CW_KK_INS2_GALIL_DRUM_MAGFETCH"},
		{time = 86/30, sound = "CW_KK_INS2_STERLING_MAGIN"},
		{time = 94/30, sound = "CW_KK_INS2_STERLING_MAGHIT"},
		// { event 46 92 ""},
	},

	base_reload_drum = {
		{time = 28/30, sound = "CW_KK_INS2_GALIL_MAGRELEASE"},
		{time = 35/30, sound = "CW_KK_INS2_GALIL_DRUM_MAGOUT"},
		{time = 43/30, sound = "CW_KK_INS2_GALIL_DRUM_MAGOUTRATTLE"},
		{time = 65/30, sound = "CW_KK_INS2_GALIL_DRUM_MAGFETCH"},
		{time = 111/30, sound = "CW_KK_INS2_GALIL_DRUM_MAGIN"},
		{time = 141/30, sound = "CW_KK_INS2_GALIL_DRUM_MAGHIT"},
		// { event 46 139 ""},
		{time = 144/30, sound = "CW_KK_INS2_UNIVERSAL_LEANIN"},
	},

	base_reloadempty = {
		{time = 21/30, sound = "CW_KK_INS2_STERLING_MAGRELEASE"},
		{time = 27/30, sound = "CW_KK_INS2_STERLING_MAGOUT"},
		{time = 46/30, sound = "CW_KK_INS2_GALIL_DRUM_MAGFETCH"},
		{time = 86/30, sound = "CW_KK_INS2_STERLING_MAGIN"},
		{time = 94/30, sound = "CW_KK_INS2_STERLING_MAGHIT"},
		// { event 46 125 ""},
		{time = 128/30, sound = "CW_KK_INS2_STERLING_BOLTBACK"},
	},

	base_reloadempty_drum = {
		{time = 28/30, sound = "CW_KK_INS2_GALIL_MAGRELEASE"},
		{time = 35/30, sound = "CW_KK_INS2_GALIL_DRUM_MAGOUT"},
		{time = 43/30, sound = "CW_KK_INS2_GALIL_DRUM_MAGOUTRATTLE"},
		{time = 65/30, sound = "CW_KK_INS2_GALIL_DRUM_MAGFETCH"},
		{time = 111/30, sound = "CW_KK_INS2_GALIL_DRUM_MAGIN"},
		{time = 141/30, sound = "CW_KK_INS2_GALIL_DRUM_MAGHIT"},
		{time = 161/30, sound = "CW_KK_INS2_GALIL_RATTLE"},
		{time = 171/30, sound = "CW_KK_INS2_STERLING_BOLTBACK"},
		// { event 46 169 ""},
		{time = 180/30, sound = "CW_KK_INS2_UNIVERSAL_LEANIN"},
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

	-- iron_fire_last = {
		-- // { event AE_MUZZLEFLASH 0 ""},
		-- // { event AE_CL_CREATE_PARTICLE_BRASS 0 ""},
	-- },

	iron_dryfire = {
		{time = 0/30, sound = "CW_KK_INS2_M14_EMPTY"},
	},

	iron_fireselect = {
		{time = 14/30, sound = "CW_KK_INS2_M14_FIRESELECT"},
	},

	iron_fireselect_empty = {
		{time = 14/30, sound = "CW_KK_INS2_M14_FIRESELECT"},
	},
}
