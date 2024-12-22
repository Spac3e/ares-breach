--[[


addons/[weapons]_no_260_kk_ins2/lua/weapons/cw_kk_ins2_cstm_kriss/sh_soundscript.lua

--]]

--[[
lua/weapons/cw_kk_ins2_cstm_kriss/sh_soundscript.lua
--]]

SWEP.Sounds = {
	base_ready = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_DRAW"},
		{time = 18/30, sound = "CW_KK_INS2_MP5K_BOLTLOCK"},
		{time = 23/30, sound = "CW_KK_INS2_MP5K_BOLTBACK"},
		{time = 35/30, sound = "CW_KK_INS2_MP5K_BOLTRELEASE"},
		{time = 50/30, sound = "CW_KK_INS2_GALIL_RATTLE"},
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
		{time = 0, sound = "CW_KK_INS2_MP5K_EMPTY"},
	},

	base_fireselect = {
		{time = 12/30, sound = "CW_KK_INS2_MP5K_FIRESELECT"},
	},

	base_reload = {
		{time = 18/31.89, sound = "CW_KK_INS2_MP5K_MAGRELEASE"},
		{time = 20/31.89, sound = "CW_KK_INS2_MP5K_MAGOUT"},
		{time = 66/31.89, sound = "CW_KK_INS2_MP5K_MAGIN"},
		-- { event 46 67 ""},
	},

	base_reloadempty = {
		{time = 18/30, sound = "CW_KK_INS2_MP5K_MAGRELEASE"},
		{time = 20/30, sound = "CW_KK_INS2_MP5K_MAGOUT"},
		{time = 76/30, sound = "CW_KK_INS2_MP5K_MAGIN"},
		-- { event 46 77 ""},
		{time = 99/30, sound = "CW_KK_INS2_GALIL_RATTLE"},
		{time = 107/30, sound = "CW_KK_INS2_MP5K_BOLTRELEASE"},
	},

	iron_dryfire = {
		{time = 0, sound = "CW_KK_INS2_MP5K_EMPTY"},
	},

	iron_fireselect = {
		{time = 12/30, sound = "CW_KK_INS2_MP5K_FIRESELECT"},
	},
}


