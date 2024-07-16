--[[


addons/[weapons]_no_260_kk_ins2/lua/weapons/cw_kk_ins2_cstm_m14/sh_soundscript.lua

--]]

--[[
lua/weapons/cw_kk_ins2_cstm_m14/sh_soundscript.lua
--]]

SWEP.Sounds = {
	base_ready = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_DRAW"},
		{time = 10/30, sound = "CW_KK_INS2_MINI14_BOLTBACK"},
		{time = 23/30, sound = "CW_KK_INS2_MINI14_BOLTRELEASE"},
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
		{time = 0, sound = "CW_KK_INS2_MINI14_EMPTY"},
	},

	base_fireselect = {
		{time = 13/30, sound = "CW_KK_INS2_M14_FIRESELECT"},
	},

	base_reload = {
		{time = 19/30, sound = "CW_KK_INS2_MINI14_MAGRELEASE"},
		{time = 23/30, sound = "CW_KK_INS2_MINI14_MAGOUT"},
		{time = 63/30, sound = "CW_KK_INS2_MINI14_MAGIN"},
		-- { event 46 65 ""},
	},

	base_reloadempty = {
		{time = 16/30, sound = "CW_KK_INS2_MINI14_MAGRELEASE"},
		{time = 23/30, sound = "CW_KK_INS2_MINI14_MAGOUT"},
		{time = 63/30, sound = "CW_KK_INS2_MINI14_MAGIN"},
		-- { event 46 65 ""},
		{time = 101/30, sound = "CW_KK_INS2_MINI14_BOLTBACK"},
		{time = 115/30, sound = "CW_KK_INS2_MINI14_BOLTRELEASE"},
	},

	iron_dryfire = {
		{time = 0, sound = "CW_KK_INS2_MINI14_EMPTY"},
	},

	iron_fireselect = {
		{time = 13/30, sound = "CW_KK_INS2_M14_FIRESELECT"},
	},

	foregrip_ready = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_DRAW"},
		{time = 10/30, sound = "CW_KK_INS2_MINI14_BOLTBACK"},
		{time = 23/30, sound = "CW_KK_INS2_MINI14_BOLTRELEASE"},
	},

	foregrip_draw = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_DRAW"},
	},

	foregrip_holster = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_HOLSTER"},
	},

	foregrip_crawl = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_LEFTCRAWL"},
		{time = 22/30, sound = "CW_KK_INS2_UNIVERSAL_RIGHTCRAWL"},
	},

	foregrip_dryfire = {
		{time = 0, sound = "CW_KK_INS2_MINI14_EMPTY"},
	},

	foregrip_fireselect = {
		{time = 13/30, sound = "CW_KK_INS2_M14_FIRESELECT"},
	},

	foregrip_reload = {
		{time = 19/30, sound = "CW_KK_INS2_MINI14_MAGRELEASE"},
		{time = 23/30, sound = "CW_KK_INS2_MINI14_MAGOUT"},
		{time = 63/30, sound = "CW_KK_INS2_MINI14_MAGIN"},
		-- { event 46 65 ""},
	},

	foregrip_reloadempty = {
		{time = 16/30, sound = "CW_KK_INS2_MINI14_MAGRELEASE"},
		{time = 23/30, sound = "CW_KK_INS2_MINI14_MAGOUT"},
		{time = 63/30, sound = "CW_KK_INS2_MINI14_MAGIN"},
		-- { event 46 65 ""},
		{time = 101/30, sound = "CW_KK_INS2_MINI14_BOLTBACK"},
		{time = 115/30, sound = "CW_KK_INS2_MINI14_BOLTRELEASE"},
	},

	foregrip_iron_dryfire_b = {
		{time = 0, sound = "CW_KK_INS2_MINI14_EMPTY"},
	},

	foregrip_iron_fireselect = {
		{time = 13/30, sound = "CW_KK_INS2_M14_FIRESELECT"},
	},
}


