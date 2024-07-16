--[[


addons/[weapons]_no_260_kk_ins2/lua/weapons/cw_kk_ins2_cstm_g36c/sh_soundscript.lua

--]]

--[[
lua/weapons/cw_kk_ins2_cstm_g36c/sh_soundscript.lua
--]]
/*
SWEP.Sounds = {
	base_ready = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_DRAW"},
		{time = 17/30, sound = "CW_KK_INS2_FNFAL_BOLTBACK"},
		{time = 27/30, sound = "CW_KK_INS2_FNFAL_BOLTRELEASE"},
	},

	base_draw = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_DRAW"},
	},

	base_holster = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_HOLSTER"},
	},

	base_crawl = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_LEFTCRAWL"},
		{time = 30/30, sound = "CW_KK_INS2_UNIVERSAL_RIGHTCRAWL"},
	},

	base_dryfire = {
		{time = 0, sound = "CW_KK_INS2_MK18_EMPTY"},
	},

	base_fireselect = {
		{time = 8/30, sound = "CW_KK_INS2_MK18_FIRESELECT"},
	},

	base_reload = {
		{time = 39/30, sound = "CW_KK_INS2_FNFAL_MAGOUT"},
		{time = 56/30, sound = "CW_KK_INS2_FNFAL_RATTLE"},
		{time = 69/30, sound = "CW_KK_INS2_FNFAL_MAGIN"},
		-- { event 46 69 ""},
	},

	base_reloadempty = {
		{time = 39/30, sound = "CW_KK_INS2_FNFAL_MAGOUT"},
		{time = 56/30, sound = "CW_KK_INS2_FNFAL_RATTLE"},
		{time = 69/30, sound = "CW_KK_INS2_FNFAL_MAGIN"},
		-- { event 46 76 ""},
		{time = 96/30, sound = "CW_KK_INS2_FNFAL_BOLTBACK"},
		{time = 106/30, sound = "CW_KK_INS2_FNFAL_BOLTRELEASE"},
	},

	iron_dryfire = {
		{time = 0, sound = "CW_KK_INS2_MK18_EMPTY"},
	},

	iron_fireselect = {
		{time = 8/30, sound = "CW_KK_INS2_MK18_FIRESELECT"},
	},

	foregrip_ready = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_DRAW"},
		{time = 17/30, sound = "CW_KK_INS2_FNFAL_BOLTBACK"},
		{time = 27/30, sound = "CW_KK_INS2_FNFAL_BOLTRELEASE"},
	},

	foregrip_draw = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_DRAW"},
	},

	foregrip_holster = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_HOLSTER"},
	},

	foregrip_crawl = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_LEFTCRAWL"},
		{time = 30/30, sound = "CW_KK_INS2_UNIVERSAL_RIGHTCRAWL"},
	},

	foregrip_dryfire = {
		{time = 0, sound = "CW_KK_INS2_MK18_EMPTY"},
	},

	foregrip_fireselect = {
		{time = 8/30, sound = "CW_KK_INS2_MK18_FIRESELECT"},
	},

	foregrip_iron_dryfire_b = {
		{time = 0, sound = "CW_KK_INS2_MK18_EMPTY"},
	},

	foregrip_iron_fireselect = {
		{time = 8/30, sound = "CW_KK_INS2_MK18_FIRESELECT"},
	},

	foregrip_reload = {
		{time = 39/30, sound = "CW_KK_INS2_FNFAL_MAGOUT"},
		{time = 56/30, sound = "CW_KK_INS2_FNFAL_RATTLE"},
		{time = 69/30, sound = "CW_KK_INS2_FNFAL_MAGIN"},
		-- { event 46 69 ""},
	},

	foregrip_reloadempty = {
		{time = 39/30, sound = "CW_KK_INS2_FNFAL_MAGOUT"},
		{time = 56/30, sound = "CW_KK_INS2_FNFAL_RATTLE"},
		{time = 69/30, sound = "CW_KK_INS2_FNFAL_MAGIN"},
		-- { event 46 76 ""},
		{time = 96/30, sound = "CW_KK_INS2_FNFAL_BOLTBACK"},
		{time = 106/30, sound = "CW_KK_INS2_FNFAL_BOLTRELEASE"},
	},
} */

