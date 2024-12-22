--[[


addons/[weapons]_no_260_kk_ins2/lua/weapons/cw_kk_ins2_cstm_mp5a4/sh_soundscript.lua

--]]

--[[
lua/weapons/cw_kk_ins2_cstm_mp5a4/sh_soundscript.lua
--]]

SWEP.Sounds = {
	base_ready = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_DRAW"},
		{time = 12/30, sound = "CW_KK_INS2_MP5K_BOLTLOCK"},
		{time = 13/30, sound = "CW_KK_INS2_MP5K_BOLTRELEASE"},
	},

	base_draw = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_DRAW"},
	},

	base_holster = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_HOLSTER"},
	},

	base_dryfire = {
		{time = 0, sound = "CW_KK_INS2_MP5K_EMPTY"},
	},

	base_fireselect = {
		{time = 6/30, sound = "CW_KK_INS2_MP5K_FIRESELECT"},
	},

	base_reload = {
		{time = 19/30, sound = "CW_KK_INS2_MP5K_MAGRELEASE"},
		{time = 23/30, sound = "CW_KK_INS2_MP5K_MAGOUT"},
		{time = 69/30, sound = "CW_KK_INS2_MP5K_MAGIN"},
	},

	base_reloadempty = {
		{time = 12/30, sound = "CW_KK_INS2_MP5K_BOLTBACK"},
		{time = 18/30, sound = "CW_KK_INS2_MP5K_BOLTLOCK"},
		{time = 40/30, sound = "CW_KK_INS2_MP5K_MAGRELEASE"},
		{time = 46/30, sound = "CW_KK_INS2_MP5K_MAGOUT"},
		{time = 93/30, sound = "CW_KK_INS2_MP5K_MAGIN"},
		{time = 112/30, sound = "CW_KK_INS2_MP5K_BOLTLOCK"},
		{time = 114/30, sound = "CW_KK_INS2_MP5K_BOLTRELEASE"},
	},

	iron_dryfire = {
		{time = 0, sound = "CW_KK_INS2_MP5K_EMPTY"},
	},

	iron_fireselect = {
		{time = 6/30, sound = "CW_KK_INS2_MP5K_FIRESELECT"},
	},

	base_crawl = {
		{time = 0/30, sound = "CW_KK_INS2_UNIVERSAL_LEFTCRAWL"},
		{time = 22/30, sound = "CW_KK_INS2_UNIVERSAL_RIGHTCRAWL"},
	},
}


