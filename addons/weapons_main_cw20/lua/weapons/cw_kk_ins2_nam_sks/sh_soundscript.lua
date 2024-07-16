--[[


addons/[weapons]_no_260_kk_ins2/lua/weapons/cw_kk_ins2_nam_sks/sh_soundscript.lua

--]]


SWEP.Sounds = {
	base_ready = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_DRAW"},
		{time = 20/30, sound = "CW_KK_INS2_SKS_BOLTBACK"},
		{time = 23/30, sound = "CW_KK_INS2_SKS_BOLTRELEASE"},
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
		{time = 0, sound = "CW_KK_INS2_SKS_EMPTY"},
	},

	base_reload = {
		{time = 19/30, sound = "CW_KK_INS2_SKS_MAGRELEASE"},
		{time = 25/30, sound = "CW_KK_INS2_SKS_BOLTBACK"},
		{time = 38/30, sound = "CW_KK_INS2_NAM_SKS_MAGFETCH"},
		{time = 86/30, sound = "CW_KK_INS2_NAM_SKS_MAGIN"},
		{time = 98/30, sound = "CW_KK_INS2_NAM_SKS_ROUNDSIN"},
		{time = 148/30, sound = "CW_KK_INS2_NAM_SKS_CLIPREMOVE"},
		{time = 158/30, sound = "CW_KK_INS2_NAM_SKS_STRIPPERCLIPEJECT"},
		{time = 179/30, sound = "CW_KK_INS2_SKS_BOLTRELEASE"},
		// { event 46 168 ""},
	},

	base_reloadempty = {
		// { event 46 138 ""},
		{time = 10/30, sound = "CW_KK_INS2_NAM_SKS_MAGFETCH"},
		{time = 54/30, sound = "CW_KK_INS2_NAM_SKS_MAGIN"},
		{time = 65/30, sound = "CW_KK_INS2_NAM_SKS_ROUNDSIN"},
		{time = 111/30, sound = "CW_KK_INS2_NAM_SKS_CLIPREMOVE"},
		{time = 125/30, sound = "CW_KK_INS2_NAM_SKS_STRIPPERCLIPEJECT"},
		{time = 144/30, sound = "CW_KK_INS2_SKS_BOLTBACK"},
		{time = 146/30, sound = "CW_KK_INS2_SKS_BOLTRELEASE"},
	},

	empty_draw = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_DRAW"},
	},

	empty_holster = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_HOLSTER"},
	},

	empty_crawl = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_LEFTCRAWL"},
		{time = 22/30, sound = "CW_KK_INS2_UNIVERSAL_RIGHTCRAWL"},
	},

	iron_dryfire = {
		{time = 0, sound = "CW_KK_INS2_SKS_EMPTY"},
	},

	foregrip_ready = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_DRAW"},
		{time = 10/30, sound = "CW_KK_INS2_SKS_BOLTBACK"},
		{time = 23/30, sound = "CW_KK_INS2_SKS_BOLTRELEASE"},
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
		{time = 0, sound = "CW_KK_INS2_SKS_EMPTY"},
	},

	foregrip_reloadempty = {
		{time = 16/30, sound = "CW_KK_INS2_SKS_MAGRELEASE"},
		{time = 24/30, sound = "CW_KK_INS2_SKS_MAGOUT"},
		{time = 67/30, sound = "CW_KK_INS2_SKS_MAGIN"},
		// { event 46 68 ""},
		{time = 101/30, sound = "CW_KK_INS2_SKS_BOLTBACK"},
		{time = 115/30, sound = "CW_KK_INS2_SKS_BOLTRELEASE"},
	},

	foregrip_reload = {
		{time = 16/30, sound = "CW_KK_INS2_SKS_MAGRELEASE"},
		{time = 24/30, sound = "CW_KK_INS2_SKS_MAGOUT"},
		{time = 65/30, sound = "CW_KK_INS2_SKS_MAGIN"},
		// { event 46 68 ""},
	},

	foregrip_iron_dryfire_b = {
		{time = 0, sound = "CW_KK_INS2_SKS_EMPTY"},
	},

	foregrip_empty_draw = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_DRAW"},
	},

	foregrip_empty_holster = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_HOLSTER"},
	},

	foregrip_empty_crawl = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_LEFTCRAWL"},
		{time = 22/30, sound = "CW_KK_INS2_UNIVERSAL_RIGHTCRAWL"},
	},
}