// new anims

SWEP.Sounds = {
	base_ready = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_DRAW"},
		{time = 31/30, sound = "CW_KK_INS2_FNFAL_BOLTBACK"},
		{time = 42/30, sound = "CW_KK_INS2_FNFAL_BOLTRELEASE"},
	},

	base_draw = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_DRAW"},
	},

	base_holster = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_HOLSTER"},
	},

	base_crawl = {
		{time = 2/30, sound = "CW_KK_INS2_UNIVERSAL_LEFTCRAWL"},
		{time = 29/30, sound = "CW_KK_INS2_UNIVERSAL_RIGHTCRAWL"},
	},

	base_dryfire = {
		{time = 0, sound = "CW_KK_INS2_MK18_EMPTY"},
	},

	base_fireselect = {
		{time = 8/30, sound = "CW_KK_INS2_MK18_FIRESELECT"},
	},

	base_reload = {
		{time = 27/30, sound = "CW_KK_INS2_FNFAL_MAGOUT"},
		{time = 79/30, sound = "CW_KK_INS2_FNFAL_RATTLE"},
		{time = 93/30, sound = "CW_KK_INS2_FNFAL_MAGIN"},
		-- { event 46 69 ""},
	},

	base_reloadempty = {
		{time = 28/30, sound = "CW_KK_INS2_FNFAL_MAGOUT"},
		{time = 72/30, sound = "CW_KK_INS2_FNFAL_RATTLE"},
		{time = 84/30, sound = "CW_KK_INS2_FNFAL_MAGIN"},
		-- { event 46 76 ""},
		{time = 107/30, sound = "CW_KK_INS2_FNFAL_BOLTBACK"},
		{time = 117/30, sound = "CW_KK_INS2_FNFAL_BOLTRELEASE"},
	},

	iron_dryfire = {
		{time = 0, sound = "CW_KK_INS2_MK18_EMPTY"},
	},

	iron_fireselect = {
		{time = 8/30, sound = "CW_KK_INS2_MK18_FIRESELECT"},
	},

	foregrip_ready = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_DRAW"},
		{time = 31/30, sound = "CW_KK_INS2_FNFAL_BOLTBACK"},
		{time = 42/30, sound = "CW_KK_INS2_FNFAL_BOLTRELEASE"},
	},

	foregrip_draw = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_DRAW"},
	},

	foregrip_holster = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_HOLSTER"},
	},

	foregrip_crawl = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_LEFTCRAWL"},
		{time = 30/30, sound = "CW_KK_INS2_UNIVERSAL_RIGHTCRAWL"},
	},

	foregrip_dryfire = {
		{time = 0, sound = "CW_KK_INS2_MK18_EMPTY"},
	},

	foregrip_fireselect = {
		{time = 8/30, sound = "CW_KK_INS2_MK18_FIRESELECT"},
	},

	foregrip_iron_dryfire_b = {
		{time = 0, sound = "CW_KK_INS2_MK18_EMPTY"},
	},

	foregrip_iron_fireselect = {
		{time = 8/30, sound = "CW_KK_INS2_MK18_FIRESELECT"},
	},

	foregrip_reload = {
		{time = 27/30, sound = "CW_KK_INS2_FNFAL_MAGOUT"},
		{time = 79/30, sound = "CW_KK_INS2_FNFAL_RATTLE"},
		{time = 93/30, sound = "CW_KK_INS2_FNFAL_MAGIN"},
		-- { event 46 69 ""},
	},

	foregrip_reloadempty = {
		{time = 28/30, sound = "CW_KK_INS2_FNFAL_MAGOUT"},
		{time = 72/30, sound = "CW_KK_INS2_FNFAL_RATTLE"},
		{time = 84/30, sound = "CW_KK_INS2_FNFAL_MAGIN"},
		-- { event 46 76 ""},
		{time = 107/30, sound = "CW_KK_INS2_FNFAL_BOLTBACK"},
		{time = 117/30, sound = "CW_KK_INS2_FNFAL_BOLTRELEASE"},
	},
}


