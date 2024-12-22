--[[


addons/[weapons]_no_260_kk_ins2/lua/weapons/cw_cultist_submac_r3k/sh_soundscript.lua

--]]


SWEP.Sounds = {
	base_ready = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_DRAW"},
		{time = 24/30, sound = "CW_KK_INS2_UMP45_BOLTLOCK"},
		{time = 30/30, sound = "CW_KK_INS2_UMP45_BOLTRELEASE"},
	},

	base_draw = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_DRAW"},
	},

	base_holster = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_HOLSTER"},
	},

	base_dryfire = {
		{time = 0, sound = "CW_KK_INS2_UMP45_EMPTY"},
	},

	base_fireselect = {
		{time = 6/30, sound = "CW_KK_INS2_UMP45_FIRESELECT"},
	},

	base_reload = {
		{time = 19/30, sound = "CW_KK_INS2_UMP45_MAGRELEASE"},
		{time = 24/30, sound = "CW_KK_INS2_UMP45_MAGOUT"},
		{time = 71/30, sound = "CW_KK_INS2_UMP45_MAGIN"},
		{time = 84/30, sound = "CW_KK_INS2_M4A1_HIT"},
	},

	base_reloadempty = {
		{time = 19/30, sound = "CW_KK_INS2_UMP45_MAGRELEASE"},
		{time = 24/30, sound = "CW_KK_INS2_UMP45_MAGOUT"},
		{time = 71/30, sound = "CW_KK_INS2_UMP45_MAGIN"},
		{time = 101/30, sound = "CW_KK_INS2_UMP45_BOLTLOCK"},
		{time = 110/30, sound = "CW_KK_INS2_UMP45_BOLTRELEASE"},
	},

	iron_dryfire = {
		{time = 0, sound = "CW_KK_INS2_UMP45_EMPTY"},
	},

	iron_fireselect = {
		{time = 6/30, sound = "CW_KK_INS2_UMP45_FIRESELECT"},
	},

	base_crawl = {
		{time = 0/30, sound = "CW_KK_INS2_UNIVERSAL_LEFTCRAWL"},
		{time = 22/30, sound = "CW_KK_INS2_UNIVERSAL_RIGHTCRAWL"},
	},

}
